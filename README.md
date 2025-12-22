# Kubernetes_Lab
# Summary
A re-build of the original cluster setup for home use. The goal of this lab is to shift away from the Vagrant and Virtualbox setup and move towards a HyperV and OpenTofu setup. The reason for this is rooted in the issue that after Ubuntu 24.04 came out, the support for Vagrant got dropped (https://askubuntu.com/questions/1520083/are-there-vagrant-boxes-for-recent-ubuntu-releases) and thus had to re-build the lab in order to allow for deployments in CRI-O to go without issue.

# Overview of the custom ISO and Kubernetes install
The lab consists of two main sections, the custom ISO build (mainly to avoid the UI in the HyperV setup) and the actual provisioning and setup of Kubernetes with CRI-O.

The first section will be a basic breakdown of the usage of xorriso and the commands used for setting up the custom ISO including a rudimentary rundown of the file and what it's used for (pending future notes on the workings of the file).
Important to note that this won't be a full run down on the capabilities, just a general description of what's being done.

The second section will detail the provisioning and outline the reasoning of why CRI-O was used and how it was setup in this iteration of the lab.

## Custom ISO setup
-Notes to be added-

## Kubernetes Install
-Notes to be added-
