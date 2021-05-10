#! /bin/sh
cd `dirname $0`

ssid=`nmcli dev wifi | awk '{if ($1=="*") print $2}' | sed 's/ //g'`
nasname=`awk -F "\t" -v ssid="$ssid" '{if ($1==ssid) print $2}' NASconfig.tsv | sed 's/ //g'`
ip=`awk -F "\t" -v ssid="$ssid" '{if ($1==ssid) print $3}' NASconfig.tsv | sed 's/ //g'`
options=`awk -F "\t" -v ssid="$ssid" '{if ($1==ssid) print $4}' NASconfig.tsv`
echo $ssid $nasname $ip $options

dirs=`smbclient -L $ip -U% -g | awk -F '|' '{if($1=="Disk") print $2 }'`

for dir in ${dirs[@]};
do
    echo "mount -t cifs //$ip/$dir /mnt/$nasname/$dir -o $options"
    mkdir -p /mnt/$nasname/$dir
    mount -t cifs //$ip/$dir /mnt/$nasname/$dir -o $options
done