##Phase_Blaster
####Managed recognize scanning for professional pentesters
=============

**About**

Phase_Blaster takes ip CID blocks, host names, and or IP's from a file and performs large scale host discovery and follows through with available hosts aggressive scans while avoiding any IP's clients deem out of scope via an exclude file. Then produces xml output for Metasploit DB integration. All results are placed in a managed hierarchical directory tree.

Such like:

application_dir\

application_dir\nmap

application_dir\nmap\host_cid

application_dir\nmap\host_cid\host_cid.xml

application_dir\nmap\host_cid\ip "one file per ip"

**USEAGE:**

Create 2 files in the same directory you have Phase_blaster.sh residing in, one named "ips" the other "exclude". Place all of your ip ranges separated via line breaks into the ips file. Any ip's you need excluded from the scans in the exclude file in the same manner.

**call phase_blaster as follows**

sudo ./Phase_Blaster.sh file

**Phase_blaster also allows individual ip entries at any point and adds them into the directory structure and produces a new msf ready xml file.**

if you need to run just one new entry do so as

sudo ./Phase_Blaster.sh 0.0.0.0/24

or

sudo ./Phase_Blaster.sh 0.0.0.0

Happy Hacking!