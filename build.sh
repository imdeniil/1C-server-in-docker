#!/bin/bash
clear
echo "Сбор данных для образа 1с, в скобках указаны примеры как вводить значения."
echo ---------------------------------------- 
read -n4 -p "Введи порты менеджера (1540): " PORT_M 
echo
read -n4 -p "Введи порты агента (1541): " PORT_A 
echo
read -n4 -p "Введи порты rphost от (1560): " PORT_R_1 && read -n4 -p " до (1591): " PORT_R_2
echo
read -p "Введи назавние сервера !ТОЛЬКО МАЛЕНЬКИЕ БУКВЫ!(erp): " SRV_N
read -p "Введи версию 1С (8.3.18.1289): " CVER
echo
echo ----------------------------------------
echo
echo "Сводка по контейнеру"
echo "Название: ""$SRV_N"
echo "Версия: ""$CVER"
echo "Агент - ""$PORT_A"
echo "Менеджер - ""$PORT_M"
echo "rphost - ""$PORT_R_1:""$PORT_R_2"
echo
echo ----------------------------------------
echo
echo -n "Проверь сводку по контейнеру, верная (y/n)? "
echo
echo
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo
    echo "Начинаю сборку и запуск контейнера"
else
    echo
    echo "Запустите сборку image повторно!"
	exit
fi
echo 
echo
#Создаем промежуточные конфигурацияоные файлы 
#Для докера
echo FROM ubuntu:latest >> ./Dockerfile
echo ENV SRV_N=$SRV_N >> ./Dockerfile
echo ENV CVER=$CVER >> ./Dockerfile
echo ENV PORT_A=$PORT_A >> ./Dockerfile
echo ENV PORT_M=$PORT_M >> ./Dockerfile
echo ENV PORT_R_1=$PORT_R_1 >> ./Dockerfile
echo ENV PORT_R_2=$PORT_R_2 >> ./Dockerfile
cat ./origin/Dockerfile >> ./Dockerfile

#Для агента
echo SRV_N=$SRV_N >> ./config.cfg
echo CVER=$CVER >> ./config.cfg
echo PORT_A=$PORT_A >> ./config.cfg
echo PORT_M=$PORT_M >> ./config.cfg
echo PORT_R_1=$PORT_R_1 >> ./config.cfg
echo PORT_R_2=$PORT_R_2 >> ./config.cfg

#Собираем контейнер
echo "#!/bin/bash" >> ./build-docker.sh 
echo docker build --tag xyzw/$SRV_N . >> ./build-docker.sh 
chmod 777 build-docker.sh

#Создаю run.sh 
echo "#!/bin/bash" >> ./run.sh
cat ./config.cfg >> ./run.sh
cat ./origin/run.sh >> ./run.sh
chmod 777 run.sh

#Создаю entry point 
echo "#!/bin/bash" >> ./docker-entrypoint.sh
echo "set -e" >> ./docker-entrypoint.sh
cat ./config.cfg >> ./docker-entrypoint.sh
cat ./origin/docker-entrypoint.sh >> ./docker-entrypoint.sh
chmod 777 docker-entrypoint.sh

#Ожидаю сборку  
echo "Стартую build-docker.sh, это долго.Можешь пока чаю налить, и смотреть логи >> ./$SRV_N.txt"
./build-docker.sh >> $SRV_N.txt &
pid=$!
wait $pid
echo
echo "Завершил build-docker.sh"

echo 
echo

#Запускаем контейнер собранный
echo "Стартую run.sh, тут тоже есть логи"
./run.sh &
pid=$!
wait $pid
echo
echo "Завершил run.sh"

#Чистим мусор
rm Dockerfile
rm config.cfg
rm run.sh
rm build-docker.sh
rm docker-entrypoint.sh

echo
echo Успех!
echo

docker ps
