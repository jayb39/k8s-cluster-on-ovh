##############
# Enter your user_name and password provided 
# by OVH for their OpenStack based public cloud platform
##############

provider "openstack" {
  auth_url = "https://auth.cloud.ovh.net/v3"
  domain_name = "default"
  alias = "ovh"
  user_name   = "your-user-name"
  password    = "your-password"
  region = "GRA3"
}


