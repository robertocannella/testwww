#!/bin/bash

# This script runs during an API request

# Extract the API version header exact case
# api_version="${HTTP_X_API_VERSION}"
# Extract Content-Type header to uppercase
version=$(echo "$HTTP_X_API_VERSION" | tr '[:lower:]' '[:upper:]')


# Check Content-Type and execute corresponding script
if [[ "${version}" == "API-VERSION-2023-12" ]]; then
    echo "Content-Type: application/json"
    echo ""
    # Sending a JSON response
    echo '{'
    echo '  "version":  "'"${version}"'",'
    echo '  "status": "success",'
    echo '  "message": "Data retrieved successfully",'
    echo '  "data": {'
    echo '    "id": 123,'
    echo '    "name": "Sample Item",'
    echo '    "quantity": 10'
    echo '  }'
    echo '}'
    exit 0
else
     # Send the HTTP Status Code
     echo "Status: 400"
     echo "Content-Type: application/json"
     echo ""

     # Sending a JSON response
     echo '{'
     echo '  "status": "error",'
     echo '  "message": "Incorrect or missing header X-API-VERSION"'
     echo '}'

     exit 1
fi

# Send the HTTP Status Code
echo "Status: 500 Unknown Error"
echo "Content-Type: application/json"
echo ""

