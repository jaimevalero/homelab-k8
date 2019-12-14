#! /bin/bash

# Create record for a go daddy account
API_KEY="<replace-for-you-api-key>"
API_SECRET="<replace-for-your-api-secret>"

#DOMAIN='mageiacreaciones.com'
#SUBDOMAIN='dev'
#TYPE=CNAME
#DATE="kvm.magiacreaciones.com"
source ./.credentials
# credentials contains api from go daddy (production environment)
# End of configurable parameters

source ./go_daddy_library.sh


DOMAIN="$1"
SUBDOMAIN="$2"
TYPE="$3"
DATA="$4"

Set_Record     \
  "$DOMAIN"    \
  "$TYPE"      \
  "$SUBDOMAIN" \
  "$DATA"
