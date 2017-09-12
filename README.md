# Deploy Kubernetes Cluster on OVH using Terraform

Here is a basic setup to deploy a Kubernetes cluster (one master + 2 nodes or 2 minions) using Terraform on OVH public cloud (Openstack based platform). Terraform is a great tool for deploying cloud instances on multiple cloud providers (AWS, Digital Ocean, Google Cloud, OpenStack ...), checkout [Hashicorp](https://www.terraform.io) website for more details about the use cases you can achieve with it.

## Pre-Requisite

**Terraform**

Install Terraform on your laptop or build server following instructions given by Hashicorp [here](https://www.terraform.io/intro/getting-started/install.html)

**OVH**

In order to use OVH Openstack APIs you will need to create specific user credentials in the OVH manager console. (Go to your cloud project, openstack menu, create a user)

**SSH KeyPairs**

Terraform will need a reference to a key pair on its hosts, so it can connect to the various instances in a secure way and without having to ask you for server passwords everytime. If you don't know how to create a key pair, follow this [link](https://www.ovh.co.uk/g1769.creating_ssh_keys). 

## How-To Use it



