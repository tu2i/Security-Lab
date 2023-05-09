#!/bin/bash
f=0
cf=0
af=0

for i in $(find /var/log -type f); do
    cat /dev/null > $i;
    f=$(expr $f + 1)
    if [[ $i == *".gz" ]]; then
        rm $i;
        cf=$(expr $cf + 1);
    fi
    for t in {1..20}; do
        if [[ $i == *"."$t ]]; then
            rm $i;
            af=$(expr $af + 1);
        fi
    done
done

echo "[+] Cleared $(expr $f - $cf - $af) files"
echo "[+] Deleted $cf compressed files"
echo "[+] Deleted $af archive files"
