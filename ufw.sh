
#!/bin/bash
# Retrieves bad hosts messing around...

# Retrieve all IPs from ufw log and print only top 100 ips
ips=$(grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" /var/log/ufw.log.1 | sort | uniq -c | sort -nr | head -n 100)

# Count the number of unique IPs
count=$(echo "$ips" | wc -l)

# Find all IPs
all_ips=$(echo "$ips")

# Count the number of times each IP appears
all_ips_count=$(echo "$all_ips" | awk '{print $1}')

# Retrieve country of each host of all IPs and print it too
echo "Country of each host of all IPs:"
while read -r line; do
    ip=$(echo "$line" | awk '{print $2}')
    country=$(geoiplookup "$ip" | awk -F ', ' '{print $2}')
    echo "$line $country"
done <<< "$all_ips"

echo "Total unique IPs: $count"

# Count the number of each country appeared as "Ban" in ufw.log
echo "Number of each country appeared as \"Ban\" in ufw.log:"
echo "$all_ips" | while read -r line; do
    ip=$(echo "$line" | awk '{print $2}')
    country=$(geoiplookup "$ip" | awk -F ', ' '{print $2}')
    if [ -n "$country" ]; then
        echo "$country"
    else
        echo "Ban"
    fi
done | sort | uniq -c


