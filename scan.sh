#!/bin/bash

# Scan local ports
# Usage: scan 0 / scan 0,1,2 / scan 0-8
function scan {
  if [[ -z $1 || -z $2 ]]; then
      echo "Usage: $0 <host> <port, ports, or port-range> [verbose (0 or 1)]"
    return
  fi

  local host=$1
  local ports=()
  local any=0

  case "$2" in
    *-*)
      IFS=-
      read start end <<< "$2"
      for ((port=start; port <= end; port++)); do
        ports+=($port)
      done
      ;;
  *,*)
      IFS=,
      read -ra ports <<< "$2"
      ;;
    *)
      ports+=($2)
      ;;
  esac

  for port in "${ports[@]}"; do
      printf "\r$port: SCAN   \t"
      timeout 1 bash -c "echo >/dev/tcp/$host/$port" &> /dev/null &&
          printf "\r$port: OPEN   \n" ||
          printf "\r"
  done
}

# Uncomment the below lines to use it with `.' instead of `source'
#if [[ -z $1 || -z $2 ]];
#then
#    echo "Usage: $0 <host> <port, ports, or port-range> [verbose (0 or 1)]"
#    return #Don't use `exit', this might be called from a script
#fi
