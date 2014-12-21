#!/bin/bash
if [[ $(id -u) != 0 ]]; then # Verify we are root if not exit
   echo "Please Run This Script As Root or With Sudo!" 1>&2
   exit 1
fi

single() #User only wants one host scanned so just give it to them
{
  nmap -sV -T4 -O -F --version-light $ips >> nmap/$ips
}

cid()
{
  ip=${ips:0:-3} #Strip the cid, make dir
  [[ ! -d nmap/$ip ]] && mkdir nmap/$ip nmap/${ip}/msf && echo "Directorys made nmap/$ip & nmap/${ip}/msf"|| echo "output dir already exists. We will be outputing into it, I hope this is ok"
  #Find all live hosts in the CID and place them in a file named hosts
  nmap -sP $ips | grep -i report | awk -F"for" '{ print $2 }' | cut -d' ' -f2 >> nmap/${ip}/hosts
  scanallthethings #Call scanallthethings function to find active services
}

scanallthethings()
{
  while read host
  do
    [[ ! -e exclude ]] && touch exclude #prevent the following line from returning bits if file exclude does not exist
    echo -e "Checking if $host is in the DoNot Disturb list.\n"
    if [[ -z $(grep $host exclude) ]]; then #Is this ip in our range off limits?
      echo "Scanning $host" #ip is safe so scan it
      nmap -A -oA nmap/${ip}/msf/$host $host >> nmap/${ip}/$host #Scan the ip, drop results into file nmap/${ip}/$host and the MSF file into nmap/${ip}/msf/$host
      echo "\n" #Improve readability
      cat nmap/${ip}/$host #here are the goods so that you have a working status quo in the terminal during the progress.
    fi
  done < nmap/${ip}/hosts #Grab the first host from our list of active hosts found during function cid()
}

[[ ! -d nmap ]] && mkdir nmap
if [[ -z $1 || $1 == "--help" || $1 == "-h" || $1 == "" ]]; then
  echo "useage is Command [-f] / [IP] / [CID]"
  echo "To use [file] place all ip ranges to be scanned in a text file named \"ips\" seperated by line breaks"
elif [[ $1 == "-f" ]]; then
  while read ips
  do
    if [[ -z $(echo $ips | grep /) ]]; then 
      single
    else
      cid
    fi
  done < ips
elif [[ -n $1 && $1 != file ]]; then #determin if we are scanning a CID or a Host and not using a file
  if [[ -z $(echo $ips | grep /) ]]; then 
    single
  else
    cid
  fi
fi

echo "\n" #Improve readability
echo "Doing clean up"
for i in nmap/*; do
  if [[ -d $i ]]; then
    [[ -n $(ls $i/msf/*.nmap) ]] && rm nmap/*.nmap
    [[ -n $(ls $i/msf/*.gnmap) ]] && rm nmap/*.gnmap
  fi
done
echo "Setting permissions back to user"
if [[ -d nmap ]]; then
  chown -R hacker:hacker nmap
  for i in nmap/*; do
    if [[ -d $i ]]; then
      echo "now printing results of all hosts alive and dumping them into nmap/Nesses"
      cat $i/hosts > nmap/Nessus
      cat $i/hosts
    fi
  done
fi
exit 0