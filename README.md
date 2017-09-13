# Deploy Kubernetes Cluster on OVH using Terraform

Here is a basic setup to deploy a Kubernetes cluster (one master + 2 nodes or 2 minions) using Terraform on OVH public cloud (Openstack based platform). Terraform is a great tool for deploying cloud instances on multiple cloud providers (AWS, Digital Ocean, Google Cloud, OpenStack ...), checkout [Hashicorp](https://www.terraform.io) website for more details about the use cases you can achieve with it. **Note : This is NOT a production ready setup, check Kubeadm alpha restriction and concerns**

## Pre-Requisite

**Terraform**

Install Terraform on your laptop or build server following instructions given by Hashicorp [here](https://www.terraform.io/intro/getting-started/install.html)

**OVH**

In order to use OVH Openstack APIs you will need to create specific user credentials in the OVH manager console. (Go to your cloud project, openstack menu, create a user)

**SSH KeyPairs**

Terraform will need a reference to a key pair on its hosts, so it can connect to the various instances in a secure way and without having to ask you for server passwords everytime. If you don't know how to create a key pair, follow this [link](https://www.ovh.co.uk/g1769.creating_ssh_keys). 

## HOWTO start it

**1. Specify your own credentials**

Specify your credentials , edit *provider.tf* file with your personal credentials, aka "username" and "password"

Edit *ressources.tf* with your keypair "name", <public_key> and the path to your "private_key" to deploy Kubernetes packages through remote-exec connection process. 

**2. Create your infrastructure**

Use the following command to start building your infrastructure,
```
terraform apply
```
Terraform will first, 
Connect to the OVH provider using the credentials you provided in 1. , 
  Export your SSH keypair to an Openstack object,
   Create an Ubuntu instance for Kubernetes master,
    Download associated repo packages,
    Initialize Kube master
    Get back the join token in a local file
   Create 2 Ubuntu instances for Kubernetes nodes or minions,
    Download associated repo packages,
    Connect the 2 nodes to master using the token provided by the master instance
Return public ips of master and nodes
DONE

**3. Destroy your infrastructure**

You can destroy all the objects created in 2. using the following command : 
```
terraform destroy
```

And redo it as much as you want !
