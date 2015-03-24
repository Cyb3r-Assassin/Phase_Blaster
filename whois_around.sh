#!/bin/bash
#nbtscan 192.168.2.0/25
while read line; do nbtscan $line; done < ips
#nbtscan $1
