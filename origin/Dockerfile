

RUN apt -qq update 2> /dev/null \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common 2> /dev/null \
  && apt-add-repository 'deb http://ru.archive.ubuntu.com/ubuntu/ bionic main universe' 2> /dev/null \
  && apt-add-repository 'deb http://ru.archive.ubuntu.com/ubuntu/ xenial main universe' 2> /dev/null \
  && apt -qq update 2> /dev/null \
  && DEBIAN_FRONTEND=noninteractive apt -qq install --no-install-recommends -y ttf-mscorefonts-installer 2> /dev/null \
  && DEBIAN_FRONTEND=noninteractive apt -qq install --no-install-recommends -y libfreetype6 2> /dev/null \
  && DEBIAN_FRONTEND=noninteractive apt -qq install --no-install-recommends -y libgsf-1-common 2> /dev/null \
  && DEBIAN_FRONTEND=noninteractive apt -qq install --no-install-recommends -y unixodbc 2> /dev/null \
  && DEBIAN_FRONTEND=noninteractive apt -qq install --yes --no-install-recommends ca-certificates wget locales 2> /dev/null \
  && DEBIAN_FRONTEND=noninteractive apt -qq install --no-install-recommends -y tdsodbc freetds-bin 2> /dev/null \
  && NAME=$(whoami) \
  && groupadd grp1cv8 \
  && adduser --disabled-password --gecos '' usr1cv8 \
  && adduser usr1cv8 sudo \
  && adduser $NAME sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && localedef --inputfile ru_RU --force --charmap UTF-8 --alias-file /usr/share/locale/locale.alias ru_RU.UTF-8 
  
COPY ./origin/odbcinst.ini /etc/
COPY ./origin/freetds.conf /etc/freetds/
COPY ./origin/odbc.ini /etc/

RUN odbcinst -i -d -f /etc/odbcinst.ini \
  && chmod 640 /etc/odbc.ini \
  && odbcinst -i -s -l -f /etc/odbc.ini
 
ADD deb/$CVER/*.deb /home/

RUN dpkg -i /home/*.deb \
  && rm /home/*.deb \
  && mkdir --parents /var/log/1C /home/usr1cv8/.1cv8/1C/1cv8/conf \
  && chown --recursive usr1cv8:grp1cv8 /var/log/1C /home/usr1cv8

COPY ./docker-entrypoint.sh /

RUN mkdir -p /opt/1C/v8.3/x86_64/conf/
COPY origin/logcfg.xml /opt/1C/v8.3/x86_64/conf/
RUN chown -R usr1cv8:grp1cv8 /opt/1C

RUN mkdir -p /var/log/1c/dumps/
RUN chown -R usr1cv8:grp1cv8 /var/log/1c/
RUN chmod 755 /var/log/1c

ENTRYPOINT ["./docker-entrypoint.sh"]

VOLUME /home/usr1cv8
VOLUME /var/log/1C

EXPOSE ${PORT_A}
EXPOSE ${PORT_M}
EXPOSE ${PORT_R_1}-${PORT_R_2}

CMD ["ragent"]