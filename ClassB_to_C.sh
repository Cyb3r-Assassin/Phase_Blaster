#!/bin/bash
START=0
END=255
for (( i=$START; i <= $END ; i++)); do
  if [[ $(expr length $i) -lt 255 ]]; then
    echo "${1}${i}.0/24" >> ips
  fi
done
exit
