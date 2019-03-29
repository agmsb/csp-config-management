# Copyright 2019, Google, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#!/bin/bash

source ./config.sh

printf "Let's get set up with CSP Config Management. \n"

sleep 2

printf "Ensure you have the cluster-admin clusterrole. \n"

for cluster in $(kubectx); 
do 
    kubectx $cluster && kubectl create clusterrolebinding cluster-admin-binding \
      --clusterrole cluster-admin --user $GCP_USER; 
done

sleep 2

printf "Deploy the CSP Config Management operator across your Kubernetes clusters. \n"

for cluster in $(kubectx); 
do 
    kubectx $cluster && kubectl apply --filename nomos-operator.yaml; 
done 

printf "Observe the resources created across both clusters. \n"

sleep 2 

printf "Create an exclusive SSH keypair for the Config Management Operator and add your key to your SSH agent. \n"

ssh-keygen -t rsa -N '' -b 4096 -C "$GCP_USER" \
    -f $HOME/.ssh/id_rsa.nomos

ssh-add ~./ssh/id_rsa.nomos

sleep 2

printf "Create the secret for your private key in your Kubernetes clusters. \n"

for cluster in $(kubectx); 
do
kubectx $cluster && kubectl create secret generic git-creds -n=config-management-system \
    --from-file=ssh=$HOME/.ssh/id_rsa.nomos;
done

sleep 2

printf "Log in to Github and fork https://github.com/agmsb/csp-config-management."

read -n 1 -s -r -p "Once you have forked https://github.com/agmsb/csp-config-management, press any key to continue."

sleep 3

printf "\n"
printf "Copy the below public key and paste it in GitHub > Settings > SSH and GPG keys > New SSH key \n\n"

sleep 1 

cat ~/.ssh/id_rsa.nomos.pub

read -n 1 -s -r -p "Once you have updated your GitHub SSH keys, press any key to continue."

sleep 2

cd ../initech-corp/system

sleep 2

printf "\n"

sleep 1 

printf "Update the configuration file for the Config Management Custom Resource. \n"

for cluster in $(kubectx);
do
    cat << EOF >> $cluster-config-management.yaml
apiVersion: addons.sigs.k8s.io/v1alpha1
kind: ConfigManagement
metadata:
    name: config-management
    namespace: config-management-system
spec:
    clusterName: $cluster
    git:
        syncRepo: git@github.com:$GIT_USER/csp-config-management.git
        syncBranch: master
        secretType: ssh
        policyDir: "initech-corp"
enableAggregateNamespaceQuotas: true
EOF
done

sleep 2

printf "Apply the ConfigManagement Custom Resource to each of your clusters.\n"

for cluster in $(kubectx); 
do
    kubectx $cluster && kubectl apply -f ./$cluster-config-management.yaml -n config-management-system; 
done

cat << EOM

CSP Config Managemeent should have propagated the below resources into each of your clusters:

* ClusterRole named pod-admin with permissive role to manage pods.
* Five dev-* Namespaces. This is made possible via initech-corp/namespaces/dev/dev-*, with one for each namespace.
* One Aggregated Resource Quota. This is made possible via Abstract Namespaces in initech-corp/namespaces/dev. All namespaces in this Abstract Namespace contribute and are held to this shared quota.
* One staging Namespace. This is made possible via initech-corp/namespaces/staging

For all of the configs to propagate, this script will wait for 3 minutes.

EOM

sleep 120

cat << EOM

Observe the ClusterRole in each cluster.

EOM

for cluster in $(kubectx);
do
    kubectx $cluster && kubectl get clusterrole pod-admin
done

sleep 10

cat << EOM

Observe the namespaces in each cluster.

EOM

sleep 10

for cluster in $(kubectx);
do
    kubectx $cluster && kubens;
done

sleep 10


cat << EOM

Observe the Resource Quota in each cluster.

EOM

for cluster in $(kubectx);
do
    kubectx $cluster && kubectl describe resourcequota
done 