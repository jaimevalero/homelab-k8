#! /bin/bash

# Common functions to be used from other scripts

FICHERO_TRAZA=/tmp/`basename $0`.log

Log( )
{
  echo "[`basename $0`] [`date +'%Y-%m-%d %H:%M:%S'`] [$$] [${FUNCNAME[1]}] $@" | /usr/bin/tee -a $FICHERO_TRAZA
}



Get_Customer_ID()
{
  customerId=`curl  -s -k   -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
  "https://api.godaddy.com/v1/shoppers/${CUSTOMER_ID}?includes=customerId" | jq -r .customerId `
  Log customerId=$customerId
}

Set_Record()
{
  DOMAIN="$1"
  TYPE="$2"
  SUBDOMAIN="$3"
  DATA="$4"
  Get_Customer_ID
  echo "
  {
    \"data\": \"${DATA}\",
    \"ttl\": 600
  }" | jq -s . | \
  curl -s  --data @- \
    -X PUT \
    -H "Content-Type: application/json" \
    -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
  "https://api.godaddy.com/v2/customers/${customerId}/domains/${DOMAIN}/records/${TYPE}/${SUBDOMAIN}" | jq .

nslookup ${SUBDOMAIN}.${DOMAIN} NS43.DOMAINCONTROL.COM
}
