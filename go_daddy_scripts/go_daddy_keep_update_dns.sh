#! /bin/bash

# Updates a dns register with go daddy, with the current ip
# Put this script in a cron, and you get a dyn dns
API_KEY="<replace-for-you-api-key>"
API_SECRET="<replace-for-your-api-secret>"
DOMAIN='mageiacreaciones.com'
SUBDOMAIN='kvm'
source ./.credentials
# credentials contains api from go daddy (production environment)
# End of configurable parameters
customerId=""
MY_IP=""



Get_Records()
{
  DOMAIN="$1"
  Get_Customer_ID
  curl -s -X GET -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
  "https://api.godaddy.com/v2/customers/${customerId}/domains/${DOMAIN}/records" | jq -c .[]
}

Get_Record()
{
  DOMAIN="$1"
  TYPE=$2
  SUBDOMAIN=$3

  Get_Customer_ID 1>/dev/null 2>/dev/null
  curl -s -X GET -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
  "https://api.godaddy.com/v2/customers/${customerId}/domains/${DOMAIN}/records/$TYPE/$SUBDOMAIN" | jq  -r .[0].data

}

#### Mira la ip
Get_My_IP()
{
  curl -s 'https://api.ipify.org'
}

### Main
Main()
{
# Get Data
CURRENT_IP=`Get_My_IP`
DNS_IP=`Get_Record "$DOMAIN" "A" "$SUBDOMAIN"`

echo CURRENT_IP=$CURRENT_IP=
echo DNS_IP=$DNS_IP=

#if (current_ip != dns_ip) then dns_ip = current_ip
if [ "$CURRENT_IP" != "$DNS_IP" ]
then
  echo           "We update the $DNS_IP to $CURRENT_IP"
  Set_Record     "$DOMAIN" "A" "$SUBDOMAIN" "$CURRENT_IP"
  # Check change has been done
  NEW_IP=`       Get_Record "$DOMAIN" "A" "$SUBDOMAIN"`
  echo           "New DNS record is $SUBDOMAIN.$DOMAIN : $NEW_IP"
else
  echo "Nothing to do. Both IP are equal"
fi
}

source ./go_daddy_library.sh

Main
