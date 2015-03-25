##Phase_Blaster
####Managed reconnaissance scanning for professional pentesters
=============

**About**

Phase_Blaster takes ip CID blocks, host names, and or IP's from a file and performs large scale host discovery and follows through with available hosts aggressive scans while avoiding any IP's clients deem out of scope via an exclude file. Then produces xml output for Metasploit DB integration. All results are placed in a managed hierarchical directory tree. Note you must adjust line 32 to use your systems user name.

Such like:

application_dir/

application_dir/nmap

application_dir/nmap/host_cid

application_dir/nmap/host_cid/ip "one file per ip"

application_dir/nmap/host_cid/msf/host.xml

Or with ping sweep enumerations and resumable port scans. This option includes an all_hosts file that can be imported for Nessus.

application_dir/

application_dir/nmap/all_hosts/

application_dir/nmap/all_hosts/msf/host.xml

**USEAGE:**
Create 2 files in the same directory you have Phase_blaster.sh residing in, one named "ips" the other "exclude". Place all of your ip ranges separated via line breaks into the ips file. 
Any ip's you need excluded from the scans in the exclude file in the same manner.

**call phase_blaster as follows**

>sudo ./Phase_Blaster.sh -f

**Phase_blaster also allows individual ip entries at any point and adds them into the directory structure and produces a new msf ready xml file.**

if you need to run just one new entry do so as

>sudo ./Phase_Blaster.sh 0.0.0.0/24

or

>sudo ./Phase_Blaster.sh 0.0.0.0

Alternative modes -d will perform just a host discovery.Very useful for importing results into Nessus scans. User may go back at any time and perform a -ff which will perform an nmap aggressive scan against the discovered hosts file.
My favourite option is the -df which perform a discovery and then follow up with an nmap aggressive scan while delivery a progress output.

**About**
Converting a class B range CID and converts it into class C and dumps the output into the folder ips for Phase_Blaster. This allows nmap to scan a broke down block of class B it could not previously handle in a systematic manner.

**call phase_blaster as follows**

>./Phase_Blaster.sh -bc 127.0.

**Output**
The results would look like

127.0.0.0

127.0.0.1

127.0.0.2.....

127.0.1.0

127.0.1.1

127.0.1.2.....

until

127.0.255.255

For middle recon work use Phase_Parse.sh and whois_around.sh. Phase_Parse will give you a breakout of hosts with open ports only and a brief list of just the open ports. whois_around will do a quick nbtscan of the discovered
hosts and provide a host name breakdown for all NetBios host name, ip, and MAC addressed of all the system in the ips folders range.
I suggest the command

>./Phase_Blaster.sh -bc 10.10. && ./Phase_blaster.sh -df && ./whois_around.sh && ./Phase_Parse

##You must edit line 22 of Phase_Blaster.sh to use your default user name before running Phase_Blaster


Happy Hacking!