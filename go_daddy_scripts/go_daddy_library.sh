#! /bin/bash

# Common functions to be used from other scripts

FICHERO_TRAZA=/tmp/`basename $0`.log

Log( )
{
  echo "[`basename $0`] [`date +'%Y-%m-%d %H:%M:%S'`] [$$] [${FUNCNAME[1]}] $@" | /usr/bin/tee -a $FICHERO_TRAZA
}



Get_Customer_ID()
{
  Log API_KEY=${API_KEY}= API_SECRET=${API_SECRET}= CUSTOMER_ID=${CUSTOMER_ID}=
  #customerId=` curl -s -k -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
  #"https://api.godaddy.com/v1/shoppers/${CUSTOMER_ID}?includes=customerId" | jq -r .customerId `
  #Log customerId=$customerId
  FILE=`mktemp`

  echo "curl -s -k -H 'Authorization: sso-key ${API_KEY}:${API_SECRET}' 'https://api.godaddy.com/v1/shoppers/${CUSTOMER_ID}?includes=customerId' " > $FILE
  chmod +x $FILE ;
  Log Contens of $FILE : `cat $FILE`
  $FILE > kk


  customerId=`cat kk  | grep -o 'customerId.*' | cut -d\" -f3`
  rm -f  $FILE kk

  Log "customerId=${customerId}="

}

Set_Record()
{
  DOMAIN="$1"
  TYPE="$2"
  SUBDOMAIN="$3"
  DATA="$4"
  [ ${#customerId} -eq 0 ] && Get_Customer_ID #1>/dev/null 2>/dev/null
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
