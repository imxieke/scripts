#!/bin/sh
# Benchy V2.7
# Heavily influenced by masonr's Yet-Another-Bench-Script
# https://github.com/masonr/yet-another-bench-script
# shellcheck disable=SC2183,SC2030,SC2086,SC2181,SC2031
currentVersion="v2.7"; rev_date="24 Jun 2023"
# Geekbench link
gb6_link="https://cdn.geekbench.com/Geekbench-6.1.0-Linux.tar.gz"
gb5_link="https://cdn.geekbench.com/Geekbench-5.5.1-Linux.tar.gz"
gb4_link="https://cdn.geekbench.com/Geekbench-4.4.4-Linux.tar.gz"
gbarm_link="https://cdn.geekbench.com/Geekbench-5.5.0-LinuxARMPreview.tar.gz"
disable_color() {
  arg_colorize="false"
  unset cred cgreen cyellw cblue cyan csky clyl creset
  unset cbwhite cbgreen cbyan cbsky cblgreen cbyellw cblsky
}
colordefiner() {
  if [ "$arg_colorize" = "false" ]; then
    disable_color && return 1
  else
    if ! is_installed perl; then
      disable_color
      die "Continuing without color as perl is not found"; return 1
    elif [ "$(tput colors)" -ne "256" ]; then
      disable_color
      die "Continuing without color as your terminal does not support 256 colors"; return 1
    else
      if [ -t 1 ]; then
        # Non bold
        cred=$(tput sgr0; tput setaf 1 ${is_bsd:+0 0}); clyl=$(tput sgr0; tput setaf 11 ${is_bsd:+0 0})
        cgreen=$(tput sgr0; tput setaf 2 ${is_bsd:+0 0}); cyan=$(tput sgr0; tput setaf 6 ${is_bsd:+0 0})
        cyellw=$(tput sgr0; tput setaf 215 ${is_bsd:+0 0}); csky=$(tput sgr0; tput setaf 14 ${is_bsd:+0 0})
        # Bold
        cbwhite=$(tput bold; tput setaf 7 ${is_bsd:+0 0}); cblgreen=$(tput bold; tput setaf 121 ${is_bsd:+0 0})
        cbgreen=$(tput bold; tput setaf 2 ${is_bsd:+0 0}); cbyan=$(tput bold; tput setaf 6 ${is_bsd:+0 0})
        cbyellw=$(tput bold; tput setaf 11 ${is_bsd:+0 0}); cbsky=$(tput bold; tput setaf 14 ${is_bsd:+0 0})
        cblsky=$(tput bold; tput setaf 159 ${is_bsd:+0 0})
        # Reset color
        creset=$(tput sgr0)
      else
        disable_color && return 1
      fi
    fi
  fi
}
anstripper() { perl -pe 's/\e\[[0-9;]*m(?:\e\[K)?//g' ; }
picklargestpart() { awk '{print substr($1, 1, match($1, "[[:digit:]]") - 1), $0}' | sort -k1,1 -k3,3nr | awk 'id!=$1{ print; id = $1}' | cut -d ' ' -f2- ; }
anstripper_ng() {
  if [ "$parseit" = "true" ] && [ "$docolor" = "true" ]; then
    $decolorize $outputdir/benchy.log > /tmp/temporary_benchy.log && mv /tmp/temporary_benchy.log $outputdir/benchy.log 2>/dev/null
  fi
}
diskify() {
  case "$disk_list" in
    *,*)
    disk_list=$(echo "$disk_list" | tr -d '[:space:]' | tr ',' ' ')
    for disk in $disk_list; do
      if [ -b "$disk" ]; then
        df -k "$disk" 2>/dev/null | awk 'NR>1{ printf("%s\t%s\t%s\n", $1, $2, $NF) }' >> $disk_tmp
      else
        >&2 echo "$disk is invalid disk"; rm -f $disk_tmp; exit 1
      fi
    done
      ;;
    "all")
    df -k 2>/dev/null | awk 'NR>1 && $0 !~ /(\/snap\/|^tmpfs|^dev|^udev|\/docker\/|^none|\/boot\/)/{ printf("%s\t%s\t%s\n", $1, $2, $NF) }' | picklargestpart >> $disk_tmp
      ;;
    *)
    if [ -b "$disk_list" ]; then
      df -k "$disk_list" 2>/dev/null | awk 'NR>1{ printf("%s\t%s\t%s\n", $1, $2, $NF) }' >> $disk_tmp
    else
      >&2 echo "$disk_list is invalid disk"; rm -f $disk_tmp; exit 1
    fi
      ;;
  esac
}
header_intro() {
  startTime=$(awk 'BEGIN {srand(); print srand()}')
  currentDate=$(date +"%d %b %Y %H:%M %Z")
  currentDateiso=$(date +"%Y-%m-%dT%H:%M:%S%:z")
  {
    printf "${cbyan}%s\n" "# # # # # # # # # # # # # # # # # # # # #"
    printf "%s\n" "#             ${cbwhite}Benchy ${cbgreen}$currentVersion${cbyan}               #"
    printf "%s\n" "#    ${cbwhite}https://github.com/L1so/benchy${cbyan}     #"
    printf "%s\n" "# # # # # # # # # # # # # # # # # # # # #"
    printf "%s\n" "#        ${cbgreen}$currentDate${cbyan}          #"
    printf "%s\n" "# # # # # # # # # # # # # # # # # # # # #${creset}"
    echo
  } | parse_output
}

display_help() {
  cat <<'EOT'
Usage: benchy [options]
Options:
  -o, --output            Store benchy result to file in given directory (default: Current directory)
  -c, --color=ARG         Enable or disable colored output (Valid ARG: yes, no, force)
  -e, --grab-env          Pull benchy environmental file
  -u, --use-env           Use environmental file in place of regular option
  -k, --keep-file         Keep benchy related files after successful run (default: Remove)
  -4, --geekbench4        Utilize ONLY geekbench 4 instead of 6
  -5, --geekbench5        Utilize ONLY geekbench 5 instead of 6
  -1, --geekbench         Utilize both geekbench 5 and 6
  -j, --json              Store benchy result as json
  -m, --region            Enable region based network test, otherwise will use mixed source
  -n, --skip-network      Skip network measurement test
  -d, --skip-disk         Skip fio disk benchmark test
  -g, --skip-gb           Skip geekbench 5 test
  -r, --region=ARG        Specify region to bench network (Valid ARG: as, af, eu, na, sa, oc, mix)
  -f, --disk=ARG          Specify what disk to bench (e.g. /dev/nvme0np3 or /dev/sda3)
  -s, --speedtest         Prefer speedtest in place of iperf3
  -i, --show-ip           Display server public IP address
  -p, --parse-only        Only parse basic information (equal to -ndg)
  -h, --help              Display this help section
  -v, --version           Display version
EOT
}
is_installed() { command -v $1 >/dev/null 2>&1; }
die() { printf "%s\n" "$@" >&2; }
say() {
  if [ "$arg_colorize" = "false" ]; then
    printf "%s" "$@"
  else
    printf "${cyan}%s${creset}" "$@"
  fi
}
case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*) osv="linux";;
  *bsd*) osv="bsd"; is_bsd="yes";;
  *) die "OS Not supported"; exit 1;;
esac
# Prioritize curl over wget
if is_installed curl; then
  # 0 Implies curl
  filegrab=0
elif is_installed wget; then
  # 1 Implies wget
  filegrab=1
else
  die "Neither wget nor curl is exist" "Please install it first"
  exit 1
fi
disk_tmp="/tmp/benchy_df.log"
# BEGIN OPTION PARSING (source https://stackoverflow.com/a/62616466/12289283)
usage_error () { printf "%s\n%s\n" "$1" "Try 'benchy --help' to view available option" >&2; exit 2; }
assert_argument () { { test "$1" != "$endofline" && case "$1" in -*) >&2 printf "%s\n" "$opt: Illegal input parameter ($1)"; exit 2;; esac; } || { printf "%s\n" "$2: requires an argument" >&2 && exit 2 ; }; }
if [ "$#" != 0 ]; then
  set -- "$@" "${endofline:=$(printf '\1\3\3\7')}"
  while [ "$1" != "$endofline" ]; do
    opt="$1"; shift
    case "$opt" in
      -k|--keep-file) arg_keep_file="true";;
      -4|--geekbench4) arg_use_gb4="true";;
      -5|--geekbench5) arg_use_gb5="true";;
      -1|--geekbench) arg_use_gb56="true";;
      -j|--json) arg_json="true";;
      -c|--color)
      assert_argument "$1" "$opt"
      colchoice="$1"
      case "$colchoice" in
        yes) arg_colorize="true";; # Default
        no) arg_colorize="false";;
        force) arg_colorize="force";;
        *) die "Valid value is yes|no|force"; exit 2;;
      esac
      shift ;;
      -m|--region) arg_use_region="true";;
      -u|--use-env) arg_use_env="true";;
      -e|--grab-env)
      printf "%s" "Pulling env file to home directory"
      if [ "$filegrab" -eq 0 ]; then
        curl -o "${HOME}/.benchy_opt" -kLs --connect-timeout 5 --retry 5 --retry-delay 0 "https://raw.githubusercontent.com/L1so/benchy/main/benchy_env"
      elif [ "$filegrab" -eq 1 ]; then
        wget -qO "${HOME}/.benchy_opt" "https://raw.githubusercontent.com/L1so/benchy/main/benchy_env"
      fi
      printf "%s\n" " [DONE]"; exit 0
      ;;
      -n|--skip-network) arg_skip_network="true";;
      -d|--skip-disk) arg_skip_disk="true";;
      -g|--skip-gb) arg_skip_gb="true";;
      -i|--show-ip) arg_show_ip="true";;
      -s|--speedtest) arg_prefer_speedtest="true";;
      -x|--dev-branch) branch="dev";;
      -p|--parse-only)
      arg_skip_network="true"
      arg_skip_disk="true"
      arg_skip_gb="true"
      ;;
      -r|--region-pick)
      assert_argument "$1" "$opt"
      concode="$1"
      case "$concode" in
        [Aa][Ss]) continent="Asia";;
        [Aa][Ff]) continent="Africa";;
        [Ee][Uu]) continent="Europe";;
        [Nn][Aa]) continent="North America";;
        [Ss][Aa]) continent="South America";;
        [Oo][Cc]) continent="Oceania";;
        [Mm][Ii][Xx]) continent="Mixed";;
      esac
      shift
      ;;
      -f|--disk)
      assert_argument "$1" "$opt"
      disk_list="$1"
      diskify
      shift
      ;;
      -o|--output)
      arg_output_file="true"; outputdir=$1
      case "$outputdir" in
        -*) outputdir="$PWD";;
        "$endofline") outputdir="$PWD";;
      esac
      ;;
      -h|--help) display_help; exit 0;;
      -v|--version) printf "%-8s %-1s %s\n" "Version" ":" "$currentVersion" "Revision" ":" "$rev_date"; exit 0;;

      --) while [ "$1" != "$endofline" ]; do set -- "$@" "$1"; shift; done;;
      --[!=]*=*) set -- "${opt%%=*}" "${opt#*=}" "$@";;
      -[A-Za-z0-9] | -*[!A-Za-z0-9]*) usage_error "Unknown option: '$opt'";;
      -?*) other="${opt#-?}"; set -- "${opt%$other}" "-${other}" "$@";;
      *) set -- "$@" "$opt";;
    esac
  done; shift
fi
# END OPTION PARSING
# Check for user default option
if [ -f ${HOME}/.benchy_opt ] && [ -n "$arg_use_env" ]; then
  . ${HOME}/.benchy_opt
  [ -n "$directory" ] && outputdir=$directory
  [ -n "$disk_list" ] && diskify
fi
[ -n "$arg_json" ] && logext="json" || logext="log"
if [ -n "$arg_output_file" ]; then outputdir="${outputdir:-${PWD}}"; test -f "${outputdir}/benchy.${logext}" && rm -f "${outputdir}/benchy.${logext}"; fi
outputdir="${outputdir:-/tmp}"
{ [ ! -d $outputdir ] || [ ! -w $outputdir ] ; } && { die "$outputdir does not exist or not writable" && exit 2; }
if [ -z "$arg_json" ] && { [ -n "$arg_output_file" ] || [ -n "$outputdir" ]; } || { [ -z "$arg_skip_disk" ] && [ -z "$arg_skip_network" ] && [ -z "$arg_skip_gb" ]; }; then parseit="true"; fi
{ [ -z "$arg_use_region" ] && [ -z "$continent" ]; } && continent="Mixed"

# Source https://gist.github.com/Akianonymus/25cfa570cb66821ab61846ceb0f9ca07
convertsize() { awk '{ split( "KiB MiB GiB TiB", v, " "); x=$1; if (x) p=int(log(x)/log(1024)); else p == 0; printf("%0.1f %s\n" , x/1024^p, v[p+1] ); }'; }
core_pkg() {
  is_installed locale && export LC_ALL=C
  for pkg in tput tar; do
    if ! is_installed $pkg; then
      die "$pkg missing from your system"
      exit 1
    fi
  done
}
parse_output() {
  if [ "$parseit" = "true" ]; then
    tee -a $outputdir/benchy.log $outputdir/benchy_c.log
  else
    cat
  fi
}

send_output() {
  if [ -f "$outputdir/benchy.${logext}" ] && { [ -z "$arg_skip_disk" ] && [ -z "$arg_skip_network" ] && [ -z "$arg_skip_gb" ]; }; then
    resulturl=$(
    if [ "$filegrab" -eq 0 ]; then
      curl -sS -F 'sprunge=<-' http://sprunge.us < $outputdir/benchy.${logext}
    elif [ "$filegrab" -eq 1 ]; then
      cat $outputdir/benchy.${logext} | wget -qO - --post-data="sprunge=$(cat)" http://sprunge.us
    fi
    )
    {
      if [ -n "$arg_use_gb56" ]; then
        printf "${cbwhite}| ${cblsky}%-45s ${cbwhite}| ${cblgreen}%-45s ${cbwhite}|\n" "Benchy result "$resulturl
        printf "${cbwhite}+%47s+%47s+${creset}\n" | tr ' ' '-'
      else
        printf "${cbwhite}| ${cblsky}%-18s ${cbwhite}| ${cblgreen}%-24s ${cbwhite}|\n" "Benchy result" "$resulturl"
        printf "${cbwhite}+%47s+${creset}\n" | tr ' ' '-'
      fi
    } | parse_output
    anstripper_ng
  fi
  rm -f /tmp/benchy.${logext} || true
}

format_disk() {
    b_formatdisk=$(printf "%s" ${1:-0} | tr -d -c 0-9) s_formatdisk=0
    d_formatdisk='' type_formatdisk=''
    while [ "${b_formatdisk}" -gt 1000 ]; do
        d_formatdisk="$(printf ".%02d" $((b_formatdisk % 1024 * 100 / 1024)))"
        b_formatdisk=$((b_formatdisk / 1024)) && s_formatdisk=$((s_formatdisk += 1))
    done
    j=0 && for i in KB/s MB/s GB/s; do
        j="$((j += 1))" && [ "$((j - 1))" = "${s_formatdisk}" ] && type_formatdisk="${i}" && break
        continue
    done
    printf "%s\n" "${b_formatdisk}${d_formatdisk} ${type_formatdisk}"
}

overline() {
  printf "\r%s" "$(tput el)"
}
print_space() { { printf "%${1}s" | tr ' ' '\n' ; } | parse_output; }

cleanup() {
  tput cnorm
  tput sgr0
  rm -f $fiofile $lsblkfifo $fiores $mainjson
}
trap 'cleanup; trap - EXIT; exit' EXIT INT HUP

file_grabber() {
  ddl_input="$1"
  if [ "$filegrab" -eq 0 ]; then
    case "$ddl_input" in
      *cdn.geekbench.com*) _curl_opt="-L --progress-bar";;
      *icanhazip.com*) _curl_opt="-s --connect-timeout 1 --max-time 1";;
      *) _curl_opt="-kLs --connect-timeout 5 --retry 5 --retry-delay 0 -o $2";;
    esac
    curl $_curl_opt $ddl_input
  elif [ "$filegrab" -eq 1 ]; then
    case "$ddl_input" in
      *cdn.geekbench.com*)
      { wget --help 2>&1 | grep -q -- '--show-progress'; } && _wget_opt="-qO- --show-progress --progress=bar:force" || _wget_opt="-qO-"
      ;;
      *icanhazip.com*) _wget_opt="--timeout=1 --tries=1 -qO-";;
      *) _wget_opt="-q -O $2";;
    esac
    wget $_wget_opt $ddl_input
  fi
}
print_virtualization() {
  if is_installed systemd-detect-virt; then
    user_virt=$(systemd-detect-virt)
    if [ $? -eq 0 ]; then
      case "$user_virt" in
        *[Kk][Vv][Mm]*) echo "kvm"; return 0;;
        *[Oo]pen[Vv][Zz]*) echo "openvz"; return 0;;
        *[Ll][Xx][Cc]*) echo "lxc"; return 0;;
        *[Ww][Ss][Ll]*) echo "wsl"; return 0;;
        *) echo "none"
      esac
    fi
  fi
  if is_installed dmidecode; then
    user_virt=$(dmidecode -s system-product-name 2>/dev/null)
    if [ $? -eq 0 ]; then
      case "$user_virt" in
        *[Kk][Vv][Mm]*) echo "kvm"; return 0;;
        *[Oo]pen[Vv][Zz]*) echo "openvz"; return 0;;
        *[Ll][Xx][Cc]*) echo "lxc"; return 0;;
        *[Ww][Ss][Ll]*) echo "wsl"; return 0;;
        *) echo "none"
      esac
    fi
  fi
  # Fallback to manual test if none of the above working
  # Qemu test
  if ls -1 /dev/disk/by-id/*qemu* >/dev/null 2>&1; then
    echo "qemu" && return 0
  fi
  # lxc test
  if grep -q lxc /proc/1/environ 2>/dev/null; then
    echo "lxc" && return 0
  fi
  # openvz test
  if [ -d "/proc/vz" ] && ! [ -d "/proc/bc" ]; then
    echo "openvz" && return 0
  fi
  # wsl test
  if grep -sq Microsoft /proc/version; then
    echo "wsl" && return 0
  fi
}

gb_string() {
  if [ "$gb_version" -eq 4 ]; then
    awk -F[\<\>] '/colspan=\0472\047/{ print $3 }' "$1"
  else
    grep '^Geekbench [0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*' "$1"
  fi
}
opening_json() {
  [ -z "$arg_json" ] && return 1
  cat <<JSON > $mainjson
{
  "benchy_ver" : "$currentVersion",
  "startDate"  : "$currentDateiso",
  "disk_bench" : {},
  "network_bench" : {
    "net_ipv4" : {},
    "net_ipv6" : {}
  },
  "geekbench_test" : {}
}
JSON
}
closing_json() {
  [ -z "$arg_json" ] && return 1
  endDateiso=$(date +"%Y-%m-%dT%H:%M:%S%:z")
  $jq --arg ed "$endDateiso" 'to_entries |
  ( map(.key == "startDate") | index(true) ) as $pos
  | .[0:$pos+1] + [{"key":"endDate","value":$ed}] + .[$pos+1:]
  | from_entries' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson"
  $jq 'walk(if type == "object" then with_entries(select(.value | (. != {} and . != []))) else . end)' "$mainjson" > $outputdir/benchy.json
  rm -f $mainjson
}

binarycheck() {
  [ -n "$this_instance_use_env" ] && printf "${cyan}%s${creset}\n" "Found predefined option !"
  # Building directory
  coyinibisa="YAKAANA"
  benchy_path=$HOME/.benchy_file
  fio_path=$benchy_path/fio
  iperf_path=$benchy_path/iperf3
  speedtest_path=$benchy_path/speedtest
  bc_path=$benchy_path/bc
  jq_path=$benchy_path/jq
  ipformation=$benchy_path/ipformation.json
  mainjson=$benchy_path/main.json
  continent_list=$benchy_path/continent.csv
  continent_file=$benchy_path/continent.txt
  decolorize=$benchy_path/uncolor.perl

  # Fio binary
  is_installed fio && fio="fio" || fio="$fio_path/fio"
  # Iperf binary
  [ -z "$arg_prefer_speedtest" ] && is_installed iperf3 && iperf="iperf3" || iperf="$iperf_path/iperf3"
  # bc binary
  is_installed bc && bc="bc" || bc="$bc_path/bc"
  # jq binary
  is_installed jq && jq="jq" || jq="$jq_path/jq"
  # Speedtest binary
  speedtest="$speedtest_path/speedtest"

  # IPv4 address
  ipv4_address=$(file_grabber ipv4.icanhazip.com)
  [ $? -eq 0 ] && ipv4_status="true" || ipv4_status="false"

  # IPv6 address
  ipv6_address=$(file_grabber ipv6.icanhazip.com)
  [ $? -eq 0 ] && ipv6_status="true" || ipv6_status="false"
  {
    mkdir -p $benchy_path
    say "Fetching required asset, please wait a moment..."
    gitlink="https://github.com/L1so/benchy/raw/${branch:-main}/binary"
    # IP Information
    [ ! -e $ipformation ] && file_grabber "ip-api.com/json" $ipformation
    # Continent.csv
    [ -n "$arg_use_region" ] && { [ ! -e $continent_list ] && file_grabber "https://gist.githubusercontent.com/L1so/e9e17570a4d81f12bb98c8ddc3bab539/raw" $continent_list; }
    case "$arg_colorize" in
      false) docolor="false";;
      *) docolor="true"; [ ! -e $decolorize ] && file_grabber "${gitlink}/uncolor.perl" $decolorize && chmod u+x "$decolorize";;
    esac

    # Skipping download binary if os was openbsd
    if [ -n "$is_bsd" ]; then
			say "Skipping downloading binary"
			overline
    fi

    # Download fio if not exist
    if [ "$fio" != "fio" ] && [ ! -f "$fio_path/fio" ]; then
      mkdir -p $fio_path
      file_grabber "${gitlink}/fio/fio_${arch}" "$fio_path/fio"
      [ $? -eq 0 ] && chmod u+x $fio_path/fio
    fi
    # Download iperf3 if not exist
    if [ -z "$arg_prefer_speedtest" ] && [ "$iperf" != "iperf3" ] && [ ! -f "$iperf_path/iperf3" ]; then
      mkdir -p $iperf_path
      file_grabber "${gitlink}/iperf3/iperf3_${arch}" "$iperf_path/iperf3"
      [ $? -eq 0 ] && chmod u+x $iperf_path/iperf3
    else
      # Download speedtest if not exist
      mkdir -p $speedtest_path
      file_grabber "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-${arch}.tgz" "$speedtest_path/ookla.tgz"
      tar -xzf "$speedtest_path/ookla.tgz" -C $speedtest_path && rm -f "$speedtest_path/ookla.tgz"
    fi
    # Download bc if not exist
    if [ "$bc" != "bc" ] && [ ! -f "$bc_path/bc" ]; then
      mkdir -p $bc_path
      file_grabber "${gitlink}/bc/bc_${arch}" "$bc_path/bc"
      [ $? -eq 0 ] && chmod u+x $bc_path/bc
    fi
    # Download jq if not exist
    if [ "$jq" != "jq" ] && [ ! -f "$jq_path/jq" ]; then
      mkdir -p $jq_path
      case "$arch" in
        "armhf"|"aarch64") jqddl="${gitlink}/jq/jq_${arch}";;
        *) jqddl="https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux${jq_arch}";;
      esac
      file_grabber "$jqddl" "$jq_path/jq"
      [ $? -eq 0 ] && chmod u+x $jq_path/jq
    fi
    overline
  }
}

user_arch() {
  # Determine what type of architecture this server runs off
  # Most commonly would be 64 bit
  arch=$(uname -m); disklimit="2048000" # 2048 MB
  case "$arch" in
    *x86_64*|*amd64*)
    arch="x86_64"
    jq_arch="64"
    fio_size="2G"
    if [ -n "$arg_use_gb56" ]; then
      gb_version=11
    elif [ -n "$arg_use_gb5" ]; then
      gb_version=5
      gb_ddl_link="$gb5_link"
    elif [ -n "$arg_use_gb4" ]; then
      gb_version=4
      gb_ddl_link="$gb4_link"
    else
      gb_version=6
      gb_ddl_link="$gb6_link"
    fi
    ;;
    *i?86*)
    arch="i386"
    jq_arch="32"
    fio_size="2G"
    gb_version=4
    gb_ddl_link="$gb4_link"
    ;;
    *arm*|*aarch*)
    case "$(getconf LONG_BIT)" in
      *64*) arch="aarch64";;
      *) arch="armhf";;
    esac
    fio_size="512M"; disklimit="512000"
    gb_version=5
    gb_ddl_link="$gbarm_link"
    ;;
    *) die "Architecture not found"; exit 1;;
  esac
  [ "$arch" != "x86_64" ] && unset arg_use_gb56 arg_use_gb4 arg_use_gb5
}
diskmeminfo() {
  # Disk & Memory Usage
  df_output=$(df -k 2>/dev/null | awk 'NR>1 && $0 !~ /(\/snap\/|^tmpfs|^dev|^udev|\/docker\/|^none|\/boot\/)/{ total+=$2; used+=$3; avai+=$4; cline++ }END{ printf("%s %s %s %.0f %s", total, used, avai, (used/total)*100, cline); }')
  disk_info=$(echo "$df_output" | awk '{ print $1 }' | convertsize)
  disk_usage=$(echo "$df_output"| awk '{ print $2 }'| convertsize)
  disk_percentage=$(echo "$df_output" | awk '{ print $4"%" }')
  disk_count=$(echo "$df_output" | awk '{ print $NF }')
  if [ -n "$is_bsd" ]; then
      mem_info=$(sysctl -n hw.physmem)
      mem_usage=$(vmstat | awk 'END{print ($3+0) * 1024}')
      mem_free=$((mem_info-mem_usage))
      mem_percentage=$(echo "$mem_usage*1024*100/$mem_free" | $bc)
      swap_info=$(pstat -s | awk '/dev/{print $2}' | convertsize)

      mem_info=$(echo "$((mem_info/1000))" | convertsize)
      mem_usage=$(echo "$mem_usage" | convertsize)
      mem_percentage=$(printf "%s%%" "$mem_percentage")
  else
      mem_info=$(awk -F":" '$1~/MemTotal/{print $2}' /proc/meminfo | convertsize)
      mem_usage=$(free -b | awk 'NR==2{printf "%.1f GiB\n", $3/1024^3 }')
      mem_percentage=$(free -b | awk 'NR==2{printf "%.0f%s\n", $3*100/$2, "%" }')
      swap_info=$(free | awk '/Swap/ {print $2}' | convertsize)
  fi
  mem_info_num=$(printf $mem_info | awk '{ print $1 }')
}
sysinfo() {
  # System Information
  # OS
  if [ -f "/etc/os-release" ]; then
  	. "/etc/os-release"
  	currentOS="${PRETTY_NAME}"
  	kernelver=$(uname -r)
  else
    if [ -n "$is_bsd" ]; then
      currentOS=$(uname -rs)
      kernelver=$(uname -v)
    else
      currentOS=$(uname)
      kernelver=$(uname -r)
    fi
  fi
  checkmark=$(printf "${cgreen}\342\234\224")
  crossmark=$(printf "${cred}\342\235\214")
  # Uptime
  if [ -n "$is_bsd" ]; then
    s=$(sysctl -n kern.boottime)
    s=${s#*=}
    s=${s%,*}
    s=$(($(date +%s) - s))
    d=$((s / 60 / 60 / 24))
    h=$((s / 60 / 60 % 24))
    m=$((s / 60 % 60))

    # Only append days, hours and minutes if they're non-zero.
    case "$d" in ([!0]*) uptime_now="${uptime_now}${d} days "; esac
    case "$h" in ([!0]*) uptime_now="${uptime_now}${h} hrs "; esac
    case "$m" in ([!0]*) uptime_now="${uptime_now}${m} mins"; esac
  else
    uptime_now=$(awk '{print int($1/86400)" days, "int($1%86400/3600)" hrs, "int(($1%3600)/60)" mins, "int($1%60)" secs"}' /proc/uptime)
  fi
  # Location
  country=$(grep -o '"'"country"'": *"[^"]*' "$ipformation" | grep -o '[^"]*$')
  country_code=$(grep -o '"'"countryCode"'": *"[^"]*' "$ipformation" | grep -o '[^"]*$')
  [ -n "$arg_use_region" ] && awk -F',' "/$country_code/{ print \$3 }" $continent_list > $continent_file
  # Organization
  ispasn=$(grep -o '"'"as"'": *"[^"]*' $ipformation | awk -F\" '{ print $4 }')
  isp=$(printf %s "$ispasn" | cut -d" " -f 2-)
  asn=$(printf %s "$ispasn" | cut -d" " -f -1)

  if [ "$arg_show_ip" = "true" ]; then
    # IPv4 check
    [ "$ipv4_status" = "true" ] && ipv4_string="$ipv4_address" || ipv4_string="$crossmark Disabled"
    [ "$ipv6_status" = "true" ] && ipv6_string="$ipv6_address" || ipv6_string="$crossmark Disabled"
  else
    # IPv6 check
    [ "$ipv4_status" = "true" ] && ipv4_string="$checkmark Enabled" || ipv4_string="$crossmark Disabled"
    [ "$ipv6_status" = "true" ] && ipv6_string="$checkmark Enabled" || ipv6_string="$crossmark Disabled"
  fi

  # Processor information
  if is_installed lscpu && { lscpu 2>&1 | grep -q -- 'Model name' ; }; then
    cpu_model=$(lscpu | awk -F: '/Model name/{ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}}' | sed 's/\(.\{41\}\).*/\1/')
  else
      if [ -n "$is_bsd" ]; then
					cpu_model=$(sysctl -n hw.model)
      else
					cpu_model=$(awk -F: '/model name/{ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}}' /proc/cpuinfo | sed 's/\(.\{41\}\).*/\1/' | cut -d @ -f1 | tr -s ' ')
      fi
  fi
  # CPU Frequency
  cpu_freq=$(
  awk 'NR==1{ print "@ "($1 / 1000) " MHz" }' /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq 2>/dev/null ||
  awk -F: '/cpu MHz/{ {gsub(/^[ \t]+|[ \t]+$/, "", $2); printf("@ %s MHz\n", $2); exit}}' /proc/cpuinfo 2>/dev/null ||
  printf "@ %s Mhz" $(sysctl -n hw.cpuspeed 2>/dev/null)
  )

  # CPU Core Count
  cpu_core=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null)

  # AES
  if { dmesg 2>/dev/null | grep -qE 'AES' ; } || grep -q -m 1 aes /proc/cpuinfo 2>/dev/null; then
    cpu_aes="$checkmark Enabled" && cpu_aes_j="true"
  else
    cpu_aes="$crossmark Disabled" && cpu_aes_j="false"
  fi

  # VMX/Virt
  if { dmesg 2>/dev/null | grep -qE '(VMX|SVM)' ; } || grep -q -m 1 'vmx\|svm' /proc/cpuinfo 2>/dev/null; then
    cpu_virt="$checkmark Enabled" && cpu_virt_j="true"
  else
    cpu_virt="$crossmark Disabled" && cpu_virt_j="false"
  fi
  virt_type="$(print_virtualization)"
  virt_type="${virt_type:-none}"
  # Moved to new function (FIX TO https://github.com/L1so/benchy/issues/30)
  printf "${cbwhite}%-48s%s\n" "Server Insight" "Hardware Information"
  printf "${cbyan}%-48s%s\n" "---------------------" "---------------------"
  printf "${cbwhite}%-10s : ${csky}%-35s${cbwhite}%-11s : ${csky}%-10s\n" "OS" "$currentOS" "Model" "$cpu_model" "Location" "$country" "Core" "$cpu_core $cpu_freq" \
  "Kernel" "$kernelver" "AES-NI" "$cpu_aes" "Uptime" "$uptime_now" "VM-x/AMD-V" "$cpu_virt" "Virt" "$virt_type" "Swap" "$swap_info"
  echo
  printf "${cbwhite}%-48s%s\n" "Disk & Memory Usage" "Network Information"
  printf "${cbyan}%-48s%s\n" "---------------------" "---------------------"
  printf "${cbwhite}%-10s : ${csky}%-35s${cbwhite}%-11s : ${csky}%-10s\n" "Disk ($disk_count)" "$disk_info" "ASN" "$asn" "Disk Usage" "$disk_usage ($disk_percentage Used)" "ISP" "$(printf "%s" "$isp" | sed 's/\(.\{41\}\).*/\1../')" \
  "Mem" "$mem_info" "IPv4" "$ipv4_string" "Mem Usage" "$mem_usage ($mem_percentage Used)" "IPv6" "$ipv6_string"

  # Parse to JSON
  if [ -n "$arg_json" ]; then
    cat <<SYSJSON | $jq --argjson n "$(cat)" 'to_entries | ( map(.key == "startDate") | index(true) ) as $pos | .[0:$pos+1] + ($n|to_entries) + .[$pos+1:] | from_entries' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson"
    {
      "server_insight" : {
        "OS" : "$currentOS",
        "location" : "$country",
        "kernel" : "$kernelver",
        "uptime" : "$uptime_now",
        "virt" : "$virt_type"
      },
      "hardware_information" : {
        "cpu_model" : "$cpu_model",
        "cpu_core" : "$cpu_core $cpu_freq",
        "cpu_aes" : $cpu_aes_j,
        "cpu_virt" : $cpu_virt_j,
        "swap" : "$swap_info"
      },
      "disk_info" : {
        "disk" : "$disk_info",
        "disk_usage" : "$disk_usage",
        "disk_percentage" : "$disk_percentage",
        "mem" : "$mem_info",
        "mem_usage" : "$mem_usage",
        "mem_percentage" : "$mem_percentage"
      },
      "network_data" : {
        "asn" : "$asn",
        "isp" : "$isp",
        "ipv4" : $ipv4_status,
        "ipv6" : $ipv6_status
      }
    }
SYSJSON
  fi
}
disk_test() {
  { [ "$arg_skip_disk" = "true" ] || [ -n "$is_bsd" ]; } && return 1
  lsblkfifo="${benchy_path}/lsblk.fifo"; fiofile="${benchy_path}/fio.log"; fiores="${benchy_path}/fio_res.log"
  test -p "$lsblkfifo" || mkfifo -m 600 "$lsblkfifo"
  contain_home=$(df $HOME | awk 'NR==2{ print $NF }') # Check which partition contain $HOME directory
  print_space 1
  {
    if [ -f $disk_tmp ]; then
      cat $disk_tmp
    else
      df -k $HOME 2>/dev/null | awk 'NR>1{ printf("%s\t%s\t%s\n", $1, $2, $NF) }'
    fi
  } > "$lsblkfifo" &
while read -r devname devsize devmp; do
  devtype=$(mount | awk -v mp="$devname" '$1 ~ mp { print $5; exit }')
  if [ "$(echo "$disklimit > $devsize" | $bc)" -eq 1 ]; then
    printf "${cyan}%s${creset}\n" "Insufficient storage on $devname" | parse_output
    continue
  fi
  if [ "$devmp" = "$contain_home" ]; then mountpoint=$benchy_path; else mountpoint=$devmp; fi
  if [ ! -w "$mountpoint" ]; then
    printf "${cyan}%s${creset}\n" "No write permission to $mountpoint, skipping disk" | parse_output
    continue
  fi
  # Run fio on each block size
  for bs in 4k 64k 512k 1m; do
    # Iterate over each defined block_size from array
    say "Running fio R+W sampling on $bs block size..."
    {
      timeout 40 \
      $fio --name=rand_rw_$bs \
      --ioengine=libaio \
      --rw=randrw \
      --rwmixread=50 \
      --bs=$bs \
      --iodepth=64 \
      --numjobs=2 \
      --size=$fio_size \
      --runtime=30 \
      --gtod_reduce=1 \
      --direct=1 \
      --filename=$mountpoint/test.fio \
      --group_reporting \
      --output=$fiofile \
      --minimal
      exitcode="$?"
    } > /dev/null
    if [ "$exitcode" -eq 124 ]; then
      printf "%s\n" "1|Timeout|Reached|Retry|Your|Disk|Bench" >> "$fiores" && overline && continue
    elif [ "$exitcode" -ne 0 ]; then
      printf "%s\n" "1|Failed|To|Bench|Disk|Please|Retry" >> "$fiores" && overline && continue
    fi

    fio_iops_read=$(cut -d';' -f8 < "$fiofile")
    fio_iops_write=$(cut -d';' -f49 < "$fiofile")
    fio_iops=$(printf "%.1fk" "$(echo "scale=2 ; ($fio_iops_read + $fio_iops_write) / 1000" | $bc)")
    fio_iops_read=$(printf "%.1fk" "$(echo "scale=2 ; $fio_iops_read/ 1000" | $bc)")
    fio_iops_write=$(printf "%.1fk" "$(echo "scale=2 ; $fio_iops_write/ 1000" | $bc)")

    fio_test_read=$(cut -d';' -f7 < "$fiofile")
    fio_test_write=$(cut -d';' -f48 < "$fiofile")
    fio_test=$(format_disk "$(echo "($fio_test_read + $fio_test_write)" | $bc)")
    fio_test_read=$(format_disk $fio_test_read)
    fio_test_write=$(format_disk $fio_test_write)

    printf "%s\n" "$bs|$fio_test_read|$fio_test_write|$fio_test|$fio_iops_read|$fio_iops_write|$fio_iops" >> "$fiores"
    truncate -s 0 "$fiofile"
    overline
  done
  # Build fio output
  [ -n "$arg_json" ] && { $jq --arg dvn $devname '.disk_bench[$dvn] = {}' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson" ; }
  {
    printf "${cbwhite}Disk Performance Check (${cbgreen}$devtype${cbwhite} on ${cbyellw}$devname${cbwhite}) ${cbsky}(R: Read, W: Write, T: Total)${creset}\n"
    printf "${cbwhite}+%75s+\n" | tr ' ' '-'
    printf "${cbwhite}|${cblgreen} %-3s | %-11s | %-11s | %-11s | %18s ${cbwhite}%7s\n" "Size" "Read" "Write" "Total" "IOPS (R,W,T)" "|"
    printf "${cbwhite}+%75s+\n" | tr ' ' '='
    while IFS='|' read -r blocksize read write total read_iops write_iops total_iops; do
      # Loop over variable
      printf "${cbwhite}| ${cyellw}%-4s | %-11s | %-11s | %-11s | %-6s | %-6s | %-6s ${cbwhite}|${creset}\n" "$blocksize" "$read" "$write" "$total" "$read_iops" "$write_iops" "$total_iops"
      if [ -n "$arg_json" ]; then
        cat <<DISKJSON | $jq --arg dn "$devname" --argjson dj "$(cat)" '.disk_bench[$dn] += $dj' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson"
        {
          "${blocksize}_bs": {
            "read": "$read",
            "write": "$write",
            "total": "$total",
            "read_iops": "$read_iops",
            "write_iops": "$write_iops",
            "total_iops": "$total_iops"
          }
        }
DISKJSON
      fi
    done < "$fiores"
    printf "${cbwhite}+%75s+${creset}\n" | tr ' ' '-'
    > $fiores
    rm -f -- $mountpoint/test.fio
  } | parse_output
done < "$lsblkfifo"
rm -f "$lsblkfifo" "$fiores" "$fiofile" "$disk_tmp"
}

netlist() {
  [ -z "$continent" ] && continent=$(cat $continent_file)
  if [ -z "$arg_prefer_speedtest" ]; then
    mixedipv4=$(cat << 'EOF'
Airstream|Wisconsin, US|5201-5205|iperf.airstreamcomm.net|iperf.airstreamcomm.net
Uztelecom|Tashkent, UZ|5200-5207|speedtest.uztelecom.uz|speedtest.uztelecom.uz
Novogara|Amsterdam, NL|5200-5209|speedtest.ams1.novogara.net|speedtest.ams1.novogara.net
FiberBy|Copenhagen, DK|9201-9240|speed.fiberby.dk|speed.fiberby.dk
EOF
    )
    mixedipv6=$mixedipv4
    case "$continent" in
      "Asia")
      ipv4_provider=$(cat << 'EOF'
Uztelecom|Tashkent, UZ|5200-5209|speedtest.uztelecom.uz|speedtest.uztelecom.uz
Biznet|Jakarta, ID|5201-5203|iperf.biznetnetworks.com|iperf.biznetnetworks.com
EOF
      )
      ipv6_provider=$ipv4_provider
      ;;
      "Africa")
      ipv4_provider=$mixedipv4
      ipv6_provider=$mixedipv6
      ;;
      "North America")
      ipv4_provider=$(cat << 'EOF'
Airstream|Wisconsin, US|5201-5205|iperf.airstreamcomm.net|iperf.airstreamcomm.net
Clouvider|Dallas, US|5200-5209|dal.speedtest.clouvider.net|dal.speedtest.clouvider.net
Clouvider|Phoenix, US|5200-5209|phx.speedtest.clouvider.net|phx.speedtest.clouvider.net
Clouvider|Los Angeles, US|5200-5209|la.speedtest.clouvider.net|la.speedtest.clouvider.net
EOF
      )
      ipv6_provider=$ipv4_provider
      ;;
      "South America")
      ipv4_provider=$(cat << 'EOF'
Iveloz|Sao Paulo, BR|5201-5209|speedtest.iveloz.net.br|speedtest.iveloz.net.br
EOF
      )
      ipv6_provider=$ipv4_provider
      ;;
      "Europe")
      ipv4_provider=$(cat << 'EOF'
FiberBy|Copenhagen, DK|9201-9240|speed.fiberby.dk|speed.fiberby.dk
WOBCOM|Wolfsburg, DE|5201-5201|a400.speedtest.wobcom.de|a400.speedtest.wobcom.de
Novogara|Amsterdam, NL|5200-5209|speedtest.ams1.novogara.net|speedtest.ams1.novogara.net
Sasag|Schaff, CH|5200-5209|speedtest.shinternet.ch|speedtest.shinternet.ch
Alwyzon|Vienna, AT|5201-5202|lg.vie.alwyzon.net|lg.vie.alwyzon.net
EOF
      )
      ipv6_provider=$ipv4_provider
      ;;
      "Oceania")
      ipv4_provider=$mixedipv4
      ipv6_provider=$mixedipv6
      ;;
      "Mixed")
      ipv4_provider=$mixedipv4
      ipv6_provider=$mixedipv6
      ;;
    esac
  else
    case "$continent" in
      "Asia")
      spt_provider=$(cat << 'EOF'
Biznet|Jakarta, ID|speedtest.biznetnetworks.com
U Mobile|Kuala Lumpur, MY|speedtest.u.com.my
MyRepublic|Singapore, SG|speedtest.myrepublic.com.sg
CAT TELECOM|Hatyai, TH|hatyai.catspeedtest.net
Airtel|Chennai, IN|speedtestchn.airtelbroadband.in
EOF
      );;
      "Africa")
      spt_provider=$(cat << 'EOF'
PCN|Cape Town, ZA|speedtest.pcn.co.za
Vodacom|Durban, ZA|speedtest.dne.vodacombusiness.co.za
Sonatel|Dakar, SN|mondebit1.orange.sn
Maroc|Rabat, MA|speedtest.iam.ma
MTN|Brazzaville, CG|speedtest.mtncongo.net
EOF
      );;
      "Europe")
      spt_provider=$(cat << 'EOF'
TestDebit|Marseille, FR|marseille.testdebit.info
Vancis|Amsterdam, NL|speedtest.vanciscloud.nl
Vox|London, GB|speedtest-ldn.voxtelecom.co.za
Skynet|Warsaw, PL|speedtest.skynet.net.pl
Vodafone|Milan, IT|speedtest.vodafone.it
EOF
      );;
      "North America")
      spt_provider=$(cat << 'EOF'
Comcast|Houston, US|stosat-nash-01.sys.comcast.net
Spectrum|New York, US|speedtest.nyc.rr.com
Telus|Edmonton, CA|edmonton.speedtest.telus.com
Airstream|Wisconsin, US|speedtest.airstreamcomm.net
Hivelocity|Dallas, US|speedtest.dal.hivelocity.net
EOF
        );;
        "South America")
        spt_provider=$(cat << 'EOF'
Claro|Montevidio, UY|speedtest.claro.com.uy
TLINK|Santiago, CL|speedtest.tlink.cl
MEGANET|Barretos, BR|speedtest.meganet.com.vc
Express|Rosario, AR|speedtest.express.com.ar
RCTELECOM|Sao Paulo, BR|speedtest.rctelecomnet.com.br
EOF
        );;
        "Oceania")
        spt_provider=$(cat << 'EOF'
Vocus|Perth, AU|speedtest-pth.vocus.net
Telstra|Sydney, AU|syd1.speedtest.telstra.net
MyRepublic|Auckland, NZ|speedtest.myrepublic.co.nz
Lightwire|Hamilton, NZ|speedtest.lightwire.co.nz
Telstra|Chatswood, AU|cha1.speedtest.telstra.net
EOF
        );;
        "Mixed")
        spt_provider=$(cat << 'EOF'
Biznet|Jakarta, ID|speedtest.biznetnetworks.com
Claro|Montevidio, UY|speedtest.claro.com.uy
Vox|London, GB|speedtest-ldn.voxtelecom.co.za
Lightwire|Hamilton, NZ|speedtest.lightwire.co.nz
Airstream|Wisconsin, US|speedtest.airstreamcomm.net
EOF
        );;
    esac
  fi
}
cshuf() {
  dasnumber="$1"
  if [ -n "$is_bsd" ]; then
    jot -w %i -r 1 "${dasnumber%-*}" "$((${dasnumber#*-}+1))"
  else
    shuf -i "$dasnumber" -n 1
  fi
}
runiperf() {
  # Define argument
  run_url="$1"
  run_port="$2"
  run_host="$3"
  run_flags="$4"

  # Send test 5 times
  sn=1
  while [ $sn -le 5 ]; do
    say "Performing iperf3 send test to $run_host (Attempt #$sn of 5)"
    vport=$(cshuf $run_port)
    iperf_sendlog=$(timeout 15 $iperf $run_flags -c $run_url -p $vport -P 8 --format k 2>/dev/null | awk '/SUM/ && /sender/{ print $6 }')
    if [ "$?" -eq 0 ]; then sleep 1 && overline && break; else sleep 3 && overline; fi
    sn=$(( sn + 1 ))
  done
  # Receive test 5 times
  rn=1
  while [ $rn -le 5 ]; do
    say "Performing iperf3 receive test to $run_host (Attempt #$rn of 5)"
    vport=$(cshuf $run_port)
    iperf_reclog=$(timeout 15 $iperf $run_flags -c $run_url -p $vport -P 8 --format k -R 2>/dev/null | awk '/SUM/ && /sender/{ print $6 }')
    if [ "$?" -eq 0 ]; then sleep 1 && overline && break; else sleep 3 && overline; fi
    rn=$(( rn + 1 ))
  done
}

net_header() {
  [ "$arg_skip_network" = "true" ] && return 1
  print_space 1
  netlist
  {
    if [ -z "$arg_prefer_speedtest" ]; then
      printf "${cbwhite}Network Performance Test (Region: ${cbyellw}$continent)\n"
      printf "${cbwhite}+%81s+\n" | tr ' ' '-'
      printf "${cbwhite}| ${cblgreen}%-5s | %-11s | %-15s | %-12s | %-12s | %-9s ${cbwhite}|\n" "Prot." "Provider" "Location" "Send" "Receive" "Latency"
      printf "${cbwhite}+%81s+${creset}\n" | tr ' ' '-'
    else
      printf "${cbwhite}Ookla Network Speedtest (Region: ${cbyellw}$continent)\n"
      printf "${cbwhite}+%87s+\n" | tr ' ' '-'
      printf "${cbwhite}| ${cblgreen}%-11s | %-17s | %-12s | %-12s | %-9s | %-9s ${cbwhite}|\n" "Provider" "Location" "Download" "Upload" "Data Used" "Latency"
      printf "${cbwhite}+%87s+${creset}\n" | tr ' ' '-'
    fi
  } | parse_output
}

parse_iperf() {
  # Internet Protocol Version 4 (IPv4) test
  if [ "$ipv4_status" = "true" ]; then
    iperf_flags="-4"
    prot="IPv4"
    echo "$ipv4_provider" |
    {
      while IFS='|' read -r provider loc port url pingable; do
        runiperf $url $port $provider $iperf_flags
        # Latency test
        say "Performing latency test to $provider (avg of 5)"
	      latency=$(timeout 10 ping -qc5 $pingable 2>&1 | awk -F/ '/^(rtt|round-trip)/ { printf "%.1f", $5 } END{ if(!NR) print "busy" }')
        overline
        # End latency test
        awkres=$(awk -v white="$cbwhite" -v yellow="$clyl" -v prov="$provider" -v loc="$loc" -v send="$iperf_sendlog" -v rec="$iperf_reclog" -v prot="$prot" -v lat="$latency" 'function hum(x,   v,p) { split( "Kb/s Mb/s Gb/s Tb/s", v, " "); if(!(x=="" || index(x, "0.00"))) {if (x) p=int(log(x)/log(1000)); else p == 0; return sprintf("%6.1f %1.5s" , x/1000^p, v[p+1] );} else{ return sprintf("%11.5s", "busy") } }
        BEGIN { printf("%s| %s%-5s | %-11s | %-15s | %-12s | %-12s | %6.1f %-1.16s %s|\n", white, yellow, prot, prov, loc, hum(send), hum(rec), lat, "ms", white) }' | parse_output | tee /dev/tty)
        if [ -n "$arg_json" ]; then
          $jq '.network_bench |= {"test_method": "iperf3"} + .' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson"
          awkres=$(printf "%s" "$awkres" | if [ "$docolor" = "true" ]; then anstripper; else cat; fi | sed -e 's/[[:space:]]*|[[:space:]]*/|/g')
          awkres="${awkres#?}"; awkres="${awkres%?}"
          IFS='|' read -r proto provid loc iperf_sendlog iperf_reclog latency <<EOF
          $awkres
EOF
          cat << PVFJ | $jq --argjson kj "$(cat)" '.network_bench.net_ipv4 += $kj' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson"
          {
            "$provid": {
              "location": "$loc",
              "send_speed": "$iperf_sendlog",
              "rec_speed": "$iperf_reclog",
              "latency": "$latency"
            }
          }
PVFJ
        fi
        unset send_speed rec_speed prot awkres
      done
    }
    printf "${cbgreen}+${cbwhite}%81s${cbgreen}+\n" | tr ' ' '-' | parse_output
  fi
  # Internet Protocol Version 6 (IPv6) test
  if [ "$ipv6_status" = "true" ]; then
    iperf_flags="-6"
    prot="IPv6"
    echo "$ipv6_provider" |
    {
      while IFS='|' read -r provider loc port url pingable; do
        runiperf $url $port $provider $iperf_flags
        # Latency test
        say "Performing latency test to $provider (avg of 5)"
        latency=$(timeout 10 ping6 -qc5 $pingable 2>&1 | awk -F/ '/^(rtt|round-trip)/ { printf "%.1f", $5 } END{ if(!NR) print "busy" }')
        overline
        # End latency test
        awkres=$(awk -v white="$cbwhite" -v yellow="$clyl" -v prov="$provider" -v loc="$loc" -v send="$iperf_sendlog" -v rec="$iperf_reclog" -v prot="$prot" -v lat="$latency" 'function hum(x,   v,p) { split( "Kb/s Mb/s Gb/s Tb/s", v, " "); if(!(x=="" || index(x, "0.00"))) {if (x) p=int(log(x)/log(1000)); else p == 0; return sprintf("%6.1f %1.5s" , x/1000^p, v[p+1] );} else{ return sprintf("%11.5s", "busy") } }
        BEGIN { printf("%s| %s%-5s | %-11s | %-15s | %-12s | %-12s | %6.1f %-1.16s %s|\n", white, yellow, prot, prov, loc, hum(send), hum(rec), lat, "ms", white) }' | parse_output | tee /dev/tty)
        if [ -n "$arg_json" ]; then
          $jq '.network_bench |= {"test_method": "iperf3"} + .' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson"
          awkres=$(printf "%s" "$awkres" | if [ "$docolor" = "true" ]; then anstripper; else cat; fi | sed -e 's/[[:space:]]*|[[:space:]]*/|/g')
          awkres="${awkres#?}"; awkres="${awkres%?}"
          IFS='|' read -r proto provid loc iperf_sendlog iperf_reclog latency <<EOF
          $awkres
EOF
          cat << PVSJ | $jq --argjson xj "$(cat)" '.network_bench.net_ipv6 += $xj' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson"
          {
            "$provid": {
              "location": "$loc",
              "send_speed": "$iperf_sendlog",
              "rec_speed": "$iperf_reclog",
              "latency": "$latency"
            }
          }
PVSJ
        fi
        unset send_speed rec_speed prot awkres
      done
    }
    printf "${cbgreen}+${cbwhite}%81s${cbgreen}+\n" | tr ' ' '-' | parse_output
  fi
}
parse_speedtest() {
  sptfifo="${benchy_path}/speedtest.fifo"; spt_res="${benchy_path}/speedtest.temp"
  [ -p "$sptfifo" ] || mkfifo -m 600 "$sptfifo"
  echo "$spt_provider" |
  {
    while IFS='|' read -r provider loc url; do
      say "Performing Ookla Speedtest to $provider"
      ( sed ':a;s/^\(\([^"]*,\?\|"[^",]*",\?\)*"[^",]*\),/\1 /;ta' < $sptfifo | tee $spt_res >/dev/null & )
      $speedtest --accept-gdpr --accept-license --progress=no --host $url --format=csv > $sptfifo 2>/dev/null
      sptval=$?
      overline
      if [ "$sptval" -ne 0 ]; then
        download="Failed"; upload="To"; data="Get"; latency="Data"; speedtestlink="NaN"
        printf "| %-11s | %-17s | %-12s | %-12s | %-9s | %-9s |\n" "$provider" "$loc" "$download" "$upload" "$data" "$latency"
      else
        sptres=$(cat "$spt_res" | awk -v white="$cbwhite" -v yellow="$clyl" -v prov="$provider" -v loc="$loc" -F, 'BEGIN { FS="," }; function hum(x,   v,p) { split( "b/s Kb/s Mb/s Gb/s Tb/s", v, " "); x*=8; p=int(log(x)/log(1000)); return sprintf("%6.1f %1.5s" , (x ? x/1000^p : 0), v[p+1] ); } { gsub(/\042/, ""); printf "%s| %s%-11s | %-17s | %-12s | %-12s | %6.1f %1.5s | %6.1f %-1.16s %s|\n", white, yellow, prov, loc, hum($6), hum($7), ($8+$9)/(1000^3), "GB", $3, "ms", white }' | parse_output | tee /dev/tty)
        if [ -n "$arg_json" ]; then
          sptres=$(printf "%s" "$sptres" | if [ "$docolor" = "true" ]; then anstripper; else cat; fi | sed -e 's/[[:space:]]*|[[:space:]]*/|/g')
          sptres="${sptres#?}"; sptres="${sptres%?}"; speedtestlink=$(cat "$spt_res" | awk -F',' '{ gsub(/\042/, ""); print $10 }')
          IFS='|' read -r prov loc download upload data latency <<SPTJSON
          $sptres
SPTJSON
        fi
      fi
      if [ -n "$arg_json" ]; then
        cat <<SPTJSON | $jq --argjson spj "$(cat)" '.network_bench += $spj' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson"
        {
        	"test_method": "speedtest",
        	"$provider": {
        		"url": "$url",
        		"location": "$loc",
            "download": "$download",
        		"upload": "$upload",
        		"data_used": "$data",
        		"latency": "$latency",
            "speedlink": "${speedtestlink:-NaN}"
        	}
        }
SPTJSON
      fi
    done
  }
  printf "+%87s+\n" | tr ' ' '-' | parse_output
  rm -f $sptfifo $spt_res
}
geekbench_test() {
  # Skip geekbench on input argument
  [ "$arg_skip_gb" = "true" ] && return 1
  # Skip geekbench on *BSD machine
  [ -n "$is_bsd" ] && die "Geekbench doesn't support *BSD, exiting test.." && return 1
  # Exit if ipv6 only
  [ "$ipv4_status" = "false" ] && die "Geekbench doesn't work over ipv6, exiting test.." && return 1
  # Undo geekbench 6 if ram less than 1 GB
  { [ "$gb_version" = 11 ] || [ "$gb_version" = 6 ]; } && [ "$(echo "$mem_info_num < 1" | $bc)" -eq 1 ] && \
  die "Geekbench 6 does not work with ram less then 1 GB, switching to Geekbench 5..." && \
  { gb_version=5; gb_ddl_link="$gb5_link"; unset arg_use_gb56; }
  # Check if machine was musl library
  if ldd "$(command -v ls)" | grep -q 'musl'; then die "Geekbench does not support musl library, exiting test.." && return 1; fi
  print_space 1
  dl_geekbench() {
    _gbv="$1"; geekbench_path="${benchy_path}/gb${_gbv}"; mkdir -p "$geekbench_path"; gb_var=div
    if [ ! -f "$geekbench_path/geekbench${_gbv}" ]; then
      printf "${cyan}%s${creset}\n" "Downloading Geekbench ${_gbv}, this may take a several minute..."
      file_grabber $gb_ddl_link | tar xzf - --strip-components=1 -C $geekbench_path \
      && printf "\r%s" "$(tput cuu 2; tput ed)"
    fi
    # Perform geekbench N test
    say "Initializing geekbench ${_gbv} test..."
    gb_output=$($geekbench_path/geekbench${_gbv} --upload 2>/dev/null | grep -m 1 "https://browser")
    gb_output="${gb_output#"${gb_output%%[![:space:]]*}"}" # Remove whitespace
    gb_output="${gb_output%"${gb_output##*[![:space:]]}"}" # Remove whitespace
    eval gb_output_${_gbv}="\"$gb_output\""

    # Grab geekbench score
    gbfile="$benchy_path/temp_gb${_gbv}.log"
    file_grabber $gb_output $gbfile
    gb_st=$(gb_string "$gbfile")
    gb_wcore=$(awk -F "<${gb_var}[^>]*>(<d>)?|(</?d>)?</${gb_var}>" '$2~/[0-9]/{print $2}' "$gbfile")
    gb_score=$(printf "$gb_wcore" | awk 'FNR==1')
    gb_mcore=$(printf "$gb_wcore" | awk 'FNR==2')
    eval "gb_single_core_${_gbv}=\"${gb_score}\""
    eval "gb_multi_core_${_gbv}=\"${gb_mcore}\""
    eval "gb_string_${_gbv}=\"${gb_st}\""
    overline
  }
  if [ "$gb_version" -eq 11 ]; then
    for gbv in 5 6; do
      eval "gb_ddl_link=\$gb${gbv}_link"; dl_geekbench $gbv
    done
  else
    [ "$gb_version" -eq 4 ] && gb_var=span
    dl_geekbench $gb_version
  fi
  {
    # Parsing result
    totaltime=$(($(awk 'BEGIN{srand();print srand()}')-startTime))
    totalmin=$(echo "($totaltime % 3600) / 60" | $bc)
    totalsec=$(echo "$totaltime % 60" | $bc)
    if [ -n "$arg_use_gb56" ]; then
      printf "${cbwhite}+%47s+%47s+\n" | tr ' ' '-'
      printf "${cbwhite}| ${cbblue}%-45s | %-45s ${cbwhite}|\n" "$gb_string_6" "$gb_string_5"
      printf "${cbwhite}+%47s+%47s+\n" | tr ' ' '='
      printf "${cbwhite}| ${cblsky}%-18s ${cbwhite}| ${cblgreen}%-24s ${cbwhite}| ${cblsky}%-18s ${cbwhite}| ${cblgreen}%-24s ${cbwhite}|\n" "Single Core" "$gb_single_core_6" "Single Core" "$gb_single_core_5"
      printf "${cbwhite}| ${cblsky}%-18s ${cbwhite}| ${cblgreen}%-24s ${cbwhite}| ${cblsky}%-18s ${cbwhite}| ${cblgreen}%-24s ${cbwhite}|\n" "Multi Core" "$gb_multi_core_6" "Multi Core" "$gb_multi_core_5"
      printf "${cbwhite}+%47s+%47s+\n" | tr ' ' '-'
      printf "${cbwhite}| ${cblgreen}%-45s ${cbwhite}| ${cblgreen}%-45s ${cbwhite}|\n" "$gb_output_6" "$gb_output_5"
      printf "${cbwhite}+%47s+%47s+\n" | tr ' ' '-'
      printf "${cbwhite}| ${cblsky}%-45s ${cbwhite}| ${cblgreen}%-45s ${cbwhite}|\n" "Benchy time spent" "$totalmin Minutes $totalsec Seconds"
      printf "${cbwhite}+%47s+%47s+${creset}\n" | tr ' ' '-'
      if [ -n "$arg_json" ]; then
        cat <<GBJSON | $jq --argjson gj "$(cat)" '.geekbench_test += $gj' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson"
        {
          "geekbench6": {
            "gb_version": "$gb_string_6",
            "single_core": "$gb_single_core_6",
            "multi_core": "$gb_multi_core_6",
            "gb_link": "$gb_output_6"
          },
          "geekbench5": {
            "gb_version": "$gb_string_5",
            "single_core": "$gb_single_core_5",
            "multi_core": "$gb_multi_core_5",
            "gb_link": "$gb_output_5"
          }
        }
GBJSON
      fi
    else
      printf "${cbwhite}+%47s+\n" | tr ' ' '-'
      printf "${cbwhite}| ${cbwhite}%-45s |\n" "$gb_st"
      printf "${cbwhite}+%47s+\n" | tr ' ' '='
      printf "${cbwhite}| ${cblsky}%-18s ${cbwhite}| ${cblgreen}%-24s ${cbwhite}|\n" "Single Core" "$gb_score"
      printf "${cbwhite}| ${cblsky}%-18s ${cbwhite}| ${cblgreen}%-24s ${cbwhite}|\n" "Multi Core" "$gb_mcore"
      printf "${cbwhite}+%47s+\n" | tr ' ' '-'
      printf "${cbwhite}| ${cblgreen}%-45s ${cbwhite}|\n" "$gb_output"
      printf "${cbwhite}+%47s+\n" | tr ' ' '-'
      printf "${cbwhite}| ${cblsky}%-18s ${cbwhite}| ${cblgreen}%-24s ${cbwhite}|\n" "Benchy time spent" "$totalmin Minutes $totalsec Seconds"
      printf "${cbwhite}+%47s+${creset}\n" | tr ' ' '-'
      if [ -n "$arg_json" ]; then
        cat <<GBJSON | $jq --argjson gj "$(cat)" '.geekbench_test += $gj' "$mainjson" > /tmp/main.json && mv /tmp/main.json "$mainjson"
        {
          "geekbench${gb_version}": {
            "gb_version": "$gb_st",
            "single_core": "$gb_score",
            "multi_core": "$gb_mcore",
            "gb_link": "$gb_output"
          }
        }
GBJSON
      fi
    fi
      rm -f "$gbfile" "$gbfile_4" "$gbfile_5"
  } | parse_output
}

main() {
  core_pkg
  tput civis
  colordefiner
  header_intro
  user_arch
  binarycheck
  opening_json
  diskmeminfo; sysinfo | parse_output
  disk_test
  if net_header; then
    [ -n "$arg_prefer_speedtest" ] && parse_speedtest || parse_iperf
  fi
  geekbench_test; closing_json
  anstripper_ng; send_output
  case "$arg_colorize" in
    force|false) mv $outputdir/benchy_c.log $outputdir/benchy.log 2>/dev/null;;
    *) rm -f $outputdir/benchy_c.log;;
  esac
  [ -z "$arg_keep_file" ] && rm -fr -- "$benchy_path"
}
main