# Linux Shell Scripting Guide

## 1. Introduction to Shell Scripting

Shell scripting allows you to automate tasks, chain commands, and build complex workflows using the Linux shell (typically Bash).

### Your First Script

```bash
#!/bin/bash
# This is a comment
echo "Hello, World!"
```

### Running Scripts

```bash
# Method 1: Make executable
chmod +x hello.sh
./hello.sh

# Method 2: Run with bash
bash hello.sh

# Method 3: Source (runs in current shell)
source hello.sh
. hello.sh
```

### Shebang (`#!`)

The shebang tells the system which interpreter to use:

| Shebang | Interpreter | Use Case |
|---------|-------------|----------|
| `#!/bin/bash` | Bash shell | Most scripts |
| `#!/bin/sh` | POSIX sh | Portable scripts |
| `#!/usr/bin/env bash` | Bash via PATH | Portable, works with custom installs |
| `#!/bin/zsh` | Zsh shell | Zsh-specific features |
| `#!/usr/bin/python3` | Python 3 | Python scripts |

---

## 2. Variables

### Defining Variables

```bash
# No spaces around =
NAME="John"
AGE=30
PI=3.14159
PATH_TO_FILE="/home/user/data.txt"

# Command substitution
CURRENT_DATE=$(date +%Y-%m-%d)
FILE_COUNT=$(ls -1 | wc -l)
KERNEL_VERSION=$(uname -r)
```

### Using Variables

```bash
echo $NAME
echo "$NAME"
echo "${NAME}s"      # String concatenation: Johns
echo "Today is $CURRENT_DATE"
```

### Variable Types

```bash
# Integer arithmetic
COUNT=0
((COUNT++))           # Increment
COUNT=$((COUNT + 5))  # Arithmetic
COUNT=$((COUNT * 2))

# Arrays
FRUITS=("apple" "banana" "cherry")
echo ${FRUITS[0]}     # First element
echo ${FRUITS[@]}     # All elements
echo ${#FRUITS[@]}    # Array length
FRUITS+=("date")      # Append element

# Associative arrays (Bash 4+)
declare -A COLORS
COLORS[red]="#FF0000"
COLORS[green]="#00FF00"
echo ${COLORS[red]}
echo ${!COLORS[@]}    # All keys
```

### Special Variables

| Variable | Description |
|----------|-------------|
| `$0` | Script name |
| `$1-$9` | Positional arguments |
| `$#` | Number of arguments |
| `$@` | All arguments (as separate words) |
| `$*` | All arguments (as single string) |
| `$?` | Exit status of last command |
| `$$` | Current process ID |
| `$!` | PID of last background process |
| `$IFS` | Internal field separator |

### Environment vs Local Variables

```bash
# Local variable (only in current shell)
MY_VAR="local"

# Environment variable (exported to child processes)
export MY_EXPORT="env var"
export PATH="/usr/local/bin:$PATH"

# Or combine
export DB_HOST="localhost"
```

---

## 3. String Operations

```bash
STR="Hello, World!"

echo ${#STR}                    # Length: 13
echo ${STR:0:5}                 # Substring: Hello
echo ${STR:7}                   # From index 7: World!
echo ${STR/Helo/Hello}         # Replace: Hello, World!
echo ${STR//l/L}               # Replace all: HeLLo, WorLd!
echo ${STR^}                   # Uppercase first: Hello, World!
echo ${STR,,}                  # Lowercase all: hello, world!

# String comparison
if [[ "$STR" == "Hello, World!" ]]; then
    echo "Match!"
fi

if [[ "$STR" == *"World"* ]]; then
    echo "Contains World"
fi

# Trim whitespace
TRIMMED="  hello  "
echo "${TRIMMED}"               # Without quotes, whitespace stripped
echo "${TRIMMED## }"           # Trim leading spaces
echo "${TRIMMED%% }"           # Trim trailing spaces
```

---

## 4. Conditionals

### if-elif-else

```bash
if [[ condition ]]; then
    # True branch
elif [[ condition ]]; then
    # Another branch
else
    # Default branch
fi
```

### Comparison Operators

| Operator | Description | Numeric | String |
|----------|-------------|---------|--------|
| `==` | Equal | Yes | Yes |
| `!=` | Not equal | Yes | Yes |
| `-eq` | Equal | Yes | No |
| `-ne` | Not equal | Yes | No |
| `-lt` | Less than | Yes | No |
| `-le` | Less or equal | Yes | No |
| `-gt` | Greater than | Yes | No |
| `-ge` | Greater or equal | Yes | No |
| `<` | Less than (in `(( ))`) | Yes | No |
| `>` | Greater than (in `(( ))`) | Yes | No |
| `=` | Equal | No | Yes |

### File Tests

| Operator | Description |
|----------|-------------|
| `-f` | Regular file exists |
| `-d` | Directory exists |
| `-e` | File/dir exists |
| `-r` | Readable |
| `-w` | Writable |
| `-x` | Executable |
| `-s` | File exists and is non-empty |
| `-L` | Symbolic link exists |
| `-nt` | Newer than (file1 -nt file2) |
| `-ot` | Older than |

### Logical Operators

| Operator | Description |
|----------|-------------|
| `&&` | AND (in [[ ]]) |
| `\|\|` | OR (in [[ ]]) |
| `!` | NOT |
| `-a` | AND (in [ ]) |
| `-o` | OR (in [ ]) |

### Examples

```bash
# Numeric comparison
if [[ $AGE -ge 18 ]]; then
    echo "Adult"
fi

# String comparison
if [[ "$NAME" == "admin" ]]; then
    echo "Welcome, admin"
fi

# File test
if [[ -f "/etc/passwd" ]]; then
    echo "Password file exists"
fi

# Combined conditions
if [[ -f "$FILE" && -r "$FILE" ]]; then
    echo "File exists and is readable"
fi

# Case statement
case "$1" in
    start)
        echo "Starting service..."
        ;;
    stop)
        echo "Stopping service..."
        ;;
    restart)
        echo "Restarting service..."
        ;;
    status)
        echo "Checking status..."
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
```

---

## 5. Loops

### for Loop

```bash
# Iterate over list
for FRUIT in apple banana cherry; do
    echo "Fruit: $FRUIT"
done

# Iterate over files
for FILE in /var/log/*.log; do
    echo "Processing: $FILE"
done

# C-style for loop
for ((i=1; i<=10; i++)); do
    echo "Number: $i"
done

# Range
for i in {1..10}; do
    echo "Number: $i"
done

# With step
for i in {0..20..5}; do
    echo "Number: $i"   # 0, 5, 10, 15, 20
done

# Iterate over command output
for USER in $(cat /etc/passwd | cut -d: -f1); do
    echo "User: $USER"
done
```

### while Loop

```bash
# Basic while
COUNT=1
while [[ $COUNT -le 5 ]]; do
    echo "Count: $COUNT"
    ((COUNT++))
done

# Read file line by line
while IFS= read -r LINE; do
    echo "Line: $LINE"
done < file.txt

# Infinite loop
while true; do
    echo "Running..."
    sleep 5
done

# While with command
while read -r LINE; do
    echo "$LINE"
done < <(grep "error" /var/log/syslog)
```

### until Loop

```bash
# Runs until condition is true
COUNT=1
until [[ $COUNT -gt 5 ]]; do
    echo "Count: $COUNT"
    ((COUNT++))
done
```

### Loop Control

```bash
# break - exit loop
for i in {1..10}; do
    if [[ $i -eq 5 ]]; then
        break
    fi
    echo $i
done

# continue - skip iteration
for i in {1..10}; do
    if [[ $((i % 2)) -eq 0 ]]; then
        continue   # Skip even numbers
    fi
    echo $i
done
```

---

## 6. Functions

### Basic Function

```bash
greet() {
    echo "Hello, $1!"
}

greet "John"    # Output: Hello, John!
```

### Return Values

```bash
# Return a value via echo (capture with $())
add() {
    local RESULT=$(($1 + $2))
    echo $RESULT
}

SUM=$(add 5 3)
echo "Sum: $SUM"    # Sum: 8

# Return status code (0 = success)
is_valid() {
    if [[ $1 -gt 0 ]]; then
        return 0    # Success
    else
        return 1    # Failure
    fi
}

if is_valid 5; then
    echo "Valid"
fi
```

### Local Variables

```bash
my_function() {
    local LOCAL_VAR="only in function"
    GLOBAL_VAR="visible everywhere"
}

my_function
echo $GLOBAL_VAR      # visible everywhere
echo $LOCAL_VAR       # (empty - local to function)
```

### Function Examples

```bash
# Log function with levels
log() {
    local LEVEL=$1
    local MESSAGE=$2
    local TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] [$LEVEL] $MESSAGE" >> /var/log/myscript.log
    echo "[$LEVEL] $MESSAGE"
}

log "INFO" "Script started"
log "ERROR" "Something went wrong"

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

if command_exists docker; then
    echo "Docker is installed"
fi

# Menu display
show_menu() {
    echo "========== Menu =========="
    echo "1. Start"
    echo "2. Stop"
    echo "3. Status"
    echo "4. Exit"
    echo "=========================="
}
```

---

## 7. Input/Output

### Reading Input

```bash
# Read single variable
echo "Enter your name:"
read NAME
echo "Hello, $NAME!"

# Read with prompt
read -p "Enter your age: " AGE

# Read silently (password)
read -s -p "Password: " PASSWORD
echo  # newline after hidden input

# Read with timeout
read -t 5 -p "Quick! Enter something: " INPUT

# Read into array
read -a NUMBERS -p "Enter numbers: "

# Read from file descriptor
exec 3< file.txt
while IFS= read -r LINE <&3; do
    echo "$LINE"
done
exec 3<&-
```

### Output

```bash
# echo (adds newline)
echo "Hello"
echo -n "No newline"      # Without newline
echo -e "Tab\there"      # Interpret escape sequences

# printf (formatted output)
printf "Name: %s, Age: %d\n" "John" 30
printf "%10s %5s\n" "Name" "Age"     # Padded output
printf "%05d\n" 42                    # Zero-padded: 00042
printf "%.2f\n" 3.14159               # Float: 3.14

# Redirect to file
echo "Hello" > output.txt          # Overwrite
echo "World" >> output.txt         # Append

# Here document
cat << EOF
This is a multi-line
text block. Variables like $NAME
are expanded.
EOF

cat << 'EOF'
This is literal text.
$NAME will NOT be expanded.
EOF

# Here string
grep "pattern" <<< "search this string"
```

---

## 8. Error Handling

### Exit Codes

```bash
# Check last command exit code
echo $?

# Successful command
ls /tmp
echo $?    # 0

# Failed command
ls /nonexistent
echo $?    # 2
```

### trap (Signal Handling)

```bash
#!/bin/bash

# Cleanup function
cleanup() {
    echo "Cleaning up temporary files..."
    rm -f /tmp/mytempfile_*
}

# Set trap for various signals
trap cleanup EXIT
trap 'echo "Interrupted!"; exit 1' INT TERM

# Create temp file
touch /tmp/mytempfile_$$

echo "Working..."
sleep 10
echo "Done"
# cleanup() runs automatically on exit
```

### Error Handling Patterns

```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Check each command
do_something() {
    if ! command; then
        echo "Error: command failed" >&2
        return 1
    fi
}

# Retry logic
retry() {
    local MAX_ATTEMPTS=3
    local ATTEMPT=1
    while [[ $ATTEMPT -le $MAX_ATTEMPTS ]]; do
        if "$@"; then
            return 0
        fi
        echo "Attempt $ATTEMPT failed. Retrying..."
        ((ATTEMPT++))
        sleep 2
    done
    echo "All $MAX_ATTEMPT attempts failed"
    return 1
}

retry curl -s https://api.example.com/data
```

### set Options

| Option | Description |
|--------|-------------|
| `set -e` | Exit on any command failure |
| `set -u` | Treat unset variables as errors |
| `set -o pipefail` | Pipeline returns status of last failed command |
| `set -x` | Print each command before execution (debug) |
| `set -v` | Print shell input lines as read |

---

## 9. Advanced Techniques

### Arithmetic

```bash
# let
let RESULT=5+3
let COUNT++

# Arithmetic expansion
RESULT=$((5 + 3))
RESULT=$((COUNT++))
RESULT=$(echo "scale=2; 10/3" | bc)

# bc for floating point
AREA=$(echo "scale=2; 3.14 * 5 * 5" | bc)
echo "Area: $AREA"
```

### Working with Arrays

```bash
# Declare and initialize
declare -a NAMES=("Alice" "Bob" "Charlie")

# Add elements
NAMES+=("David")

# Remove element
unset NAMES[1]

# Slice
echo "${NAMES[@]:1:2}"   # Elements 1-2

# Check if array contains element
if [[ " ${NAMES[@]} " =~ " Bob " ]]; then
    echo "Found Bob"
fi
```

### Working with Associative Arrays

```bash
declare -A CAPITALS
CAPITALS[USA]="Washington DC"
CAPITALS[UK]="London"
CAPITALS[France]="Paris"

for COUNTRY in "${!CAPITALS[@]}"; do
    echo "$COUNTRY: ${CAPITALS[$COUNTRY]}"
done
```

### Process Substitution

```bash
# Compare outputs of two commands
diff <(ls /dir1) <(ls /dir2)

# Read from command as if it were a file
while read -r LINE; do
    echo "$LINE"
done < <(grep "error" /var/log/syslog)
```

### Temporary Files

```bash
# Create temp file
TEMP_FILE=$(mktemp /tmp/myapp.XXXXXX)
echo "Temp file: $TEMP_FILE"

# Create temp directory
TEMP_DIR=$(mktemp -d /tmp/myapp.XXXXXX)

# Cleanup on exit
trap 'rm -rf "$TEMP_FILE" "$TEMP_DIR"' EXIT
```

### Colorized Output

```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

echo -e "${GREEN}Success${NC}"
echo -e "${RED}Error${NC}"
echo -e "${YELLOW}Warning${NC}"
```

---

## 10. Complete Script Example

```bash
#!/bin/bash
set -euo pipefail

# Configuration
LOG_FILE="/var/log/deploy.log"
BACKUP_DIR="/backup/$(date +%Y%m%d)"
APP_NAME="myapp"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Functions
log() {
    local TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

error_exit() {
    log "${RED}ERROR: $1${NC}"
    exit 1
}

check_dependencies() {
    for CMD in git docker nginx; do
        if ! command -v "$CMD" &> /dev/null; then
            error_exit "$CMD is not installed"
        fi
    done
}

backup_data() {
    log "Creating backup..."
    mkdir -p "$BACKUP_DIR"
    if [[ -d "/var/www/$APP_NAME" ]]; then
        cp -r "/var/www/$APP_NAME" "$BACKUP_DIR/"
    fi
    log "Backup completed: $BACKUP_DIR"
}

deploy() {
    log "Deploying $APP_NAME..."
    cd "/var/www/$APP_NAME" || error_exit "Directory not found"
    
    git pull origin main || error_exit "Git pull failed"
    
    docker build -t "$APP_NAME:latest" . || error_exit "Docker build failed"
    docker stop "$APP_NAME" 2>/dev/null || true
    docker run -d --name "$APP_NAME" -p 8080:80 "$APP_NAME:latest" \
        || error_exit "Docker run failed"
    
    log "${GREEN}Deployment completed successfully${NC}"
}

# Main
main() {
    log "Starting deployment of $APP_NAME"
    check_dependencies
    backup_data
    deploy
    log "Deployment process finished"
}

main "$@"
```

---

## 11. Bash Scripting Best Practices

| Practice | Bad | Good |
|----------|-----|------|
| **Shebang** | No shebang | `#!/usr/bin/env bash` |
| **Error handling** | No error handling | `set -euo pipefail` |
| **Quoting** | `echo $variable` | `echo "$variable"` |
| **Variables** | `NAME = "John"` | `NAME="John"` |
| **Conditionals** | `[ $a == $b ]` | `[[ "$a" == "$b" ]]` |
| **Local vars** | Global in functions | `local var="value"` |
| **Temp files** | Hardcoded paths | `mktemp` with trap cleanup |
| **Comments** | No comments | Explain non-obvious logic |
| **ShellCheck** | Not using | Run `shellcheck script.sh` |

---

## Summary

| Topic | Key Concepts |
|-------|-------------|
| **Variables** | No spaces, `$VAR`, `${VAR}`, `export` |
| **Strings** | `${#len}`, `${str:pos:len}`, `${str/old/new}` |
| **Conditionals** | `[[ ]]` for tests, `case` for multi-branch |
| **Loops** | `for`, `while`, `until`, `break`, `continue` |
| **Functions** | `local` vars, return via `echo`, status codes |
| **I/O** | `read`, `echo`, `printf`, heredocs |
| **Error handling** | `set -euo pipefail`, `trap`, exit codes |
| **Advanced** | Process substitution, arrays, colorized output |

> **Tip**: Always run your scripts through `shellcheck` to catch common errors and security issues. Install with `apt install shellcheck` or use online at shellcheck.net.
