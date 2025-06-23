#!/bin/bash

output=$((RANDOM % 2))

if [ $output -eq 0 ]; then
  echo "HEADS"
else
  echo "TAILS"
fi
