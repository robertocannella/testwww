#!/bin/bash

# This script runs during an API request

source ../env.sh
source ../Project/jwt/generate_jwt.sh
source ../Project/log/debug.sh

# Set the secret key
secret_key="Your-Secret-Key"

# Generate header and payload
header=$(create_header | base64url_encode)
payload=$(create_payload "1234567890" "John Doe" false | base64url_encode)

# Generate JWT

jwt=$(generate_jwt "$header" "$payload" "$secret_key")

# Extract the API version header exact case
# api_version="${HTTP_X_API_VERSION}"
# Extract Content-Type header to uppercase
version=$(echo "$HTTP_X_API_VERSION" | tr '[:lower:]' '[:upper:]')

# MAKE A CALL TO TCP SERVER


for ATTEMPT in $($SEQ_CMD "$MAX_ATTEMPTS"); do
		log_debug "tcpclient request attempt:$ATTEMPT" ;
		status_capture=0;
#     setuidgid www-data /usr/bin/tcpserver -RH -l0 127.0.0.1 9999 sh -c /etc/service/howdyd/howdyd.sh
#		  $TCP_CLIENT -RHl0 -T 5 -- "$SERVER_IP" "$SERVER_PORT" $FWKWRAPPER ${PASSWORKDIR};
		$TCP_CLIENT -RH -l0  -- "$SERVER_IP" "$SERVER_PORT" sh -c /etc/service/howdyd/howdyd.sh;
		status_capture=${PIPESTATUS[0]}
		log_debug "tcpclient exit status $status_capture"
#		if [ "$statuscap" -eq "0" ] || [ "$statuscap" -eq "124" ] || [ "$statuscap" -eq "141" ]; then
#                        if [ ! -s "${WORKDIR}/output" ]; then
#				log_debug "tcpclient done but output is empty" ;
#				err_stdout "There was a problem processing your request. System administrators have been notified and will address the issue. "
#			exit 1
#			fi

    if [ "$status_capture" -eq 111 ]; then
        log_error "Error: Unable to connect to $SERVER_IP on port $SERVER_PORT"
    fi

	  # end of output test
			log_debug "tcpclient request finished" ;
#			DATECMD > ${WORKDIR}/finished
      exit 0
#			clean_up 0
#		else
#		# bad exit value statuscap
#			export DEBUG=2
#			touch ${WORKDIR}/error
#			log_debug "tcpclient failed waiting for $[ATTEMPT*2] "
#			sleep $((ATTEMPT*2))
#			ATTEMPT=$((ATTEMPT+1))
#		fi # end of statuscap test
	done

# END MAKE A CALL TO TCP SERVER

# Check Content-Type and execute corresponding script
if [[ "${version}" == "API-VERSION-2023-12" ]]; then
    echo "Content-Type: application/json"
    echo ""
    # Sending a JSON response
    echo '{'
    echo '  "Generated JWT": "'"${jwt}"'",'
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

