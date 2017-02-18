# Server-Provisioning
Server provisioning and ansible scripts for AWS Amazon EC2 and DigitalOcean- Droplet creation

# DevOps_HW1A

For HW1A, I will be creating 2 instances- 
1.  Digital Ocean
2.  Amazon EC2

## Screencast & Steps

>   Step 1 : I got AWS and DigitalOcean credentials

>   Step 2 : I arranged my files and created 3 sh files to run

>   Step 3 : bash InstallDependencies.sh : This will install required dependencies for provisioning servers 
 
Run as 

```
bash InstallDependencies.sh
```

This file will contain code as follows 

```
runas apt-get update
runas apt-get install nodejs
runas apt-get install make vim python-dev python-pip
runas pip install paramiko PyYAML Jinja2 httplib2 six
runas make install
```

>   Step 4 :bash Modules.sh : This will install npm into DigitalOcean and aws folder.

Run as 

```
bash Modules.sh
```

This file will contain code as follows 

```
#!/bin/bash

cd ./digitalocean
npm install --save

cd ../aws
npm install --save
```


>   Step 5 : Save tokens and keys as environment variables in Digitalocean_TOKEN, AWS_ACCESS_KEY and AWS_SECRET

>   Step 6 : Run ServersProvisioning.sh 
Run as 

```
bash ServerProvisioning.sh
```

This file will contain code as follows 

```
#! /bin/bash
node digitalocean/CreateDroplet.js
node aws/CreateInstance.js
```
This will run these js files and create droplet and amazon EC2 instance.
I have printed ipaddress by console.logging it.

## Code for provisioning from two platforms

1. DigiralOcean : 
    https://github.ncsu.edu/ppfirake/DevOps_HW1A/blob/master/digitalocean/CreateDroplet.js

2. Amazon EC2 : 
    https://github.ncsu.edu/ppfirake/DevOps_HW1A/blob/master/aws/CreateInstance.js

## Configuration management of repo
  
  This involves configuring npm modules etc. This is done through 
  1. InstallDependencies.sh link - https://github.ncsu.edu/ppfirake/DevOps_HW1A/blob/master/InstallDependencies.sh
  2. Modules.sh link - https://github.ncsu.edu/ppfirake/DevOps_HW1A/blob/master/ModulesInstall.sh
  
## Screencast and following instructions

Please find link for screencast : https://drive.google.com/open?id=0ByU5VmgdDMI2WDREYnc1aDVfSWM

## Concepts

### 1.	Define idempotency. Give two examples of an idempotent operation and non-idempotent operation.

Idempotency means denoting an element of a set that is unchanged in value when multiplied or otherwise operated on by itself. Idempotence in DevOps or computer field is simply a word that explains an operation that will have the same effect whether you run it once or 100 times. So the system status remains with same effect irrespective of number of times it is executed. One conceptualization can be when we add one, we increment every time but when we multiply by one, we keep the same number. There are several definitions of idempotency but basis of consideration is same. OpsCode has defined idempotency as a script that can run multiple times on the same system and the results will always be identical, however Ansible defines it as scripts that will seek to avoid changes to the system unless a change needs to be made. Both definition has common grounds with no system change. They differ just in attitude to look at such state.	

Idempotent example: 

1.	One great example of idempotent code can be thought of puppet. The each time agent runs, it has same set of instructions logged in a catalog. These instruction or code tells Puppet about the state it should manage/keep e.g. state present denotes that puppet should keep that particular application/tool present in the environment. Let’s say:

```
package { [ putty', 'notepadplusplus']:
    ensure   => present,
    provider => 'chocolatey',
}
``` 

 This might have implications such as if that tool/application (here putty and notepadplus) is not present then it must be installed and if it is already installed then check whether it is installed well. Here the final state of environment will be putty and notepadplus installed and running well.

2.	Go programming language performs as idempotent as the final status after execution is same as before the execution if excecuting multiple times.

3. Ansible 
```
# ansible playbook that adds ssh fingerprints to known_hosts
- hosts: all
 connection: local
 gather_facts: no
 tasks:
 - command: /usr/bin/ssh-keyscan -H {{ ansible_host }}
 register: keyscan
 - lineinfile: name=~/.ssh/known_hosts create=yes line={{ item }}
 with_items: '{{ keyscan.stdout_lines }}'
```

Non-idempotent example: 

1.	Non-Idempotent Bash

```
echo "127.0.0.1 localhost" >> /etc/hosts
```

this code will append ‘/etc/hosts’ entry over and over again. So this would be chain of such entries as much times we run the script. Definitely this will cause problem as the file will grow every time and it would be very space consuming. In devOps environment we might have to run some file every hour/minute. So this would cause serious memory issues. 

```
ssh-keyscan -H >> ~/.ssh/known_hosts
```
2. this is non idempotent example as it would add up the effects and for prolonged recursive execution it is problematic.
Here we can achieve idempotency in this code by simply modifying it with IF condition. We can simple write /etc/hosts only if it is not present already. So this will make sure of idempotency. 
```
if (!grep -q 127.0.0.1 /etc/hosts); then echo "127.0.0.1 localhost" >> /etc/hosts; fi
```

### 2. Describe several issues related to management of your inventory.

Inventory consist of Servers and IP addresses, Roles, SSH keys, SSH host signatures, Passwords, API tokens. So several issues related to management of inventory can be 

1. Forgetting or loosing ip-address. As complexity increase we might have to deal with numerous ip addresses and there is good chance that either we lose one of them or forget one of them and this could cause very serious failure as many a times servers are hosted or tested using this ip address.
2. Roles of user and their interaction is also related in inventory file as admin or other users can access it can cause some issues if not properly managed or specifies.
3. SSH keys and tokens are at utmost security and many a times we lose them or open to public which can cause fatal implications to system. Sometimes there can be problem with specifying them in quotes or as numbers or as a string.
4. We sometimes have to embed passwords to access particular thing using inventory here we are exposing our password and it can cause security breach.
5. API tokens are refreshed at regular basis and if we have embedded it in our inventory we might have to update it everytime and we might have to keep trwack of it separately and this is very cumbersome task.


### 3. Describe two configuration models. What are disadvantages and advantages of each model?
There are two configuration models: PUSH and PULL
 
The prime motto of Configuration management to set up the servers correctly. Correct is qualitative term and differs from person to person. However correctness and completeness is goal to achieve. PUSH and PULL are the ways a given configuration management tool actually does the things it has to do, like installing packages and writing files.

Push Model: 

•	In PUSH model, A central server contacts the nodes and sends updates as they are needed.
•	When a change is made to the infrastructure (code) each node is alerted of this and they run the changes.

Advantages: 

1.	PUSH model is easier to manage.	
2.	There is Less enforcement of state so asset is able to drift from config.
3.	Asset is centrally managed so it is easier and pretty manageable.
4.	Everything is synchronous, and under your control so one can see that something went wrong and she can correct it immediately.
5.	Errors are synchronous
6.	Development is sensible

Disadvantages: 

1.	Lack of complete automation as it is not easily possible to boot a server and have it configure itself without some sort of client/server protocol that push systems don't generally support
2.	Less scalability as when we deal with hundreds of servers, push system has got some limitations unless it supports heavy processing. 

PULL model :

In this model there is a daemon running on every machine, and these machines call in to the master to see if there’s any new instructions for them. If there are, the daemon applies those instructions to the machine it is running on.

Advantages :

1.	In pull model, Whenever a new server comes up then it can get instructions from the master and start doing things. One can not push the instructions to a server that isn’t there, and the server itself is most aware of when it is ready to do stuff.
2.	If there are numerous requests on server and heavy instructions then servers can run on their own and master would only know about this.
3.	it is possible, and indeed advisable, to fully automate the configuration of a newly booted server using a 'pull' deployment system
4.	 in a 'pull' system, clients contact the server independently of each other, so the system as a whole is more scalable than a 'push' system

Disadvantages :

1.	There are many config management languages available and one cannot  just stick to one.
2.	Unless one deploy several master servers and they are in sync, scalability is still an issue.

### 4. What are some of the consquences of not having proper configuration management?

 Lack of proper configuration management capabilities would impact the overall business operations and to businesses. Some common consequences of the not-proper configuration management can be listed as follows
 
 1. It is very difficult to predict and figure out the components that are constantly chnaging. System to dapt thee changes proper management is uttermost need.
 2. If replacement of component is to be performed and it deletes/modifies existing tools/functionalities then derived functionalities are badly affected and have serious impact on them.
 3. If communication platform is not properly set up then it is very difficut to figure out about configuration changes and their effects onwards.
 4. If we replace or reinstall wrong component or tool then we are in great danger in terms of configuration effects and can end up in serious system failures. 
 5. Managing and isolating access to certain servers and secret configuration is difficult to handle without proper configuration management.
 6. Tokens, keys etc data must be managed. If it is not properly handled then this breach in security can cause fatal defects to the software or data we are processing.
 7. Bad configuration management system can expose this private data and can cause threat to the system.


