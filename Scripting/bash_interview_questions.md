Q) Write a script to print numbers divided by 3 and 5 and not 15. 
```
#!/bin/bash
# divisible by 3, divisible by 5 , not 3*5=15
for i in {1..100}; do
  if ([ `expr $i % 3` == 0 ] || [ `expr $i % 5` == 0 ]) && [ `expr $i % 15` != 0 ];
  then
    echo "number is $i"
  fi;
done;
```
Q) Write a script to print number of "S" in mississippi ?
```
#!/bin/bash

set -x

word="mississippi"
#grep -o "s" <<< "$word" | wc -l
echo "$word" | grep -o "s" | wc -l 
```
Q) How do you debug shell script ?
```
Add "set -x" as the first line of the script.
```
Q) What is crontab in Linux ? Provide an example ?
```
Crontab is a way to schedule recussing tasks/processes in linux.
* * * * * echo "Hello" >> /tmp/hello.log
This runs every minute, and prints Hello in the log file.
```
```
*  *  *  *  *  <command>
│  │  │  │  │
│  │  │  │  └─ Day of week (0-6, Sunday = 0)
│  │  │  └──── Month (1-12)
│  │  └─────── Day of month (1-31)
│  └────────── Hour (0-23)
└───────────── Minute (0-59)
```
Q) How to open read-only file ?
```
vim -r test.txt
```
Q) What is difference b/w soft and hard link ?
```
When we try to create or save a file, it gets saved on the disk. If we want to reuse the file mutiple times,
instead of coping the file, we can just create hardlink to the file (it mirrors a file or creates a copy).
Even if the original file is deleted the hardlink files still exist.

In case of softlinks when we use the softlink file, the linux terminal sends this request to the original file.
So if the softlink is deleted then original file also gets deleted.
```

Q) What is break and continue ?
```
BREAK - If a condition is met then it breaks the loop.
CONTINUE - skips current loop to next step when a condition is met.
```

Q) Disadvantages of shell scripting ?
```
- everytime a shell command is executed, a new process is launched.
- Slow for large tasks – Not efficient for complex logic or big data
- Poor error handling – Limited exception control
- Security risk: If a shell script uses user input without checking it, someone could enter a harmful command and the script might run it.
- Difficult to maintain – Readability drops with script size/complexity
```

Q) How to troubleshoot network using linux commands ?
```
- nslookup - to check DNS Mapping
- traceroute - to check why n/w is slow, it maps the number of hops(your router, your internet provider router etc)
that the request goes through to reach the DNS.
- tracepath 
```
Q) How to sort list of names in a file ?
```
use sort command.
```
Q) How will you manage logs of a system that generate huge log files everyday ?
```
logrotate can be used to manage linux machine or application logs.
within a scheduled time we can recurringly zip the logs using logrotate.
```

Q) How to identify the list of process in linux machine ?
```
ps -ef | awk -F" " '{print $2, $8}'
```

Q) How to check whether a file exists using a shell script ?
```
#!/bin/bash
if [ -e /root/scripts/test.sh ]; then
    echo "File exists"
else
    echo "File doesnt exist"
fi
```
