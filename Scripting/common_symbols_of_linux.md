# Common Bash/Linux Symbols and Their Meaning

| Symbol                          | Meaning                                        | Example                             | Description                                 |        |   |        |                         |
| ------------------------------- | ---------------------------------------------- | ----------------------------------- | ------------------------------------------- | ------ | - | ------ | ----------------------- |
| `#!`                            | **Shebang**                                    | `#!/bin/bash`                       | Declares the script interpreter             |        |   |        |                         |
| `$?`                            | **Exit status** of last command                | `echo $?`                           | 0 = success, non-zero = error               |        |   |        |                         |
| `$!`                            | **PID of last background process**             | `sleep 10 & echo $!`                | Useful for tracking processes               |        |   |        |                         |
| `-z`                            | **String is empty**                            | `[ -z "$name" ]`                    | True if variable is empty                   |        |   |        |                         |
| `-n`                            | **String is not empty**                        | `[ -n "$name" ]`                    | True if variable is non-empty               |        |   |        |                         |
| `$0`                            | Script **name**                                | `echo $0`                           | Shows the name of the script file           |        |   |        |                         |
| `$1`, `$2`, ...                 | **Positional parameters**                      | `./script.sh arg1 arg2` → `$1=arg1` | Used to access passed arguments             |        |   |        |                         |
| `"$@"`                          | **All arguments (individually quoted)**        | `for i in "$@"; do ...`             | Handles arguments with spaces correctly     |        |   |        |                         |
| `"$*"`                          | **All arguments as a single string**           | `echo "$*"`                         | Less safe with spaces                       |        |   |        |                         |
| `&`                             | **Run in background**                          | `sleep 5 &`                         | Runs process in background                  |        |   |        |                         |
| `&&`                            | **Run next command only if previous succeeds** | `cmd1 && cmd2`                      | Used for chaining                           |        |   |        |                         |
| \`                              |                                                | \`                                  | **Run next command only if previous fails** | \`cmd1 |   | cmd2\` | Like: “if not, then...” |
| `&>`                            | **Redirect both stdout and stderr**            | `cmd &> output.log`                 | Combines `> file 2>&1`                      |        |   |        |                         |
| `>`                             | Redirect stdout                                | `ls > out.txt`                      | Overwrites file                             |        |   |        |                         |
| `>>`                            | Append stdout                                  | `echo hello >> out.txt`             | Appends to file                             |        |   |        |                         |
| `2>`                            | Redirect stderr                                | `cmd 2> err.txt`                    | Only error messages                         |        |   |        |                         |
| `2>&1`                          | Redirect stderr to stdout                      | `cmd > out.txt 2>&1`                | Combine outputs                             |        |   |        |                         |
| `` `command` `` or `$(command)` | **Command substitution**                       | `today=$(date)`                     | Stores command output in a variable         |        |   |        |                         |
