#!/bin/sh

. /etc/sms2email.conf

test -f "$LOCK_FILE" && exit
touch "$LOCK_FILE"

echo "sms2email.sh started (`date`)" >> "$LOG"

for i in `find "$SMS_DIR"`
do
  test -f "$i" || continue
	
  /usr/local/bin/sms2unicode "$i" | iconv -f UTF-16 -t UTF-8 > "$SMS"
  echo >> "$SMS"
  MESSAGE=`cat "$SMS"`
  FROM=$(echo "${MESSAGE}" | grep -e '^From\:' | cut -d' ' -f2 | sed 's/\r//g')
  DATE=$(echo "${MESSAGE}" | grep -e '^Received\:' | cut -d' ' -f2,3 | sed 's/\r//g')
  BODY=$(echo "${MESSAGE}" | tail -n 1)
  echo "$BODY" > "$SMS_BODY"

  mailsend -t $EMAIL_TO \
	   -f $EMAIL_FROM \
	   -smtp $SMTP -port $SMTP_PORT \
	   $SMTP_AUTH \
	   -sub "SMS received from ${FROM} (${DATE})" \
	   -msg-body "$SMS_BODY" || continue

  echo "SMS from $FROM ($DATE) send to $EMAIL_TO [$BODY]" >> "$LOG" && rm "$i"

done

rm "$LOCK_FILE"

