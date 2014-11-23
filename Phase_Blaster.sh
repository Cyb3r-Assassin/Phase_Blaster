#/bin/bash
if [[ $(id -u) != 0 ]]; then # Verify we are root if not exit
   echo "Please Run This Script As Root or With Sudo!" 1>&2
   exit 1
fi

single()
{
  nmap -sV -T4 -O -F --version-light $ips > nmap/$ips
}

cid()
{
  ip=${ips:0:-3}
  [[ ! -d nmap/$ip ]] && mkdir nmap nmap/$ip || echo "output dir already exists. We will be outputing into it, I hope this is ok"
  nmap -sP $ips | grep -i report | awk -F"for" '{ print $2 }' | cut -d' ' -f2 > nmap/${ip}/hosts

  while read host
  do
    [[ ! -e exclude ]] && touch exclude #prevent the following line from returning bits
    if [[ -z $(grep $host exclude) ]]; then #Is this ip in our range off limits?
      nmap -T4 -O -A -v -oA nmap/$ip $host > nmap/${ip}/$host
    fi
  done < nmap/${ip}/hosts
}

if [[ -z $1 || $1 == "--help" || $1 == "-h" ]]; then
  echo "useage is Command [file]/[CID]"
  echo "To use [file] place all ip ranges to be scanned in a text file named \"ips\" seperated by line breaks"
elif [[ $1 == "file" ]]; then
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

[[ -e nmap/*.nmap ]] && rm nmap/*.nmap
[[ -e *.gnmap ]] && rm nmap/*.gnmap
if [[ -d nmap ]]; then
  chown -R hacker:hacker nmap
  for i in nmap/*; do cat $i/hosts; done
fi
exit 0