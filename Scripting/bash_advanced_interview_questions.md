Q) How do you handle error checking of a command to check whether a command worked successfully ?
```
#!/bin/bash

ls /nonexistent
if [ $? -eq 0 ]; then
  echo "command worked"
else
  echo "failed"
```
```
#!/bin/bash

set -e
trap 'ls /nonexistent' ERR
```
Q) I want to enable debugging of my shell script from line number 1 to 10 only . How to do it ?
```
#!/bin/bash
set -e
#1
#2 ...
set +x
```
to run the whole script in debug mode you can run the script like this - bash +x test.sh

Q) How to use arrays in shell script ?
```
my_array={ele1 ele2 ele3}
echo ${my_array[0]} #prints ele1
echo ${my_array[@]} #prints all of them
for element in "${my_array[@]}"; do
  echo $element
done
```
Q) How to do arithmentic operation in bash ?
```
option 1: use double bracket
result=$(( 3 + 4 )); echo $result

option 2: using expr
result=$(expr 3 + 4)
echo $result
```

Q) How to execute a command stored in a variable ?
```
command="ls file.txt"
eval $command
```

Q) How to handle the arguments in shell script ?
```
echo "First argument: $1"
echo "All arguments: $@"
echo "Number of arguments: $#"
```

Q) How to check whether a variable is set ?
```
var="abc"
if [ -z "$VAR" ]; then
  echo "VAR is not set"
else
  echo "VAR is set to $VAR"
fi
```

