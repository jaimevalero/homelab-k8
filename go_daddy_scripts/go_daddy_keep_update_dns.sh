#! /bin/bash

# Updates a dns register with go daddy, with the current ip
# Put this script in a cron, and you get a dyn dns
API_KEY="<replace-for-you-api-key>"
API_SECRET="<replace-for-your-api-secret>"
CUSTOMER_ID="<replace-for-your-customer-number>"

export DOMAIN='mageiacreaciones.com'
export SUBDOMAIN='kvm'


# credentials contains api from go daddy (production environment)
# End of configurable parameters
export customerId=""
export MY_IP=""


WORKING_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $WORKING_PATH  >/dev/null 2>&1
source ./.credentials

#Get_Records()
#{
#  DOMAIN="$1"
#  Get_Customer_ID #1>/dev/null 2>/dev/null
#  curl -s -X GET -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
#  "https://api.godaddy.com/v2/customers/${customerId}/domains/${DOMAIN}/records" | jq -c .[]
#}

Get_Record()
{
  DOMAIN="$1"
  TYPE="$2"
  SUBDOMAIN="$3"

  Get_Customer_ID 1>/dev/null 2>/dev/null
  curl -s -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
  "https://api.godaddy.com/v2/customers/${customerId}/domains/${DOMAIN}/records/$TYPE/$SUBDOMAIN" | grep -e data.* | cut -d\" -f4

}

#### Mira la ip
Get_My_IP()
{
  curl -s 'https://api.ipify.org'
}

### Main
Main()
{
Log "Start"
# Get Data
CURRENT_IP=`Get_My_IP`

Log "DOMAIN=$DOMAIN= SUBDOMAIN=$SUBDOMAIN= customerId=$customerId= "
DNS_IP=`Get_Record "$DOMAIN" "A" "$SUBDOMAIN"`

Log CURRENT_IP=$CURRENT_IP=
Log DNS_IP=$DNS_IP=

#if (current_ip != dns_ip) then dns_ip = current_ip
if [ "$CURRENT_IP" != "$DNS_IP" ]
then
  Log         "We update the $DNS_IP to $CURRENT_IP"
  Set_Record  "$DOMAIN" "A" "$SUBDOMAIN" "$CURRENT_IP"
  # Check change has been done
  NEW_IP=`    Get_Record "$DOMAIN" "A" "$SUBDOMAIN"`
  Log         "New DNS record is $SUBDOMAIN.$DOMAIN : $NEW_IP"
else
  Log "Nothing to do. Both IP are equal"
fi

Log "End"

}

source ./go_daddy_library.sh

Main
