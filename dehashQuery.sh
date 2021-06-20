#! /bin/sh

green="\e[32m"
nocolor="\e[0m"
cyan="\e[36m"
while getopts l:s:k:h flag
do
    case "${flag}" in
        l) login=${OPTARG};;
        s) searchName=${OPTARG};;
        k) apikey=${OPTARG};;
        h) help=${OPTARG};;
    esac
done
if [ $# -eq 0 ]; then
	echo 'Please use -l <login> -k <apikey> -s <domain> '
	exit 1
fi 
mkdir $searchName
cd $searchName 

# Access API
echo "${cyan}Downloading data..."
curl "https://api.dehashed.com/search?query=email:"@$searchName"&size=10000" -u $login:$apikey -H 'Accept: application/json' > curledData.json

#Take curledData.json and format it to put usernames and passwords next to each other                                     
cat curledData.json | jq >> rawData.json; egrep "\"password|email" rawData.json | grep -v "\"password\": \"\"" | grep -B1 \"password\"  | sed 's/\-\-/ \n/g'  >> emailAndPassword.json                                                    
echo "${green}emailAndPassword.json created."

#Take curledData.json and format it to put usernames and passwords next to each other
cat emailAndPassword.json | awk 'NR%2{printf "%s ",$0;next;}1' | sed -r 's/[,, \+]//g' | sed 's/\"password\"//g'| sed 's/"//g' | sed 's/email://g' | grep "\S"  | sort | uniq -u >> emailAndPasswordFilter.txt
echo "${green}emailAndPassword.json created."

#Take curledData.json and format it to put usernames and hashed paswords next to each other.  
egrep "\"hashed_password|email" rawData.json | grep -v "\"hashed_password\": \"\"" | grep -B1 \"hashed_password\"  | sed 's/\-\-/ \n/g' >> emailAndHash.json
echo "emailAndHash.json created."

#Sort hashes to make parsing easier 
cat emailAndHash.json | sed -e 's/^[ \t]*//'| awk '{ORS = sub(/,$/,"") ? "" : "\n"} 1' | tr -d "\n" | sed -e 's/\"email\"/\n/g' | sed -e 's/^://g' | sed -e 's/"hashed_password"//g' | sort | uniq -u | sed 's/"//g' | tr -d " " >> emailAndHashFiltered.txt

rm curledData.json emailAndHash.json emailAndPassword.json
echo "Done! ${nocolor}"
