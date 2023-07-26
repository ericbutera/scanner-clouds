#!/bin/bash

NUM_HOSTED_ZONES=200

for i in {1..NUM_HOSTED_ZONES} ; do
    DOMAIN="example$(date +%Y%m%d%H%M%S)-$RANDOM.com"
    HOSTED_ZONE_OUTPUT=$(awslocal route53 create-hosted-zone --name "$DOMAIN")
    HOSTED_ZONE_ID=$(echo "$HOSTED_ZONE_OUTPUT" | jq -r '.HostedZone.Id')
    IP_ADDRESS="$(( ( RANDOM % 256 ) )).$(( ( RANDOM % 256 ) )).$(( ( RANDOM % 256 ) )).$(( ( RANDOM % 256 ) ))"
    awslocal route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --change-batch '{"Changes": [{"Action": "CREATE","ResourceRecordSet": {"Name": "subdomain.'$DOMAIN'","Type": "A","TTL": 300,"ResourceRecords": [{"Value": "'$IP_ADDRESS'"}]}}]}'
done

echo "all done"
