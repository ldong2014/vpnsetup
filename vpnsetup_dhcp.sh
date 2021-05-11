#!/bin/bash


        VPNNAME=$(cat /etc/ethudp/SITE/VPNNAME)
        HOSTNAME=$(cat /etc/ethudp/HOSTNAME)
        INDEX=$(cat /etc/ethudp/SITE/INDEX)
        BASEPORT=$(cat /etc/ethudp/SITE/BASEPORT)
        PORT=`expr $BASEPORT + $INDEX`
        IP=$(cat /etc/ethudp/IP)
        MASTER=$(cat /etc/ethudp/MASTER)

        if [ $? -eq 0 ]
        then
               /usr/src/vpnsetup/vpnrestart_dhcp.sh
               echo "service restart!"



function read_master()
{
        tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$

                MASTER=CT
        fi

        if [ $MASTER = "CT" ]
        then
                "CT" "China Telcom" on \
                "CU" "China Unicom" off \
                "CMCC" "China Moblie" off \
                "CT2" "China Telcom" off \
                2> $tempfile
        elif [ $MASTER = "CU" ]
        then
                "CT" "China Telcom" off \
                "CU" "China Unicom" on \
                2> $tempfile
        elif [ $MASTER = "CMCC" ]
        then
                "CT" "China Telcom" off \
                "CU" "China Unicom" off \
                "CMCC" "China Moblie" on \
                "CT2" "China Telcom" off \
                2> $tempfile
        elif [ $MASTER = "CT2" ]
        then
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
                active_config
        fi

}
function read_ip_info()
{
        tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
                2> $tempfile

        if [ $? -eq 0 ]
        then
                cat $tempfile | {
                        read -r HOSTNAME

                        echo $HOSTNAME > /etc/ethudp/HOSTNAME
                }
                rm -f $tempfile
                read_master
        fi
}

ifconfig eth0 |grep "inet addr:" |awk '{print $2}'| cut -c 6- > /dev/null
if [ $? -eq 0 ]
then
    var=$(ifconfig eth0 |grep "inet addr:" |awk '{print $2}'| cut -c 6- )
    echo $var > /etc/ethudp/IP
else
    echo "IP error!"

fi
VPNNAME=$(cat /etc/ethudp/SITE/VPNNAME)
HOSTNAME=$(cat /etc/ethudp/HOSTNAME)
INDEX=$(cat /etc/ethudp/SITE/INDEX)
BASEPORT=$(cat /etc/ethudp/SITE/BASEPORT)
PORT=`expr $BASEPORT + $INDEX`
IP=$(cat /etc/ethudp/IP)
MASTER=$(cat /etc/ethudp/MASTER)

dialog --backtitle "VPN Information" --title "Current VPN Config Info" --ok-label "Change" --yesno "
 VPN NAME: $VPNNAME\nVPN Index: $INDEX\n UDP Port: $PORT\n HOSTNAME: $HOSTNAME \nDo you want change?
" 15 50

if [ $? -eq 0 ]
then
        read_ip_info
fi
