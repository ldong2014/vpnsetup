#!/bin/bash
function active_config()
{
	VPNNAME=$(cat /etc/ethudp/SITE/VPNNAME)
	HOSTNAME=$(cat /etc/ethudp/HOSTNAME)
	INDEX=$(cat /etc/ethudp/SITE/INDEX)
	BASEPORT=$(cat /etc/ethudp/SITE/BASEPORT)
	PORT=`expr $BASEPORT + $INDEX`
	IP=$(cat /etc/ethudp/IP)
	MASK=$(cat /etc/ethudp/MASK)
	GATE=$(cat /etc/ethudp/GATE)
	MASTER=$(cat /etc/ethudp/MASTER)
	SLAVE=$(cat /etc/ethudp/SLAVE)

	dialog --title "Current Internet Interface Info" --ok-label "Active" --yesno "VPNNAME: $VPNNAME\nVPN Index: $INDEX\nUDP Port: $PORT\nIP: $IP\nMASK: $MASK\nGateway: $GATE\nMaster: $MASTER\nSlave: $SLAVE\nDo you want active new config?" 15 50
	
	if [ $? -eq 0 ] 
	then 
		/usr/src/vpnsetup/restart.sh
	fi 
}

function read_slave()
{
	tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
	
	if [ -z $SLAVE ]
	then
		SLAVE=NONE
	fi
	if [ $SLAVE = "NONE" ]
	then 
	dialog --ok-label "Next"  --title "SLave Connections" --radiolist "Please select your slave connection info:" 12 50 4  \
		"NONE" "NO SLAVE connect" on \
		"CT" "China Telcom" off \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" off \
		2> $tempfile
	elif [ $SLAVE = "CT" ]
	then 
	dialog --ok-label "Next"  --title "SLave Connections" --radiolist "Please select your slave connection info:" 12 50 4  \
		"NONE" "NO SLAVE connect" off \
		"CT" "China Telcom" on \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" off \
		2> $tempfile
	elif [ $SLAVE = "CU" ]
	then 
	dialog --ok-label "Next"  --title "SLave Connections" --radiolist "Please select your slave connection info:" 12 50 4  \
		"NONE" "NO SLAVE connect" off \
		"CT" "China Telcom" off \
		"CU" "China Unicom" on \
		"CMCC" "China Moblie" off \
		2> $tempfile
	elif [ $SLAVE = "CMCC" ]
	then 
	dialog --ok-label "Next"  --title "SLave Connections" --radiolist "Please select your slave connection info:" 12 50 4  \
		"NONE" "NO SLAVE connect" off \
		"CT" "China Telcom" off \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" on \
		2> $tempfile
	fi
	if [ $? -eq 0 ]
	then
		cat $tempfile > /etc/ethudp/SLAVE
		rm -f $tempfile
		active_config
	fi
}

function read_master()
{
	tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
	
	if [ -z $MASTER ]
	then
		MASTER=CT
	fi

	if [ $MASTER = "CT" ]
	then 
	dialog --ok-label "Next"  --title "Master Connections" --radiolist "Please select your master connection info:" 12 50 3  \
		"CT" "China Telcom" on \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" off \
		2> $tempfile
	elif [ $MASTER = "CU" ]
	then 
	dialog --ok-label "Next"  --title "Master Connections" --radiolist "Please select your master connection info:" 12 50 3  \
		"CT" "China Telcom" off \
		"CU" "China Unicom" on \
		"CMCC" "China Moblie" off \
		2> $tempfile
	elif [ $MASTER = "CMCC" ]
	then 
	dialog --ok-label "Next"  --title "Master Connections" --radiolist "Please select your master connection info:" 12 50 3  \
		"CT" "China Telcom" off \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" on \
		2> $tempfile
	fi


	if [ $? -eq 0 ]
	then
		cat $tempfile > /etc/ethudp/MASTER
		rm -f $tempfile
		read_slave
	fi

}
function read_ip_info()
{
	tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
	dialog --ok-label "Next"  --title "Internet Interface Setup" --form "Please input the Internet Interface info:" 12 50 4  \
  		"HOSTNAME:" 1  1 "$HOSTNAME" 1  15  15  0  \
  		"IP:" 2  1 "$IP" 2  15  15  0  \
  		"Mask:" 3  1 "$MASK" 3  15  15  0  \
  		"Gateway:" 4  1 "$GATE" 4  15  15  0 \
		2> $tempfile

	if [ $? -eq 0 ]
	then
		cat $tempfile | {
  			read -r HOSTNAME
  			read -r IP
  			read -r MASK
  			read -r GATE

  			echo $IP > /etc/ethudp/IP
  			echo $MASK > /etc/ethudp/MASK
  			echo $GATE > /etc/ethudp/GATE
  			echo $HOSTNAME > /etc/ethudp/HOSTNAME
		}
		rm -f $tempfile
		read_master
	fi
}

VPNNAME=$(cat /etc/ethudp/SITE/VPNNAME)
HOSTNAME=$(cat /etc/ethudp/HOSTNAME)
INDEX=$(cat /etc/ethudp/SITE/INDEX)
BASEPORT=$(cat /etc/ethudp/SITE/BASEPORT)
PORT=`expr $BASEPORT + $INDEX`
IP=$(cat /etc/ethudp/IP)
MASK=$(cat /etc/ethudp/MASK)
GATE=$(cat /etc/ethudp/GATE)
MASTER=$(cat /etc/ethudp/MASTER)
SLAVE=$(cat /etc/ethudp/SLAVE)

dialog --title "Current Internet Interface Info" --ok-label "Change" --yesno "VPNNAME: $VPNNAME\nHOSTNAME: $HOSTNAME\nVPN Index: $INDEX\nUDP Port: $PORT\nIP: $IP\nMASK: $MASK\nGateway: $GATE\nMaster: $MASTER\nSlave: $SLAVE\nDo you want change?" 15 50

if [ $? -eq 0 ] 
then 
	read_ip_info
fi 


