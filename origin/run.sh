

docker run -td \
  --name $SRV_N-$PORT_M \
  --net host \
  --volume 1c-server-home:/home/usr1cv8 \
  --volume 1c-server-logs:/var/log/1C/ \
  --volume /etc/localtime:/etc/localtime:ro \
  xyzw/$SRV_N