#!/bin/bash
clear
#------ SECTION DEVICES 001-008 [HQ DEVICES]--------------
DEVICE001=( 8.8.8.8 8.8.4.4 )
DEVICE002=( 200.221.11.101 187.120.48.47 )
DEVICE003=( 187.75.155.116 177.104.118.42 )
DEVICE004=( 200.11.52.202 1.1.1.1 )
DEVICE005=( 186.225.45.138 200.252.235.20 )
DEVICE006=( 186.194.224.82 177.43.35.247 )
DEVICE007=( 177.159.232.52 177.131.114.86 )
DEVICE008=( 200.150.112.58 138.36.1.14 )

DEVICES=( ${DEVICE001[@]} ${DEVICE002[@]} ${DEVICE003[@]} ${DEVICE004[@]} ${DEVICE005[@]} ${DEVICE006[@]} ${DEVICE007[@]} ${DEVICE008[@]} )
DEVICES_NAME=( "DEVICE001" , "DEVICE002" , "DEVICE003" , "DEVICE004" ,  "DEVICE005" , "DEVICE006" , "DEVICE007" , "DEVICE008" )
DEVICES_NAME_FULL=( "Descr. DEVICE001" , "Desc. DEVICE002" , "Desc. DEVICE003" , "Desc. DEVICE004" , "Desc. DEVICE005" , "Desc. DEVICE006" , "Desc. DEVICE007" , "Desc. DEVICE008" )

#---- ----- SECTION DEVICE009 [Branch Office 1]----------------------
DEVICE009=( 200.194.198.76 131.196.220.10 )
DEVICE009_NAC_NAME=( "IP_1" "IP_2" )
DEVICE009_NAC_NAME_FULL=( "DEVICE009" )

#---------- SECTION DEVICE010 [Branch Office 2]-------------------------------
DEVICE010=( 190.108.85.3  45.173.200.10 )
DEVICE010_NAME=( "IP_1" "IP_2" )
DEVICE010_NAME_FULL=( "DEVICE010" )

#----------- Text Properties and visual effects ------------
bold="\e[1m";green="\e[92m";yellow="\e[93m";red="\e[91m";alarm_bg="\e[41m";blkn="\e[5m";nclr="\e[0m";
let "lim_vg = 70";let "lim_vm = 90";let "lim_vw = 200";i_c=0;time_ip_out=0;pkts=2;

ping_print(){ 
vv1=$1; indirect_var1=${vv1}[@]; let count1=$( echo "${!indirect_var1}" | wc -w );
vv2=$2; indirect_var2=${vv2}[@]; let count2=$( echo "${!indirect_var2}" | wc -w );
vv3=$3; indirect_var3=${vv3}[@]; let count3=$( echo "${!indirect_var3}" | wc -w );

for (( i=1;i <=$count1 ; i+=2 ))
do
    #echo -ne '\007' (To make a sound [uncomment] )
    ((i_inc = i + 1)); ((i_v2 = i_inc/2)); ((i_v3 = i_v2))
    value_choosen_iv1=$(echo "${!indirect_var1}" | cut -d" " -f$i); value_choosen_icv1=$(echo "${!indirect_var1}" | cut -d" " -f$i_inc);
	value_choosen_iv2=$(echo "${!indirect_var2}" | cut -d, -f$i_v2); 
    #value_choosen_icv2=$(echo "${!indirect_var2}" | cut -d, -f$i_inc);
    value_choosen_iv3=$(echo "${!indirect_var3}" | cut -d, -f$i_v3);
    # value_choosen_icv3=$(echo "${!indirect_var3}" | cut -d, -f$i_inc);
		
	# ----------Latencies mean calculations ----------

    function get_latency_depending_os(){
        target_IP=$1;
        case $(uname) in
            Linux*)
                latency=$(ping -c $pkts "${target_IP}" | grep -i 'rtt' | cut -d/ -f5 2> /dev/null)
                echo "${latency}"
                ;;
            MINGW*|CYGWIN*)
                latency=$(ping -n $pkts "${target_IP}" | tail -n 1 | cut -d" " -f13 | grep -Eo "[0-9]{1,}" 2> /dev/null)
                echo "${latency}"
                ;;
            *)
                echo "Unsupported OS"
                ;;
        esac
    }
    lat1=$(get_latency_depending_os "${value_choosen_iv1}");
    lat2=$(get_latency_depending_os "${value_choosen_icv1}");

    if [ $lat1 ]; then lat1=$lat1; status="OK"; else lat1="$nclr $blkn $alarm_bg [Fora do Ar] $nclr"; status="DOWN"; fi
    if [ $lat2 ]; then lat2=$lat2; status="OK"; else lat2="$nclr $blkn $alarm_bg [Fora do Ar] $nclr"; status="DOWN"; fi

 
    if ((  $( echo " $lat1 < $lim_vg " | bc -l 2> /dev/null )  )) ; then
        lat1=" $nclr $green $lat1 ms $nclr ";
    elif ((  $( echo " $lat1 > $lim_vg && $lat1 < $lim_vm " | bc -l 2> /dev/null ) )); then
        lat1="$nclr $yellow $lat1 ms $nclr";
    elif ((  $( echo " $lat1 > $lim_vm " | bc -l 2> /dev/null ) )); then
        lat1=" $nclr $red $lat1 ms $nclr ";
    fi

    if ((  $( echo " $lat2 < $lim_vg " | bc -l 2> /dev/null )  )) ; then
        lat2="$nclr $green $lat2 ms $nclr";
    elif ((  $( echo " $lat2 > $lim_vg && $lat2 < $lim_vm " | bc -l 2> /dev/null ) )); then
        lat2="$nclr $yellow $lat2 ms $nclr";
    elif ((  $( echo " $lat2 > $lim_vm " | bc -l 2> /dev/null) )); then
        lat2="$nclr $red $lat2 ms $nclr";
    fi

    ((bulet = i_inc/2)); echo -e "Con-status: $value_choosen_iv2\r";
    echo -e " $bulet)\t$value_choosen_iv3 : " "$value_choosen_iv1" "-->\t" "TTL:"$lat1 "\t" "$value_choosen_icv1" "-->\t" "TTL:"$lat2 " | [$status]" "\r"
    echo -e "\n\r";
    
done

}

while ( true )
do
clear
echo -e "\t\t\t\t ---------------------------------------------------------\r";
echo -e "\t\t\t\t           Connectivity Test: "HQ Devices" \r";
echo -e "\t\t\t\t ---------------------------------------------------------\r";
ping_print "DEVICES" "DEVICES_NAME_FULL" "DEVICES_NAME"

echo -e "\t\t\t\t ---------------------------------------------------------\r";
echo -e "\t\t\t\t      Connectivity Test: "Branch Office 1 - Devices" \r";
echo -e "\t\t\t\t ---------------------------------------------------------\r";
ping_print "DEVICE009" "DEVICE009_NAC_NAME_FULL" "DEVICE009_NAC_NAME"

echo -e "\t\t\t\t ---------------------------------------------------------\r";
echo -e "\t\t\t\t   Connectivity Test: "Branch Office 2 - Devices" \r";
echo -e "\t\t\t\t ---------------------------------------------------------\r";
ping_print "DEVICE010" "DEVICE010_NAME_FULL" "DEVICE010_NAME"

sleep 6;
done
