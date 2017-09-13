##############
# Terraform outputs, we are returning here public ip to access your Master and your nodes or Minions.
# This is executed once all instances and associated remote_exec scripts are done
##############


output master-ip {
   value = "${openstack_compute_instance_v2.kubeclustermaster.access_ip_v4}"
}

output minions-ip {
   value = "${openstack_compute_instance_v2.kubeclusterminions.*.access_ip_v4}"
}
