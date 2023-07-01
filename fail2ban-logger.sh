#!/bin/bash
# Retrieves bad hosts messing around...

# Retrieve all IPs from fail2ban log
ips=$(grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" /var/log/fail2ban.log)

# Count the number of unique IPs
count=$(echo "$ips" | sort | uniq -c | wc -l)

# Find the top 100 IPs
top_ips=$(echo "$ips" | sort | uniq -c | sort -nr | head -n 100)

# Count the number of times each top IP appears
top_ips_count=$(echo "$top_ips" | awk '{print $1}')

# Retrieve country of each host of top 100 print it too
echo "Country of each host of top 100:"
while read -r line; do
    ip=$(echo "$line" | awk '{print $2}')
    country=$(geoiplookup "$ip" | awk -F ', ' '{print $2}')
    echo "$line $country"
done <<< "$top_ips"


echo "Total unique IPs: $count"
