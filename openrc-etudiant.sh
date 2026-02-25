#!/bin/bash

# To use an Openstack cloud you need to authenticate against keystone, which
# returns a **Token** and **Service Catalog**. The catalog contains the
# endpoint for all services the user/tenant has access to - including nova,
# glance, keystone, swift.
#
export OS_AUTH_URL=https://auth.cloud.ovh.net/v3
export OS_IDENTITY_API_VERSION=3

#export OS_USER_DOMAIN_NAME=${OS_USER_DOMAIN_NAME:-"Default"}
#export OS_PROJECT_DOMAIN_NAME=${OS_PROJECT_DOMAIN_NAME:-"Default"}


# With the addition of Keystone we have standardized on the term **tenant**
# as the entity that owns the resources.
export OS_TENANT_ID=cb2c5a2117f647c8b3dacd6e06471f5f
export OS_TENANT_NAME="8697178539611767"

# In addition to the owning entity (tenant), openstack stores the entity
# performing the action as the **user**.
export OS_USERNAME="user-UZ9BXJKC6v6Q"

# With Keystone you pass the keystone password.
export OS_PASSWORD=S9r53uYZcTYSwHQxErSS5bbXdAgpzbRx

# If your configuration has multiple regions, we set that information here.
# OS_REGION_NAME is optional and only valid in certain environments.
export OS_REGION_NAME="SBG5"
