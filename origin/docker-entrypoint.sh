

if [ "$1" = 'ragent' ]; then	
	elif ! [ -d /opt/1C/v8.3/x86_64/ ]; then
      cd /opt/1C/v8.3/x86_64/ && ./ragent /port $PORT_M /regport $PORT_A /range $PORT_R_1:$PORT_R_2
	elif ! [ -d /opt/1cv8/x86_64/$CVER ]; then
	  cd /opt/1cv8/x86_64/$CVER && ./ragent /port $PORT_M /regport $PORT_A /range $PORT_R_1:$PORT_R_2
    else 
	  echo "Не найдено нужной платформы" >> /var/log/1C/logrun.txt
fi

exec "$@"