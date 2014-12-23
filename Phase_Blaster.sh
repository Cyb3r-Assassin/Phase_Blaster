#!/bin/bash

if [[ $(id -u) != 0 ]]; then # Verify we are root if not exit
   echo "Please Run This Script As Root or With Sudo!" 1>&2
   exit 1
fi

trap fixallthethings INT HUP;

fixallthethings()
{
  echo -e "\n" #Improve readability
  echo "Doing clean up"
  for i in nmap/*; do
    if [[ -d $i ]]; then
      [[ -z $(file $i/msf/*.nmap | grep cannot) ]] && rm $i/msf/*.nmap
      [[ -z $(file $i/msf/*.gnmap | grep cannot) ]] && rm $i/msf/*.gnmap
    fi
  done
  echo "Setting permissions back to user"
  if [[ -d nmap ]]; then
    chown -R hacker:hacker nmap
  fi
  exit 0
}

BtoC()
{
  START=0
  END=255
  for (( i=$START; i <= $END ; i++)); do
    if [[ $(expr length $i) -lt 255 ]]; then
      echo "${1}${i}.0/24" >> ips
    fi
  done
}

nessus()
{
  for i in nmap/*; do
    if [[ -d $i ]]; then
      echo -e "\nnow printing results of all hosts alive and dumping them into nmap/Nesses"
      [[ -f $i/hosts ]] && cat $i/hosts >> nmap/Nessus
      cat nmap/Nessus
    fi
  done
}

discovery()
{
  [[ ! -d nmap ]] && mkdir nmap #This isn't needed but I hate seeing warning messages
  [[ ! -d nmap/all_hosts ]] && mkdir nmap/all_hosts
  [[ ! -f nmap/all_hosts/all_hosts ]] && touch nmap/all_hosts/all_hosts
  while read ip
  do
    echo -e "scanning $ip\n"
    nmap -sP $ip | grep -i report | awk -F"for" '{ print $2 }' | cut -d' ' -f2 >> nmap/all_hosts/all_hosts
  done < ips
}

scan()
{
  if [[ -n $(echo $2 | grep /) ]]; then
    ip=${2:0:-3} #Strip the CID from the ip range
  else
    ip=$2
  fi
  #Find all live hosts in the CID and place them in a file named hosts
  if [[ $1 == '-df' ]]; then #We found all the things first. Now scan them
    scanallthethings nmap/all_hosts/all_hosts -A #Call scanallthethings function to find active services.
  elif [[ $1 == '-ff' ]]; then #User ran -d at a prior time and now needs to run a comprehensive nmap scan against the discovered hosts.
    scanallthethings nmap/all_hosts/all_hosts -A
  elif [[ $1 == '-f' ]]; then #Find all the things in the first range, scan it and then move onto the next range because at this point we are inside a loop
    [[ ! -d nmap/$ip ]] && mkdir nmap/$ip nmap/${ip}/msf && echo "Directorys made nmap/$ip & nmap/${ip}/msf" || echo "output dir already exists. We will be outputing into it, I hope this is ok"
    nmap -sP $2 | grep -i report | awk -F"for" '{ print $2 }' | cut -d' ' -f2 >> nmap/${ip}/hosts
    scanallthethings nmap/${ip}/hosts -f #Call scanallthethings function to find active services.
  fi
}

scanallthethings()
{
  if [[ $2 == '-A' ]]; then
    [[ ! -d nmap/all_hosts/msf ]] && [[ ! -d nmap/all_hosts ]] && mkdir nmap/all_hosts || mkdir nmap/all_hosts/msf
  fi

  while read host
  do
    [[ ! -e exclude ]] && touch exclude #prevent the following line from returning bits if file exclude does not exist
    echo -e "\nChecking if $host is in the DoNot Disturb list.\n"
    if [[ -z $(grep $host exclude) ]]; then #Is this ip in our range off limits?
      echo "Scanning $host" #ip is safe so scan it
      if [[ $2 == '-f' ]]; then
        nmap -A -oA nmap/${ip}/msf/$host $host >> nmap/${ip}/$host #Scan the ip, drop results into file nmap/${ip}/$host and the MSF file into nmap/${ip}/msf/$host
        echo -e "\n" #Improve readability
        cat nmap/${ip}/$host #here are the goods so that you have a working status quo in the terminal during the progress.
      elif [[ $2 == '-A' ]]; then
        nmap -A -oA nmap/all_hosts/msf/$host $host >> nmap/all_hosts/$host #Scan the ip, drop results into file nmap/all_hosts and the MSF file into nmap/all_hosts/msf/$host
        echo -e "\n" #Improve readability
        cat nmap/all_hosts/$host #here are the goods so that you have a working status quo in the terminal during the progress.
      fi
    fi
  done < $1 #Grab the first host from our list of active hosts found during function scan()
}

launch()
{
  [[ ! -d nmap ]] && mkdir nmap
  if [[ -z $1 || $1 == "--help" || $1 == "-h" || $1 == "" ]]; then
    echo -e "Useage is Commands [-f -d -ff -df -bc] or [IP] / [CID]\n"
    echo -e "To convert a class B range to a scannable block of C's use option -bc ip (example: ./Phase_Blaster -bc 127.0.)\n"
    echo -e "To scan from a file named ips place all ips, and ip ranges to be scanned in a text file named \"ips\" separated by line breaks (example: ./Phase_Blaster -f)\n"
    echo -e "Command -df performs a complete ping sweep, creates a file of all live hosts and then aggressive scans each of them\nwhile tallying results into individual files by ip's and creates a msf folder with msf importable .xml results.\n\nUsing options -d & -ff are done so by enabling the user the ability of running just a discovery scan with -d and\nthen having the option to go back at a later date and run -ff for a comprehensive scan overview of the -d results.\n\nYou may also call Phase_Blaster with a single IP or CID and have them enumerated at any point in the same method -f worked. \n(example: ./Phase_Blaster 120.0.0.5 or ./Phase_Blaster 120.0.0.0/24)"
  elif [[ $1 == "-bc" ]]; then
    BtoC $2
  elif [[ $1 == "-f" ]]; then
    while read ips
    do
      scan -f $ips
    done < ips
    nessus
  elif [[ $1 == "-d" ]]; then
    discovery
    cat nmap/all_hosts/all_hosts
  elif [[ $1 == "-d-f" || $1 == "-f-d" || $1 == "-df" || $1 == "-fd"  ]]; then
    discovery
    scan -df
  elif [[ $1 == "-ff" ]]; then
    scan -ff
  else #determin if we are scanning a CID or a Host and not using a file
    scan -f $1
  fi
}

launch $1 $2
fixallthethings