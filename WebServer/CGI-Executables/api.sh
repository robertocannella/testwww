#!/bin/bash

# Send the HTTP Status Code
echo "Status: 200 Okay"
echo "Content-Type: application/json"
echo ""


# Sending a JSON response
echo '{'
echo '  "status": "success",'
echo '  "message": "Data retrieved successfully",'
echo '  "data": {'
echo '    "id": 123,'
echo '    "name": "Sample Item",'
echo '    "quantity": 10'
echo '  }'
echo '}'

