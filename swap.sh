#!/bin/bash
# This script returns the top five proceses that are using most amount of swap memory in descending order
for i in /proc/*/status ; do
    vmswap=$(cat $i | grep "^VmSwap")
    echo "$vmswap" | grep -qv ' 0 kB'
    if [ $? == 0 ] && [ "$vmswap" != "" ] ; then
        echo "$i : $vmswap" >> /tmp/swapusage.txt-$$
    fi
done

for i in `cat /tmp/swapusage.txt-$$ | sed 's/:/\ /g' | sort -r -k 3 -n | head -5 | awk '{print $1}' | cut -f 3 -d /`
do
	ps -ef | grep $i | head -1
done
rm -rf /tmp/swapusage.txt-$$
