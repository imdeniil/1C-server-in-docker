

if [ "$1" = 'ragent' ]; then	
      cd /opt/1C/v8.3/x86_64/ && ./ragent /port $PORT_M /regport $PORT_A /range $PORT_R_1:$PORT_R_2
fi

exec "$@"