#!/bin/bash

# Extract Content-Type header
CONTENT_TYPE=$(echo "$CONTENT_TYPE" | tr '[:upper:]' '[:lower:]')

# Check Content-Type and execute corresponding script
if [[ "$CONTENT_TYPE" == "application/json" ]]; then
    ./api.sh
    exit 0
else
    # Default handler or error
    ./html.sh
    exit 0
fi


# ... [rest of your script] ...

# Set constants:
export NOW=$(date +%Y-%m-%d_%H:%M:%S.%N)
TEMPLOCATION="/dev/shm/"
WKPRODLABEL=TESTFWWEBB
RANDOM_DIR="${NOW}_$$.${RANDOM}"
export WORKDIR="${TEMPLOCATION}/${WKPRODLABEL}/${RANDOM_DIR}"
WKPROD=/emcmisc/webbconnect.fwwebb.com/TESTFWWEBB/
function DATECMD() { \date "+%Y-%m-%d %H:%M:%S.%N"; }


#***********************

#!/bin/bash

## Send the HTTP Status Code
#echo "Status: 401 Unauthorized"
## Optionally, you can also send a WWW-Authenticate header to prompt for credentials
##echo "WWW-Authenticate: Basic realm=\"Restricted Area\""
## Don't forget the Content-Type header
#echo "Content-Type: text/html"
#echo ""

# Your HTML or message to display
#echo "<html><body><h1>401 Unauthorized</h1><p>You need to provide valid credentials to access this resource.</p></body></html>"

#**********************************



	# Rename directory if it exists.
	if [ -d "${WORKDIR}" ]; then # set at top
 	   #$DEBUG_ECHO "dup workdir, randomizing" ;
           export WORKDIR=${WORKDIR}.${RANDOM}
 	fi


	# -p flag is (create parent- no error if exsits)
	mkdir -p  "${WORKDIR}"
 	if [ ! "$?" -eq 0 ]; then 
 		echo "Content-typ: text/html"
		echo ""
		echo "<h1>Error creating directory</h1>"
		#$DEBUG_ECHO "Unable to create temporary directory" ;
 		#err_stdout "Server temporarily  unavailable.<br>An error has been logged and it will be fixed as soon as possible<br><br>error: $$_TMPDIR"
 	        #clean_up 1
 	fi
 	#-----------------------------------------
  # BEGIN - SET THE WKSCRIPT
  #--------

      	# "$SCRIPT_NAME" is a CGI SCRIPT Enviromental Variable
       	# if it is not empty, then create a WKSCRIPT constant
        	# The basename command is used to get the last component of a file path.
          #	For example, if $SCRIPT_NAME was /path/to/script.sh, basename $SCRIPT_NAME would return script.sh.

      if [ ! -z "$SCRIPT_NAME" ]; then WKSCRIPT="$(basename $SCRIPT_NAME)"
      fi
  #--------
  # END - Set the WKSCRIPT.
  #-----------------------------------------

  #-----------------------------------------
  # BEGIN - Extract the query
  #--------
    # The QUERY_STRING is a CGI environmental variable
    #	Check Apache rewrite rules for details as the QUERY_STRING is masked for SEO
    #	    RewriteEngine On
    #	    RewriteCond %{REQUEST_URI} ^/bin/.*
    #	    RewriteRule ^/bin/(.*)$ /bin/hello.cgi?wo.$1 [L,PT,NE] #<-- Adds a query to the string
  	# if this is a wkform call change preprocessor
  	CGIBIN="$WKPROD/WKSCRIPTS"
  	POSTDATA="%%WKNOARGS%%"

  	# Empty Query String
  	if [ -z "$QUERY_STRING" ]; then
  	  #/bin/mmcis_error.sh
   	  \echo -e "Location:${REQUEST_SCHEME}://${HTTP_HOST}/notfound_bin.html\n\n"
  	  exit
  	fi

    	# Set the QUERY (transform '+' to ' ')
  	QUERY=$(\echo "$QUERY_STRING"| tr '+' ' ')
  	if [ -z "$QUERY" ] ; then
  		QUERY="No_Control"
  	else
  		# some search engines store line with + replaced by %20.
  		# turn first %20 back to blank
  		# convert any explicit ' chars to %27
  		QUERY=$(\echo "$QUERY" | sed "s/%20/ /g;s/'/%27/g")
  	fi

  #--------
  # END - Extract the query
  #-----------------------------------------


	# upcase the REQUEST_METHOD env value and test if POST
		REQUEST_METHOD=$(\echo "$REQUEST_METHOD" | tr "post" "POST")
	   if [ "$REQUEST_METHOD" = "POST" ] && [ ! -z "$CONTENT_LENGTH" ]; then
# Post method
		# read in post method arguments from standard in and save in argsfile
		  read -t ${HARDTIMEOUT:-10} -n ${CONTENT_LENGTH:-0} QUERY_STRING_POST
		  \echo "$QUERY_STRING_POST" > ${WORKDIR}/args
		else
# Get method
		   \echo "$QUERY" | cut -d\  -f 2-  > ${WORKDIR}/args
		   QUERY=$(\echo "$QUERY" | cut -d\  -f 1)
		fi

	DATECMD > ${WORKDIR}/start
	DATECMD > ${WORKDIR}/running
	echo "$$" >${WORKDIR}/pid
	echo "$0 $@">${WORKDIR}/cmd
	echo "${QUERY}">${WORKDIR}/query
	echo "${REMOTE_ADDR}">${WORKDIR}/ipaddress
	echo "${HTTP_COOKIE}">${WORKDIR}/cookie
	echo "${WKPROD}">${WORKDIR}/WKPROD
	echo "${CONTENT_TYPE}">${WORKDIR}/content_type
	env>${WORKDIR}/env



echo "Content-type: application/json"
echo ""

echo "{ \"result\" :"

echo "{"
echo "\"_id\": \"653d86f890f207841bbfe423\","
echo "\"SCRIPT_NAME\": \"$SCRIPT_NAME\","
echo "\"WKSCRIPT\": \"$WKSCRIPT\","
echo "\"POSTDATA\": \"$POSTDATA\","
echo "\"QUERY_STRING\": \"$QUERY_STRING\","
echo "\"QUERY\": \"$QUERY\","
echo "\"CGIBIN\": \"$CGIBIN\","
echo "\"REQUEST_METHOD\": \"$REQUEST_METHOD\","
echo "\"QUERY_STRING_POST\": \"$QUERY_STRING_POST\","
echo "\"HARDTIMEOUT\": \"$HARDTIMEOUT\","
echo "\"ProcessID\": \""$$"\","
echo "\"Command\": \""$0 $@"\","
echo "\"REMOTE_ADDR\": \"${REMOTE_ADDR}\","
echo "\"HTTP_COOKIE\": \"${HTTP_COOKIE}\","
echo "\"directory\": \"${WORKDIR}\""

echo "}}"
