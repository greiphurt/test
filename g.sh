pactree -u plasma-desktop | tail -n +2 | xargs -r pacman -Si \
| awk -v pkg="" '/Name/ { pkg=$2 } /Version/ { print pkg"-"$2 }' \
> packlist-recursive.txt
