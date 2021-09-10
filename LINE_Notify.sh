#!/bin/bash
ZBX_URL="http://127.0.0.1/zabbix"
USERNAME="Admin"
PASSWORD="zabbix"
access_token="<Enter LINE token Here>"
PERIOD=10800
ZABBIXVERSION34="0"
GRAPHID=$2
GRAPHID=$(echo $GRAPHID | grep -o -E "(Graph: \[[0-9]{7}\])|(Graph: \[[0-9]{6}\])|(Graph: \[[0-9]{5}\])|(Graph: \[[0-9]{4}\])|(Graph: \[[0-9]{3}\])")
GRAPHID=$(echo $GRAPHID | grep -o -E "([0-9]{7})|([0-9]{6})|([0-9]{5})|([0-9]{4})|([0-9]{3})")
case $GRAPHID in
 ''|*[!0-9]*) INC_GRAPH=0 ;;
 *) INC_GRAPH=1 ;;
esac
WIDTH=800
CURL="/usr/bin/curl"
#NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)
NEW_UUID=$RANDOM
COOKIE="/tmp/zapi_cookie-$(date "+%Y.%m.%d-%H.%M.%S")-${NEW_UUID}"
PNG_PATH="/tmp/zapi_graph-$(date "+%Y.%m.%d-%H.%M.%S")-${NEW_UUID}.png"
if [ $(($INC_GRAPH)) -eq '1' ]; then
 ${CURL} -k -s -c ${COOKIE} -b ${COOKIE} -d "name=${USERNAME}&password=${PASSWORD}&autologin=1&enter=Sign%20in" ${ZBX_URL}"/index.php" > /dev/null
 if [ "${GRAPHID}" == "000001" ]; then
  GRAPHID="00002";
  ${CURL} -k -s -c ${COOKIE} -b ${COOKIE} -d "graphid=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart2.php" -o "${PNG_PATH}";
 elif [ "${GRAPHID}" == "000002" ]; then
  GRAPHID="00003";
  ${CURL} -k -s -c ${COOKIE}  -b ${COOKIE} -d "graphid=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart2.php" -o "${PNG_PATH}";
 elif [ "${GRAPHID}" == "000003" ]; then
  GRAPHID="00004";
  ${CURL} -k -s -c ${COOKIE}  -b ${COOKIE} -d "graphid=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart2.php" -o "${PNG_PATH}";
 else
  if [ "${ZABBIXVERSION34}" == "1" ]; then
   ${CURL} -k -s -c ${COOKIE}  -b ${COOKIE} -d "itemids=${GRAPHID}&period=${PERIOD}&width=${WIDTH}&profileIdx=web.item.graph" ${ZBX_URL}"/chart.php" -o "${PNG_PATH}";
  else
   ${CURL} -k -s -c ${COOKIE}  -b ${COOKIE} -d "itemids=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart.php" -o "${PNG_PATH}";
  fi
 fi
 ${CURL} -X POST -H "Authorization: Bearer ${access_token}" -F "message=$1: $2" -F "imageFile=@${PNG_PATH}" https://notify-api.line.me/api/notify
else
 ${CURL} -X POST -H "Authorization: Bearer ${access_token}" -F "message=$1: $2" https://notify-api.line.me/api/notify
fi
rm -f ${COOKIE}
rm -f ${PNG_PATH}
