# Kubernetes Multi-Cluster Config Management with CSP

Copyright 2019 Google LLC. This software is provided as-is, without warranty or representation for any use or purpose. Your use of it is subject to your agreements with Google. This is NOT a Google official product.


This demo will utilize CSP Config Management to sync ClusterRoles and Namespaces across multiple clusters. It will also apply an Aggregate Resource Quota that will be collectively enforced across a group of namespaces in each cluster.

## Requirements

* 2 <= GKE Clusters
* gcloud
* kubectl
* ssh-keygen
* GitHub account

## Setup

<<<<<<< HEAD
Fork this repository and clone your fork to begin this demo.
```git clone https://github.com/GIT_USER/csp-config-management.git
=======
Fork this repository, and clone your fork to begin this demo.
```
# Fork this repository first.

USER=$(git config --global user.name)
git clone https://github.com/$USER/csp-config-management.git
>>>>>>> dc0971743039d8d96a52e481d1aff58bb39d27ea
```

We will start by installing the necessary tooling on our workstation for our automation to successfully complete this demo. kubectx is a CLI tool that allows you to quickly navigate between Kubernetes Contexts; kubens is a CLI tool that allows you to quickly navigate between Kubernetes Namespaces. The recommended workstation for this demo is the [Google Cloud Shell](https://cloud.google.com/shell/docs/). Run the below commands.

<<<<<<< HEAD
```curl https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx > kubectx && curl https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens > kubens && chmod u+x kubectx kubens && sudo mv kubectx /usr/local/bin && sudo mv kubens /usr/local/bin
```

This repository assumes you already have multiple Kubernetes clusters in your kubeconfig on your local worksation. If you have not yet provisioned Kubernetes clusters, you can find the GKE quickstart [here](https://cloud.google.com/kubernetes-engine/docs/quickstart). Create multiple clusters, configure kubectl to access these clusters, and then return to these instructions.
=======
```
curl https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx > kubectx && curl https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens > kubens && chmod u+x kubectx kubens && sudo mv kubectx /usr/local/bin && sudo mv kubens /usr/local/bin
```

This demo assumes you already have multiple GKE clusters in your kubeconfig on your local worksation. If you have not yet provisioned these clusters, you can find the GKE quickstart [here](https://cloud.google.com/kubernetes-engine/docs/quickstart). Create 2 <= clusters, configure kubectl to access these clusters, and then return to these instructions.
>>>>>>> dc0971743039d8d96a52e481d1aff58bb39d27ea

Once you have Kubernetes clusters in your local kubeconfig, navigate to `/setup`, make our setup.sh executable, and run it. 

<<<<<<< HEAD
> Note that this script WILL deploy CSP Config Management to all clusters configured in your kubeconfig. The recommendation here is to run this with demo/sandbox clusters to optimize for learning while minimizing risk.

```cd setup && chmod +x setup.sh```
=======
```
cd setup && chmod +x setup.sh  && ./setup.sh
```
>>>>>>> dc0971743039d8d96a52e481d1aff58bb39d27ea

## TODO
* Write bash or terraform to set up GKE clusters
* Write test scripts to demonstrate AggregateResourceQuota
* Update setup with proper nomos-operator URL
* Create ClusterRegistry resources
