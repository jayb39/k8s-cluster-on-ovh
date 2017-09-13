##############
# Keypair ressources 
# Provide here informations about your SSH local key pairs, <name> and <public_key> (.pub)
##############

resource "openstack_compute_keypair_v2" "mykeypair" {
  provider = "openstack.ovh"
  name = "yourkeypairname"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFZSR..."
}



##############
# Kubernetes Master deployment 
# Here we deploy a cloud instance type S1-4 running Ubuntu to host the kubernetes master
# Specific Kubernetes packages are deployed through remote-exec session, 
# provide path to your <private_key> to avoid typing password in process. 
##############

resource "openstack_compute_instance_v2" "kubeclustermaster" {
  name = "kubemaster"
  count = 1
  provider = "openstack.ovh"
  image_name = "Ubuntu 16.04"
  flavor_name = "s1-4"
  key_pair = "mykeypair"
  network {
    name = "Ext-Net"
  }
  provisioner "remote-exec" {
    connection {
       type = "ssh"
       user = "ubuntu"
       agent = "false"
       private_key = "${file("/pathtoyourssklocalkeys/.ssh/id_rsa")}"
    }
    inline = [
      "sudo apt-get update && sudo apt-get install -y apt-transport-https",
      "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "echo \"echo \"deb http://apt.kubernetes.io/ kubernetes-xenial main\" >> /etc/apt/sources.list.d/kubernetes.list\" | sudo -s",
      "sudo apt-get update",
      "sudo apt-get install -y docker.io kubeadm kubectl kubelet kubernetes-cni",
      "sudo kubeadm init",
      "mkdir -p $HOME/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown ubuntu:ubuntu $HOME/.kube/config",
      "kubectl apply --filename https://git.io/weave-kube-1.6",
      "sudo kubeadm token list | grep token | awk '{ print $1 }' > /home/ubuntu/token"
    ]
  }
  provisioner "local-exec"{
    command = "scp -o StrictHostKeyChecking=no  -o UserKnownHostsFile=/dev/null ubuntu@${openstack_compute_instance_v2.kubeclustermaster.access_ip_v4}:/home/ubuntu/token ."
  }
}

##############
# Kubernetes Nodes (Minions) deployment x2
# Here we deploy 2 cloud instances type S1-4 running Ubuntu to host the kubernetes minions
# Specific Kubernetes packages are deployed through remote-exec session, same as for master
# provide path to your <private_key> to avoid typing password in process.
##############


resource "openstack_compute_instance_v2" "kubeclusterminions" {
  name = "kubenode${count.index+1}"
  count = 2
  provider = "openstack.ovh"
  image_name = "Ubuntu 16.04"
  flavor_name = "s1-4"
  key_pair = "mykeypair"
  network {
    name = "Ext-Net"
  }
 
 provisioner "file" {
    source      = "./token"
    destination = "/home/ubuntu/token"
    connection {
       type = "ssh"
       user = "ubuntu"
       agent = "false"
       private_key = "${file("/Pathtoyoursshlocalkeys/.ssh/id_rsa")}"
    } 
 }
 provisioner "remote-exec" {
    connection {
       type = "ssh"
       user = "ubuntu"
       agent = "false"
       private_key = "${file("/Pathtoyoursshlocalkeys/.ssh/id_rsa")}"
    }
    inline = [
     "sudo apt-get update && sudo apt-get install -y apt-transport-https",
     "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
     "echo \"echo \"deb http://apt.kubernetes.io/ kubernetes-xenial main\" >> /etc/apt/sources.list.d/kubernetes.list\" | sudo -s",
     "sudo apt-get update",
     "sudo apt-get install -y docker.io kubeadm kubectl kubelet kubernetes-cni", 
     "sudo kubeadm join --token=$(cat /home/ubuntu/token) ${openstack_compute_instance_v2.kubeclustermaster.access_ip_v4}:6443"
    ]
 }
}
