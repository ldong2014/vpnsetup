





#!/bin/bash


VPNNAME=$(cat /etc/ethudp/SITE/VPNNAME)
HOSTNAME=$(cat /etc/ethudp/HOSTNAME)
INDEX=$(cat /etc/ethudp/SITE/INDEX)
BASEPORT=$(cat /etc/ethudp/SITE/BASEPORT)
PORT=`expr $BASEPORT + $INDEX`
IP=$(cat /etc/ethudp/IP)
MASTER=$(cat /etc/ethudp/MASTER)
PREFIX=$(cat /etc/ethudp/SITE/PREFIX)

sed -i -e "s/HOSTNAME=.*$/HOSTNAME=$HOSTNAME/" /etc/sysconfig/network
hostname $HOSTNAME

killall -9 EthUDP
killall -9 sendstat

/usr/src/vpnsetup/sendstat

ip link set eth0 up
ip link set eth1 up


ethtool -K eth1 gro off

OPT=$(cat /etc/ethudp/SITE/OPT)

if [ -z $MASTER ] ; then
        MASTER="CT"
fi

REMOTE=$(cat /etc/ethudp/SITE/$MASTER)

MPORT=`expr $PORT + 100`

ifconfig eth0 |grep "inet addr:" |awk '{print $2}'| cut -c 6- > /dev/null
if [ $? -eq 0 ]
then
        ip=$(ifconfig eth0 |grep "inet addr:" |awk '{print $2}'| cut -c 6-)
        /usr/src/ethudp/EthUDP -e $OPT $IP $PORT $REMOTE $PORT eth1
        /usr/src/ethudp/EthUDP -i $OPT $IP $MPORT $REMOTE $MPORT $PREFIX$INDEX.2 24
else
       echo "network failure!"
fi
