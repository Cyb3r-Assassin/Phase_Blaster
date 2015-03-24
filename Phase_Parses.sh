#!/bin/bash
for i in nmap/all_hosts/*
  do
    [ -f $i ] && host=$(grep [0-9]/ $i | grep open)
    [[ -n $host ]] && echo -e "$i\n$host\n"
done
