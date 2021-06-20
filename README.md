# What is this? 
This is a script that can be used in conjunction with [dehashed.com.](https://dehashed.com/) Dehashed allows anyone who has an API key to query their API to search for credentials that may exist in a breach database. This script simple uses the dehashed API and sorts the information returned. 
Currently the script does the following
- Filters the results in the format of 
    - Raw dehashed data formatted with into json with JQ
    ``` 
	  "id": "8912739811",
      "email": "example@testdomain.com",
      "ip_address": "0.0.0.0",
      "username": "exampleusername",
      "password": "thisistheplaintextpassword123",
      "hashed_password": "16652e4c27058396b37c026d1bd419a830b20e6a",
      "name": "John Smith",
      "vin": "5YJSA1DG9DFP14705",
      "address": "123 main street",
      "phone": "123-123-1234",
      "database_name": "MyFitnessPal"
    },

	```
    - email:password
	```example@testdomain.com:Pa$$word123```
    - email:hashedpassword
	```example@testdomain.com:8a5d97b76a1ca8965518b0f94787cdd0```

# How do I use it?
To use the script, you need a [dehashed](https://dehashed.com/) account and API Key. 
Then all you need to do is clone this repository and use the following command to query dehashed.
``` ./dehashQuery.sh -l dehashedaccount -k <APIKEY> -s example.com ```
This will search the dehashed database for any accounts associated with *example.com*

![](./example.gif)
