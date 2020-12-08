#!/bin/sh

# set -x
set -e

curl="curl --connect-timeout 1 --silent"
# curl="curl --connect-timeout 1 --trace -"

wi_ip=$(dig wifionice.de @172.18.0.1 +short +timeout=1)
wi_url='http://'$wi_ip'/de/'
wi_token=$($curl $wi_url | xmllint --html --xpath 'string(//input[@name="CSRFToken"]/@value)' - )
[[ -n $wi_token ]]  || { echo "Failed to acquire csrf-token." ; exit 1 ; }
echo "csrf-token = $wi_token"

$curl $wi_url -H 'Cookie: csrf='$wi_token --data 'login=true&CSRFToken='$wi_token 

ping -W 1 -i 0.2 -c 2 9.9.9.9 && logger "wifi-on-ice is connected to CloudFlare."

# typeset -F 2 usage=$(($($curl -s 'http://www.wifionice.de/usage_info/') * 100.0 )) 
# echo $usage\%
# 	sleep 10
# done
