#!/bin/bash

VPNNAME=$(cat /etc/ethudp/SITE/VPNNAME)
INDEX=$(cat /etc/ethudp/SITE/INDEX)
BASEPORT=$(cat /etc/ethudp/SITE/BASEPORT)
PORT=`expr $BASEPORT + $INDEX`
IP=$(cat /etc/ethudp/IP)
MASK=$(cat /etc/ethudp/MASK)
GATE=$(cat /etc/ethudp/GATE)
MASTER=$(cat /etc/ethudp/MASTER)
SLAVE=$(cat /etc/ethudp/SLAVE)
PREFIX=$(cat /etc/ethudp/PREFIX)

killall -9 EthUDP
ip link set eth0 up
ip link set eth1 up
ip add flush dev eth0
ip add add $IP/$MASK dev eth0
ip route add 0/0 via $GATE

OPT=$(cat /etc/ethudp/SITE/OPT)

if [ -z $MASTER ] ; then
	MASTER="CT"
fi

REMOTE=$(cat /etc/ethudp/SITE/$MASTER)

MPORT=`expr $PORT + 1000`

if [ -z $SLAVE ]; then
	SLAVE="NONE"
fi

if [ $SLAVE = "NONE" ] ; then
	/usr/src/ethudp/EthUDP -e $OPT $IP $PORT $REMOTE $PORT eth1
	/usr/src/ethudp/EthUDP -i $OPT $IP $PORT $REMOTE $MPORT $PREFIX$INDEX.2 24
else
	REMOTE2=$(cat /etc/ethudp/$SLAVE)
	PORT2=`expr $PORT + 100`
	MPORT2=`expr $PORT2 + 1000`
	/usr/src/ethudp/EthUDP -e $OPT $IP $PORT $REMOTE $PORT eth1 $IP $PORT2 $REMOTE2 $PORT2
	/usr/src/ethudp/EthUDP -i $OPT $IP $PORT $REMOTE $MPORT $PREFIX$INDEX.2 24 $IP $MPORT2 $REMOTE2 $MPORT2
fi

