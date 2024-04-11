#!/usr/bin/env bash
#
# Description: A Network Test Script by <sh@suh.ovh>
# Copyright (C) 2022 - 2023 <sh@suh.ovh>
# URL: https://network-speed.xyz/
# https://github.com/su-haris/simple-network-speedtest
#
trap _exit INT QUIT TERM

_red() {
    printf '\033[0;31;31m%b\033[0m' "$1"
}

_green() {
    printf '\033[0;31;32m%b\033[0m' "$1"
}

_yellow() {
    printf '\033[0;31;33m%b\033[0m' "$1"
}

_blue() {
    printf '\033[0;31;36m%b\033[0m' "$1"
}

_exists() {
    local cmd="$1"
    if eval type type > /dev/null 2>&1; then
        eval type "$cmd" > /dev/null 2>&1
    elif command > /dev/null 2>&1; then
        command -v "$cmd" > /dev/null 2>&1
    else
        which "$cmd" > /dev/null 2>&1
    fi
    local rt=$?
    return ${rt}
}

_exit() {
    _red "\nThe script has been terminated.\n"
    # clean up
    rm -fr speedtest.tgz speedtest-cli benchtest_*
    exit 1
}

get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print $0}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

next() {
    printf "%-75s\n" "-" | sed 's/\s/-/g'
}

speed_test() {
    local nodeName="$2"
    [ -z "$1" ] && ./speedtest-cli/speedtest --progress=no --accept-license --accept-gdpr > ./speedtest-cli/speedtest.log 2>&1 || \
    ./speedtest-cli/speedtest --progress=no --server-id=$1 --accept-license --accept-gdpr > ./speedtest-cli/speedtest.log 2>&1

    if [ "$nodeName" = "Nearest" ]; then
        local isp=$(grep -Po 'ISP: \K.*' ./speedtest-cli/speedtest.log)
        echo -e "\n ISP: $(_blue "$isp") \n"
    fi

    if [ $? -eq 0 ]; then
        local dl_speed=$(awk '/Download/{print $3" "$4}' ./speedtest-cli/speedtest.log)
        local up_speed=$(awk '/Upload/{print $3" "$4}' ./speedtest-cli/speedtest.log)

        local dl_speed_num=$(awk '/Download/{print $3}' ./speedtest-cli/speedtest.log)
        local up_speed_num=$(awk '/Upload/{print $3}' ./speedtest-cli/speedtest.log)     

        local latency=$(awk '/Latency/{print $2" "$3}' ./speedtest-cli/speedtest.log)
        local server_details=$(grep -Po 'Server: \K[^(]+' ./speedtest-cli/speedtest.log)
        local packet_loss=$(awk '/Packet Loss/{print $3}' ./speedtest-cli/speedtest.log)

        local dl_data_used=$(awk '/Download/{print $7}' ./speedtest-cli/speedtest.log)
        local dl_data_units=$(awk '/Download/{print $8}' ./speedtest-cli/speedtest.log)

        local up_data_used=$(awk '/Upload/{print $7}' ./speedtest-cli/speedtest.log)
        local up_data_units=$(awk '/Upload/{print $8}' ./speedtest-cli/speedtest.log)

        if [[ "$dl_data_units" =~ "GB" ]]; then
            dl_data_used=$(awk "BEGIN {print $dl_data_used*1024; exit}")
        fi

        if [[ "$up_data_units" =~ "GB" ]]; then
            up_data_used=$(awk "BEGIN {print $up_data_used*1024; exit}")
        fi   

        if [[ "$packet_loss" =~ "Not" ]]; then
            packet_loss="N/A"
        fi

        if [[ -n "${dl_speed}" && -n "${up_speed}" && -n "${latency}" ]]; then
            printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " ${nodeName}" "${latency}" "${packet_loss}" "${dl_speed}" "${up_speed}" "${server_details}"

            DL_USED=$(awk "BEGIN {print $dl_data_used+$DL_USED; exit}")
            UL_USED=$(awk "BEGIN {print $up_data_used+$UL_USED; exit}")

            SUCCESS_TEST=$((SUCCESS_TEST + 1))
            AVG_DL_SPEED=$(awk "BEGIN {print $AVG_DL_SPEED+$dl_speed_num; exit}")
            AVG_UL_SPEED=$(awk "BEGIN {print $AVG_UL_SPEED+$up_speed_num; exit}")
        else
            printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " ${nodeName}" "FAILED"   
        fi
    fi
}

speed() {
    DL_USED=0
    UL_USED=0

    AVG_DL_SPEED=0
    AVG_UL_SPEED=0
    SUCCESS_TEST=0

    speed_test '' 'Nearest'
    echo -e

    if [ "$REGION" = "india" ]; then
        speed_test '47668' 'Mumbai, MH'
        speed_test '6879' 'Mumbai, MH'
        speed_test '33603' 'Pune, MH'
        speed_test '18977' 'Hyderabad, AP/TL' 
        speed_test '52216' 'Bangalore, KA'
        speed_test '7379' 'Bangalore, KA'
        speed_test '35402' 'Mangalore, KA'
        #speed_test '19117' 'Chennai, TN'
        #speed_test '22796' 'Chennai, TN'
        speed_test '9690' 'Chennai, TN'
        speed_test '20107' 'Coimbatore, TN'
        speed_test '34444' 'Madurai, TN'
        speed_test '10112' 'Kochi, KL' 
        speed_test '29372' 'Kochi, KL'
        speed_test '43322' 'Trivandrum, KL'
        speed_test '12221' 'Kolkata, WB'
        speed_test '15797' 'Delhi, DL'
        speed_test '10020'  'Gurgaon, HR' 
        speed_test '25959' 'Patna, BH'
    elif [ "$REGION" = "asia" ]; then
        speed_test '40507' 'Mumbai, IN'
        speed_test '9690'  'Chennai, IN' 
        speed_test '52216' 'Bangalore, IN'
        speed_test '5935' 'Singapore, SG'
        speed_test '4235' 'Singapore, SG'
        speed_test '24333' 'Tokyo, JP'
        #speed_test '24447' 'China Unicom'
        #speed_test '3633'  'China Telecom' 
        speed_test '28225' 'China Telecom'
        speed_test '4870' 'China Unicom'
        speed_test '41910' 'China Mobile'
        speed_test '22126' 'Hong Kong, CN'
        speed_test '32238' 'Karachi, PK'
        speed_test '4774' 'Islamabad, PK'
        speed_test '55587' 'Kathmandu, NP'
        speed_test '46291' 'Colombo, SL'
        speed_test '10424' 'Dhaka, BD'
        speed_test '8990'  'Bangkok, TH' 
        speed_test '26853' 'Ho Chi Minh, VN'
        speed_test '16416' 'Hanoi, VN'
        speed_test '7167' 'Manila, PH'
        speed_test '18445' 'Tapei, TW' 
        speed_test '797' 'Jakarta, ID'
        speed_test '56045' 'Surabaya, ID'   
        speed_test '19302' 'Kuala Lum, MY'
        speed_test '6389' 'Novosibirsk, RU'
        speed_test '31851' 'Istanbul, TR'
        speed_test '17336' 'Dubai, AE'
        speed_test '1733' 'Jeddah, SA'
    elif [ "$REGION" = "middle-east" ]; then
        speed_test '1692' 'Abu Dhabi, AE'
        speed_test '22129' 'Dubai, AE'
        speed_test '34240' 'Fujairah, AE'
        speed_test '1717'  'Muscat, OM' 
        speed_test '11271' 'Seeb, OM'
        speed_test '15570' 'Sanaa, YE'
        speed_test '6193' 'Doha, QA'
        speed_test '51669' 'Lusail, QA'
        speed_test '17574'  'Manama, BH' 
        speed_test '52650' 'Rifa, BH'
        speed_test '25444' 'Kuwait, KW'
        speed_test '3290' 'Kuwait, KW'
        speed_test '1402' 'Riyadh, SA'
        speed_test '16051' 'Dammam, SA'
        speed_test '3196'  'Jeddah, SA' 
        speed_test '14580' 'Jeddah, SA'
    elif [ "$REGION" = "na" ]; then
        speed_test '3049' 'Vancouver, BC'
        #speed_test '3575'  'Toronto, ON' 
        speed_test '4207'  'Calgary, AB'
        speed_test '1493'  'Winnipeg, MB'
        speed_test '53393' 'Toronto, ON'
        speed_test '46416' 'Montreal, QC'
        echo -e
        speed_test '36817' 'New York, NY'
        speed_test '32493' 'Ashburn, VA'
        speed_test '27833' 'Charlotte, NC' 
        speed_test '41360' 'Atlanta, GA'
        speed_test '47746' 'Miami, FL'
        speed_test '22288' 'Dallas, TX'
        speed_test '45284' 'Houston, TX'
        speed_test '47512' 'Kansas, MO'
        speed_test '15869' 'Minneapolis, MN'
        speed_test '21364' 'Chicago, IL' 
        speed_test '27834' 'Cleveland, OH'
        speed_test '1773' 'Albuquerque, NM'
        speed_test '56839' 'Denver, CO'
        speed_test '10162' 'Portland, OR'
        speed_test '53984' 'Las Vegas, NV'
        speed_test '54751' 'Salt Lake, UT'  
        speed_test '27746' 'Phoenix, AZ' 
        speed_test '34840' 'Los Angeles, CA'
        speed_test '48240' 'Santa Clara, CA'
        speed_test '49365' 'San Jose, CA'
        #speed_test '58291' 'Spokane, WA'
        speed_test '50679' 'Seattle, WA'
        echo -e
        speed_test '3499' 'Hermosillo, MX'
        speed_test '7945'  'Guadalajara, MX'
        speed_test '54754' 'Mexico City, MX' 
        speed_test '9176' 'Merida, MX'
    elif [ "$REGION" = "sa" ]; then
        speed_test '21568' 'Sao Paulo, BR'
        speed_test '3065' 'Rio, BR'
        speed_test '21836' 'Salvador, BR'
        speed_test '5181'  'Buenos, AR' 
        speed_test '46678' 'Buenos, AR'
        speed_test '8017' 'Santiago, CL'
        speed_test '3455' 'Lima, PE'
        speed_test '21800' 'Quito, EC'
        speed_test '56516'  'Caracas, VE' 
        speed_test '44095' 'Bogota, CO'
    elif [ "$REGION" = "eu" ]; then
        speed_test '26434' 'London, UK'
        speed_test '38157' 'Edinburgh, UK'
        speed_test '38092' 'Dublin, IE' 
        speed_test '51395' 'Amsterdam, NL'
        speed_test '20005' 'Dronten, NL'
        speed_test '24215' 'Paris, FR'
        speed_test '48390' 'Marseille, FR'
        speed_test '14979' 'Madrid, ES'
        speed_test '1695' 'Barcelona, ES'
        speed_test '29467' 'Lisbon, PT' 
        speed_test '3243' 'Rome, IT'
        speed_test '4302' 'Milan, IT'
        speed_test '23969' 'Zurich, CH'
        speed_test '44081' 'Frankfurt, DE'
        speed_test '55665' 'Berlin, DE'
        speed_test '12390' 'Vienna, AT'  
        speed_test '7842' 'Budapest, HU' 
        speed_test '23122' 'Gdansk, PL'
        speed_test '4166'  'Warsaw, PL'
        speed_test '29259' 'Lviv, UA'   
        speed_test '9332' 'Kyiv, UA'
        speed_test '27486' 'Minsk, BY'
        speed_test '16457' 'Bucharest, RO'
        speed_test '11502' 'Iasi, RO'
        speed_test '22669' 'Helsinki, FI'
        speed_test '44597' 'Stockholm, SE'   
        speed_test '35461' 'Oslo, NO'
        speed_test '3682' 'Moscow, RU'
        speed_test '4247' 'Petersburg, RU'
        speed_test '31851' 'Istanbul, TR'
        speed_test '11945' 'Tbilisi, GE'
    elif [ "$REGION" = "au" ]; then
        speed_test '18473' 'Brisbane'
        speed_test '44735' 'Sydney'
        speed_test '12492' 'Sydney'
        speed_test '15136' 'Perth'
        speed_test '50848' 'Perth' 
        speed_test '43024' 'Melbourne'
        speed_test '12491' 'Melbourne'
        speed_test '13277' 'Adelaide'
        speed_test '18711' 'Canberra'
        echo -e
        speed_test '4953'  'Auckland' 
        speed_test '34083' 'Auckland'
    elif [ "$REGION" = "africa" ]; then
        speed_test '2962' 'Cape Town, ZA'
        speed_test '1491' 'Cape Town, ZA'
        speed_test '21570' 'Johannesburg, ZA'
        speed_test '56612' 'Harare, ZW'
        speed_test '28816' 'Maputo, MZ' 
        speed_test '7755' 'Antananarivo, MG'
        speed_test '3846' 'Darusalaam, TZ'
        speed_test '8402' 'Nairobi, KE'
        speed_test '48973' 'Addis Ababa, ET'
        speed_test '34283'  'Cairo, EG' 
        speed_test '15495' 'Alexandria, EG' 
        speed_test '54524' 'Rabat, MA' 
        speed_test '15631' 'Algiers, DZ' 
        speed_test '33159' 'Lagos, NG'    
    elif [ "$REGION" = "iran" ]; then
        speed_test '18512' 'Tehran'
        speed_test '4317'  'Tehran' 
        speed_test '43844'  'Tehran' 
        speed_test '22297' 'Shiraz'
        speed_test '22245' 'Isfahan'
        speed_test '9888' 'Tabriz'
    elif [ "$REGION" = "china" ]; then
        speed_test '24447' 'CU - Shanghai'
        speed_test '3633'  'CT - Shanghai' 
        speed_test '25858'  'CM - Beijing' 
        speed_test '43752'  'CU - Beijing'
        speed_test '26352' 'CT - Nanjing'
        speed_test '37235' 'CU - Shenyang'
        speed_test '5396' 'CT - Suzhou'
        speed_test '5317' 'CT - Yangzhou'
        speed_test '54312' 'CM - Hangzhou'
        speed_test '36646' 'CU - Zhengzhou'
        speed_test '28225' 'CT - Changsha'
        speed_test '4870' 'CU - Changsha'
        speed_test '4575' 'CM - Chengdu'
        speed_test '23844' 'CT - Wuhan'
        speed_test '29105' 'CM - Xi an'
        speed_test '17145' 'CT - Hefei'
        speed_test '34115' 'CT - TianJin'
        echo -e
        speed_test '32155' 'CM - Kwai Chung'
        speed_test '37639'  'CM - Hong Kong' 
        speed_test '34555' 'Hong Kong'    
        speed_test '28912' 'Hong Kong'
        speed_test '44745' 'Hong Kong'  
    else
        speed_test '29372' 'Kochi, IN'
        speed_test '52216' 'Bangalore, IN'
        speed_test '9690' 'Chennai, IN' 
        speed_test '40507' 'Mumbai, IN'
        speed_test '56195' 'Delhi, IN'
        echo -e
        speed_test '35180' 'Seattle, US'
        speed_test '34840' 'Los Angeles, US'
        speed_test '22288' 'Dallas, US'
        speed_test '47746' 'Miami, US'
        speed_test '46120' 'New York, US'
        speed_test '46143' 'Toronto, CA'
        echo -e 
        speed_test '37536' 'London, UK'
        speed_test '35058' 'Amsterdam, NL'
        speed_test '28308' 'Paris, FR'
        speed_test '44081' 'Frankfurt, DE'
        speed_test '51157' 'Warsaw, PL'
        speed_test '15004' 'Bucharest, RO'
        echo -e 
        speed_test '14580' 'Jeddah, SA'
        speed_test '4845'  'Dubai, AE'
        speed_test '34240' 'Fujairah, AE'
        echo -e 
        speed_test '28910' 'Tokyo, JP'
        #speed_test '24447' 'Shanghai, CU-CN'
        speed_test '37235' 'Shenyang, CU-CN'
        speed_test '26352' 'Nanjing, CT-CN'
        speed_test '1536'  'Hong Kong, CN'
        speed_test '40508' 'Singapore, SG'
        speed_test '56632' 'Jakarta, ID'
    fi 
    

    TOTAL_DATA=$(awk -v dl="$DL_USED" -v ul="$UL_USED" 'BEGIN { total=dl+ul; printf "%.2f\n", total }')
    TOTAL_DATA_IN_GB=$(awk -v total="$TOTAL_DATA" 'BEGIN { printf "%.2f\n", total/1024 }')

    DL_USED_IN_GB=$(awk -v dl="$DL_USED" 'BEGIN { printf "%.2f\n", dl/1024 }')
    UL_USED_IN_GB=$(awk -v ul="$UL_USED" 'BEGIN { printf "%.2f\n", ul/1024 }')

    AVG_DL_SPEED=$(awk -v avg_dl="$AVG_DL_SPEED" -v success="$SUCCESS_TEST" 'BEGIN { printf "%.2f\n", avg_dl/success }')
    AVG_UL_SPEED=$(awk -v avg_ul="$AVG_UL_SPEED" -v success="$SUCCESS_TEST" 'BEGIN { printf "%.2f\n", avg_ul/success }')
}

io_test() {
    (LANG=C dd if=/dev/zero of=benchtest_$$ bs=512k count=$1 conv=fdatasync && rm -f benchtest_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

calc_size() {
    local raw=$1
    local total_size=0
    local num=1
    local unit="KB"
    if ! [[ ${raw} =~ ^[0-9]+$ ]] ; then
        echo ""
        return
    fi
    if [ "${raw}" -ge 1073741824 ]; then
        num=1073741824
        unit="TB"
    elif [ "${raw}" -ge 1048576 ]; then
        num=1048576
        unit="GB"
    elif [ "${raw}" -ge 1024 ]; then
        num=1024
        unit="MB"
    elif [ "${raw}" -eq 0 ]; then
        echo "${total_size}"
        return
    fi
    total_size=$( awk 'BEGIN{printf "%.1f", '$raw' / '$num'}' )
    echo "${total_size} ${unit}"
}

ip_info() {
    echo " Basic Network Info"
    next
    local net_type="$(wget -qO- http://ip6.me/api/ | cut -d, -f1)"
    local net_ip="$(wget -qO- http://ip6.me/api/ | cut -d, -f2)"

    # IP-API Details - IPv6/IPv4
    local response=$(wget -qO- http://ip-api.com/json/$net_ip)

    local country=$(echo "$response" | grep -Po '"country": *\K"[^"]*"')
    local country=${country//\"}

    local region=$(echo "$response" | grep -Po '"regionName": *\K"[^"]*"')
    local region=${region//\"}

    local region_code=$(echo "$response" | grep -Po '"region": *\K"[^"]*"')
    local region_code=${region_code//\"}

    local city=$(echo "$response" | grep -Po '"city": *\K"[^"]*"')
    local city=${city//\"}

    local isp=$(echo "$response" | grep -Po '"isp": *\K"[^"]*"')
    local isp=${isp//\"}

    local org=$(echo "$response" | grep -Po '"org": *\K"[^"]*"')
    local org=${org//\"}

    local as=$(echo "$response" | grep -Po '"as": *\K"[^"]*"')
    local as=${as//\"}

    # IPINFO.IO Details - IPv4 only

    local response_ipv4=$(wget -qO- ipinfo.io)

    local ipv4_city=$(echo "$response_ipv4" | grep -Po '"city": *\K"[^"]*"')
    local ipv4_city=${ipv4_city//\"}

    local ipv4_region=$(echo "$response_ipv4" | grep -Po '"region": *\K"[^"]*"')
    local ipv4_region=${ipv4_region//\"}

    local ipv4_country=$(echo "$response_ipv4" | grep -Po '"country": *\K"[^"]*"')
    local ipv4_country=${ipv4_country//\"}

    local ipv4_asn=$(echo "$response_ipv4" | grep -Po '"org": *\K"[^"]*"')
    local ipv4_asn=${ipv4_asn//\"}

    if [[ -n "$net_type" ]]; then
        echo " Primary Network    : $(_green "$net_type")"
    fi

    if [[ -n "$isp" ]]; then
        echo " ISP                : $(_blue "$isp")"
    else
        echo " ISP                : Unknown"
    fi

    if [[ -n "$as" ]]; then
        echo " ASN                : $(_blue "$as")"
    else
        echo " ASN                : Unknown"
    fi

    if [[ "$ipv4_asn" != "$as" ]]; then
        echo " ASN (IPv4)         : $(_blue "$ipv4_asn")"
    fi   

    if [[ -n "$org" ]]; then
        echo " Host               : $(_blue "$org")"
    fi

    if [[ -n "$city" && -n "$region" && -n "$country" ]]; then
        echo " Location           : $(_yellow "$city, $region-$region_code, $country")"
    fi

    if [[ "$ipv4_city" != "$city" && "$ipv4_region" != "$region" && -n "$ipv4_city" && -n "$ipv4_region" && -n "$ipv4_country" ]]; then
        echo " Location (IPv4)    : $(_yellow "$ipv4_city, $ipv4_region, $ipv4_country")"
    fi    
}

install_speedtest() {
    if [ ! -e "./speedtest-cli/speedtest" ]; then
        sys_bit=""
        local sysarch="$(uname -m)"
        if [ "${sysarch}" = "unknown" ] || [ "${sysarch}" = "" ]; then
            local sysarch="$(arch)"
        fi
        if [ "${sysarch}" = "x86_64" ]; then
            sys_bit="x86_64"
        fi
        if [ "${sysarch}" = "i386" ] || [ "${sysarch}" = "i686" ]; then
            sys_bit="i386"
        fi
        if [ "${sysarch}" = "armv8" ] || [ "${sysarch}" = "armv8l" ] || [ "${sysarch}" = "aarch64" ] || [ "${sysarch}" = "arm64" ]; then
            sys_bit="aarch64"
        fi
        if [ "${sysarch}" = "armv7" ] || [ "${sysarch}" = "armv7l" ]; then
            sys_bit="armhf"
        fi
        if [ "${sysarch}" = "armv6" ]; then
            sys_bit="armel"
        fi
        [ -z "${sys_bit}" ] && _red "Error: Unsupported system architecture (${sysarch}).\n" && exit 1
        url1="https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-${sys_bit}.tgz"
        url2="https://dl.lamp.sh/files/ookla-speedtest-1.1.1-linux-${sys_bit}.tgz"
        wget --no-check-certificate -q -T10 -O speedtest.tgz ${url1}
        if [ $? -ne 0 ]; then
            wget --no-check-certificate -q -T10 -O speedtest.tgz ${url2}
            [ $? -ne 0 ] && _red "Error: Failed to download speedtest-cli.\n" && exit 1
        fi
        mkdir -p speedtest-cli && tar zxf speedtest.tgz -C ./speedtest-cli && chmod +x ./speedtest-cli/speedtest
        rm -f speedtest.tgz
    fi
    echo " Speedtest.net (Region: $REGION_NAME)"
    next
    printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " Location" "Latency" "Loss" "DL Speed" "UP Speed" "Server"
}

print_intro() {
    echo "---------------------------- network-speed.xyz ----------------------------"
    echo "      A simple script to test network performance using speedtest-cli      "
    next
    echo " Version            : $(_green v2023.09.04)"
    echo " Global Speedtest   : $(_red "wget -qO- network-speed.xyz | bash")"
    echo " Region Speedtest   : $(_red "wget -qO- network-speed.xyz | bash -s -- -r <region>")"
}

# Get System information
get_system_info() {
    cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    cores=$( awk -F: '/processor/ {core++} END {print core}' /proc/cpuinfo )
    freq=$( awk -F'[ :]' '/cpu MHz/ {print $4;exit}' /proc/cpuinfo )
    ccache=$( awk -F: '/cache size/ {cache=$2} END {print cache}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    cpu_aes=$( grep -i 'aes' /proc/cpuinfo )
    cpu_virt=$( grep -Ei 'vmx|svm' /proc/cpuinfo )
    tram=$( LANG=C; free | awk '/Mem/ {print $2}' )
    tram=$( calc_size $tram )
    uram=$( LANG=C; free | awk '/Mem/ {print $3}' )
    uram=$( calc_size $uram )
    swap=$( LANG=C; free | awk '/Swap/ {print $2}' )
    swap=$( calc_size $swap )
    uswap=$( LANG=C; free | awk '/Swap/ {print $3}' )
    uswap=$( calc_size $uswap )
    up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days, %d hour %d min\n",a,b,c)}' /proc/uptime )
    if _exists "w"; then
        load=$( LANG=C; w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
    elif _exists "uptime"; then
        load=$( LANG=C; uptime | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
    fi
    opsy=$( get_opsy )
    arch=$( uname -m )
    if _exists "getconf"; then
        lbit=$( getconf LONG_BIT )
    else
        echo ${arch} | grep -q "64" && lbit="64" || lbit="32"
    fi
    kern=$( uname -r )
    disk_total_size=$( LANG=C; df -t simfs -t ext2 -t ext3 -t ext4 -t btrfs -t xfs -t vfat -t ntfs -t swap --total 2>/dev/null | grep total | awk '{ print $2 }' )
    disk_total_size=$( calc_size $disk_total_size )
    disk_used_size=$( LANG=C; df -t simfs -t ext2 -t ext3 -t ext4 -t btrfs -t xfs -t vfat -t ntfs -t swap --total 2>/dev/null | grep total | awk '{ print $3 }' )
    disk_used_size=$( calc_size $disk_used_size )
    tcpctrl=$( sysctl net.ipv4.tcp_congestion_control | awk -F ' ' '{print $3}' )

    virt_type=$(systemd-detect-virt)
    virt_type=${virt_type^^} || virt="UNKNOWN"
}
# Print System information
print_system_info() {
    echo " Basic System Info"
    next

    if [ -n "$cname" ]; then
        echo " CPU Model          : $(_blue "$cname")"
    else
        echo " CPU Model          : $(_blue "CPU model not detected")"
    fi
    if [ -n "$freq" ]; then
        echo " CPU Cores          : $(_blue "$cores @ $freq MHz")"
    else
        echo " CPU Cores          : $(_blue "$cores")"
    fi
    if [ -n "$ccache" ]; then
        echo " CPU Cache          : $(_blue "$ccache")"
    fi
    if [ -n "$cpu_aes" ]; then
        echo " AES-NI             : $(_green "\xE2\x9C\x94 Enabled")"
    else
        echo " AES-NI             : $(_red "\xE2\x9D\x8C Disabled")"
    fi
    if [ -n "$cpu_virt" ]; then
        echo " VM-x/AMD-V         : $(_green "\xE2\x9C\x94 Enabled")"
    else
        echo " VM-x/AMD-V         : $(_red "\xE2\x9D\x8C Disabled")"
    fi
    echo " Total Disk         : $(_yellow "$disk_total_size") $(_blue "($disk_used_size Used)")"
    echo " Total RAM          : $(_yellow "$tram") $(_blue "($uram Used)")"
    if [ "$swap" != "0" ]; then
        echo " Total Swap         : $(_blue "$swap ($uswap Used)")"
    fi
    echo " System uptime      : $(_blue "$up")"
    echo " Load average       : $(_blue "$load")"
    echo " OS                 : $(_blue "$opsy")"
    echo " Arch               : $(_blue "$arch ($lbit Bit)")"
    echo " Kernel             : $(_blue "$kern")"
    echo " Virtualization     : $(_blue "$virt_type")"
}

print_network_statistics() {
    echo " Avg DL Speed       : $AVG_DL_SPEED Mbps"
    echo " Avg UL Speed       : $AVG_UL_SPEED Mbps"
    echo -e
    echo " Total DL Data      : $DL_USED_IN_GB GB"
    echo " Total UL Data      : $UL_USED_IN_GB GB"
    echo " Total Data         : $TOTAL_DATA_IN_GB GB"  
}

print_end_time() {
    end_time=$(date +%s)
    time=$(( ${end_time} - ${start_time} ))
    if [ ${time} -gt 60 ]; then
        min=$(expr $time / 60)
        sec=$(expr $time % 60)
        echo " Duration           : ${min} min ${sec} sec"
    else
        echo " Duration           : ${time} sec"
    fi
    date_time=$(date '+%d/%m/%Y - %H:%M:%S %Z')
    echo " System Time        : $date_time"

}

get_runs_counter() {
    local counter=$(wget -qO- https://runs.network-speed.xyz/)

    if [[ -n "$counter" ]]; then
        echo " Total Script Runs  : $(_green "$counter")"
    fi
}

run_speed_sh() {
    ! _exists "wget" && _red "Error: wget command not found.\n" && kill -INT $$ && exit 1
    ! _exists "free" && _red "Error: free command not found.\n" && kill -INT $$ && exit 1

    start_time=$(date +%s)
    get_system_info
    clear
    print_intro 
    next
    print_system_info
    next
    ip_info
    next
    install_speedtest  
    speed 
    rm -fr speedtest-cli
    next
    print_network_statistics
    next
    print_end_time
    get_runs_counter
    next
}

REGION="global"
REGION_NAME="GLOBAL"

while getopts ":r:" opt; do
  case $opt in
    r)
      case $OPTARG in
        india)
          REGION="india"
          REGION_NAME="INDIA भारत"
          ;;
        asia)
          REGION="asia"
          REGION_NAME="ASIA"
          ;;
        middle-east)
          REGION="middle-east"
          REGION_NAME="GCC MIDDLE EAST"
          ;;
        na)
          REGION="na"
          REGION_NAME="NORTH AMERICA"
          ;;
        sa)
          REGION="sa"
          REGION_NAME="SOUTH AMERICA"
          ;;
        eu)
          REGION="eu"
          REGION_NAME="EUROPE"
          ;;
        au)
          REGION="au"
          REGION_NAME="AUSTRALIA/NZ"
          ;;
        africa)
          REGION="africa"
          REGION_NAME="AFRICA"
          ;;  
        iran)
          REGION="iran"
          REGION_NAME="IRAN ایران"
          ;;  
        china)
          REGION="china"
          REGION_NAME="CHINA 中華人民共和國"
          ;;  
        *)
          echo "Invalid REGION: $OPTARG" >&2
          echo "Valid Regions: na, sa, eu, au, asia, africa, middle-east, india, china, iran"
          echo "Visit network-speed.xyz for instructions."
          exit 1
          ;;
      esac
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Visit network-speed.xyz for instructions."
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      echo "Visit network-speed.xyz for instructions."
      exit 1
      ;;
  esac
done


# run_speed_sh 
run_speed_sh | tee >(sed $'s/\033[[][^A-Za-z]*[A-Za-z]//g' > network-speed.txt)

if command -v curl >/dev/null; then
  share_link=$(curl -s -X POST -F 'file=@network-speed.txt' -F "region=$REGION" https://result.network-speed.xyz/upload)
  if [ $? -ne 0 ]; then
    echo " Unable to share result online"
    echo " Result stored locally in $PWD/network-speed.txt"
  else
    if echo "$share_link" | grep -qE '^https?://.+'; then
        echo " Result             : $share_link"
        rm network-speed.txt
    else
        echo " Unable to share result online - There is some issue with the online uploader."
        echo " Result stored locally in $PWD/network-speed.txt"
    fi    
  fi
else
  echo " curl is not installed, Unable to share result online"
  echo " Result stored locally in $PWD/network-speed.txt"
fi

next
