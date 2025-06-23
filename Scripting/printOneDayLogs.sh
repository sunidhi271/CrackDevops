#!/bin/bash

filename=final_output.log
today=${date +%Y-%m-%d}
yesterday=${date -d "yesterday" +%Y-%m-%d}

grep -E "${today}|${yesterday}" ${filename}
