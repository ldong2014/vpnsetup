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
	IPV6=$(cat /etc/ethudp/IPV6)

	dialog --backtitle "VPN Information" --title "Current VPN Config Info" --ok-label "Active" --yesno " VPN NAME: $VPNNAME\nVPN Index: $INDEX\n UDP Port: $PORT\n HOSTNAME: $HOSTNAME\n  IP Addr: $IP\n Net MASK: $MASK\n  Gateway: $GATE\n   Master: $MASTER\n    Slave: $SLAVE\neth2 IPv6: $IPV6\nDo you want active new config?" 15 50
	
	if [ $? -eq 0 ] 
	then 
		/usr/src/vpnsetup/vpnrestart.sh
	fi 
}

function read_ipv6()
{
	tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
	
	if [ -z $IPV6 ]
	then
		IPV6=NO
	fi

	if [ $IPV6 = "NO" ]
	then 
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "eth2 for IPv6 Connections" --radiolist "Do you need eth2 for IPv6 interface:" 12 50 4  \
		"NO" "NO" on \
		"YES" "YES, eth2 for IPv6" off \
		2> $tempfile
	else
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "eth2 for IPv6 Connections" --radiolist "Do you need eth2 for IPv6 interface:" 12 50 4  \
		"NO" "NO" off \
		"YES" "YES, eth2 for IPv6" on \
		2> $tempfile
	fi

	if [ $? -eq 0 ]
	then
		cat $tempfile > /etc/ethudp/IPV6
		rm -f $tempfile
		active_config
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
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "SLave Connections" --radiolist "Please select your slave connection info:" 12 50 5  \
		"NONE" "NO SLAVE connect" on \
		"CT" "China Telcom" off \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" off \
		"CT2" "China Telcom" off \
		2> $tempfile
	elif [ $SLAVE = "CT" ]
	then
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "SLave Connections" --radiolist "Please select your slave connection info:" 12 50 5  \
		"NONE" "NO SLAVE connect" off \
		"CT" "China Telcom" on \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" off \
		"CT2" "China Telcom" off \
		2> $tempfile
	elif [ $SLAVE = "CU" ]
	then
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "SLave Connections" --radiolist "Please select your slave connection info:" 12 50 5  \
		"NONE" "NO SLAVE connect" off \
		"CT" "China Telcom" off \
		"CU" "China Unicom" on \
		"CMCC" "China Moblie" off \
		"CT2" "China Telcom" off \
		2> $tempfile
	elif [ $SLAVE = "CMCC" ]
	then
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "SLave Connections" --radiolist "Please select your slave connection info:" 12 50 5  \
		"NONE" "NO SLAVE connect" off \
		"CT" "China Telcom" off \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" on \
		"CT2" "China Telcom" off \
		2> $tempfile
	elif [ $SLAVE = "CT2" ]
	then
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "SLave Connections" --radiolist "Please select your slave connection info:" 12 50 5  \
		"NONE" "NO SLAVE connect" off \
		"CT" "China Telcom" off \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" off \
		"CT2" "China Telcom" on \
		2> $tempfile
	fi

	if [ $? -eq 0 ]
	then
		cat $tempfile > /etc/ethudp/SLAVE
		rm -f $tempfile
		read_ipv6
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
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "Master Connections" --radiolist "Please select your master connection info:" 12 50 4  \
		"CT" "China Telcom" on \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" off \
		"CT2" "China Telcom" off \
		2> $tempfile
	elif [ $MASTER = "CU" ]
	then
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "Master Connections" --radiolist "Please select your master connection info:" 12 50 4  \
		"CT" "China Telcom" off \
		"CU" "China Unicom" on \
		"CMCC" "China Moblie" off \
		"CT2" "China Telcom" off \
		2> $tempfile
	elif [ $MASTER = "CMCC" ]
	then
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "Master Connections" --radiolist "Please select your master connection info:" 12 50 4  \
		"CT" "China Telcom" off \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" on \
		"CT2" "China Telcom" off \
		2> $tempfile
	elif [ $MASTER = "CT2" ]
	then
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "Master Connections" --radiolist "Please select your master connection info:" 12 50 4  \
		"CT" "China Telcom" off \
		"CU" "China Unicom" off \
		"CMCC" "China Moblie" off \
		"CT2" "China Telcom" on \
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
	dialog --backtitle "VPN Information" --ok-label "Next"  --title "Internet Interface Setup" --form "Please input the Internet Interface info:" 12 50 4  \
  		" HOSTNAME:" 1  1 "$HOSTNAME" 1  13  15  0  \
  		"  IP Addr:" 2  1 "$IP" 2  13  15  0  \
  		" Net Mask:" 3  1 "$MASK" 3  13  15  0  \
  		"  Gateway:" 4  1 "$GATE" 4  13  15  0 \
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
IPV6=$(cat /etc/ethudp/IPV6)

dialog --backtitle "VPN Information" --title "Current VPN Config Info" --ok-label "Change" --yesno " VPN NAME: $VPNNAME\nVPN Index: $INDEX\n UDP Port: $PORT\n HOSTNAME: $HOSTNAME\n  IP Addr: $IP\n Net MASK: $MASK\n  Gateway: $GATE\n   Master: $MASTER\n    Slave: $SLAVE\neth2 IPv6: $IPV6\nDo you want change?" 15 50

if [ $? -eq 0 ] 
then 
	read_ip_info
fi 


