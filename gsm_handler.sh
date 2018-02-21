#!/bin/sh

# $1 := CALL | RECEIVED | USSD | SENT
# $2 - SMS message file

LOG="/var/log/gsm.log"

if [ "$1" = "CALL" -o "$1" = "RECEIVED" ]
then
  FROM=$(cat "$2" | grep -e '^From\:' | cut -d' ' -f2 | sed 's/\r//g')
  DATE=$(cat "$2" | grep -e '^Received\:' | cut -d' ' -f2,3 | sed 's/\r//g')
fi

case "$1" in
  CALL) # incoming call
    echo "call from $FROM ($DATE)" >> $LOG
  ;;

  USSD) # USSD
    echo "USSD: $*" >> $LOG
  ;;

  RECEIVED) # SMS received
    echo "SMS from $FROM ($DATE)" >> "$LOG"
    /opt/sms2email/sms2email.sh
  ;;

  SENT) # SMS sent
    echo "SMS sent: $*" >> $LOG
  ;;

  *) # other event
    echo "other event: $*" >> $LOG
  ;;

esac

