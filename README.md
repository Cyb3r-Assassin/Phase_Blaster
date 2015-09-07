##Phase_Blaster
####Managed reconnaissance scanning for professional pentesters
=============

**About**

Phase_Blaster takes ip CID blocks, Host Names, and or IP's from a file or directly from CLI and performs large scale host discovery and follows through with available hosts aggressive scans while avoiding any IP's clients deem out of scope via an exclude file. Phase_Blaster then produces xml output for Metasploit DB integration. All results are placed in a managed hierarchical directory tree. The all_hosts file can be used for Nessus importing or can be created on the fly with -nessus option. Phase_Blaster can also convert class B ip CID's to an array of class C's for scanning.

Phase_Blaster directory structure looks like.

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
Create 2 files in the same directory you have Phase_blaster residing in, one named "ips" the other "exclude". Place all of your ip ranges separated via line breaks into the ips file. 
Any ip's you need excluded from the scans in the exclude file in the same manner.

**call phase_blaster as follows**

>sudo ./Phase_Blaster.sh -f

**Phase_blaster also allows individual ip entries at any point and adds them into the directory structure and produces a new msf ready xml file.**

if you need to run just one new entry do so as

>sudo ./Phase_Blaster.sh -f/-d 0.0.0.0/24

or

>sudo ./Phase_Blaster -f/-d 0.0.0.0

Alternative modes -d will perform just a host discovery. Very useful for importing results into Nessus scans. User may go back at any time and perform a -ff which will perform a nmap aggressive scan against the discovered hosts file. My favourite option is the -df which perform a discovery and then follow up with an nmap aggressive scan while delivery a progress output.

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

For middle recon work use Phase_blaster -p and Phase_Blaster -nbt. Phase_Blaster -p will give you a breakout of hosts with open ports only and a brief list of just the open ports. Phase_Blaster -nbt will do a quick nbtscan of the discovered hosts and provide a host name breakdown for all NetBios host names, ip, and MAC addressed of all the system in the ips folders range.

I suggest the command

>./Phase_Blaster -bc 10.10. && ./Phase_blaster -df && ./Phase_Blaster -nbt && ./Phase_Blaster -p

##You must edit line 22 of Phase_Blaster to use your default user name before running Phase_Blaster if you do not run as root user


Happy Hacking!