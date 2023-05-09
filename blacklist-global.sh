#!/bin/bash

nftexec=$(which nft)
curlexec=$(which curl)

g=0
listname="inet darkhole blacklist-global"
$nftexec flush set $listname

echo "Downloading blacklist file"
ip_list=$($curlexec -s https://lists.blocklist.de/lists/all.txt | grep -e "\." | grep -v ":")
lines=$(wc -l <<<$ip_list)
echo -e $lines '\t IPs in global blacklist'

for ((i = 100; i <= $((lines+99)); i+=100)); do
    elements=$(head -$(($i)) <<< $ip_list | tail -100 | tr '\n' ',');
    $nftexec add element $listname "{ " $elements " }";
        echo -e -n $((i < lines ? i : lines )) "\t IPs added to nftables \r"

    if [  $(($i)) -ge $((lines)) ]; then
        echo -e $lines "\t IPs added to nftables";
        echo $(date +"%F %T") " $lines IPs added to global blacklist" >> /var/log/blacklist-global.log;
    fi

done
