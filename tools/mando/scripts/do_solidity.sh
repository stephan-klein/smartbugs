#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"
MAIN="$4"
OUTPUT_FILE="output.json"
URL="http://localhost:5555/v1.0.0/vulnerability/detection/nodetype"
APIKEY="MqQVfJ6Fq1umZnUI7ZuaycciCjxi3gM0"

# Retry configuration
INITIAL_TIMEOUT=10
RETRIES=20
RETRY_DELAY=2

# Function to handle errors
handle_error() {
  local error_message="$1"
  echo "{\"messages\": \"$error_message\"}" > "$OUTPUT_FILE"
  echo "Error: $error_message" >&2
  exit 1
}

# Remove output file if it exists
rm -f "$OUTPUT_FILE"

# Old phython version
# /app/inference.sh $FILENAME -b reentrancy -t $TIMEOUT

# Run the server
python -m sco --host 0.0.0.0 --port 5555 &

if [ ! -f "$FILENAME" ]; then
  handle_error "File $FILENAME not found!"
fi

# Convert to base64 without line breaks
BASE64_CONTENT=$(base64 -w 0 "$FILENAME")
if [ $? -ne 0 ]; then
  handle_error "Failed to convert file to base64!"
fi

JSON_PAYLOAD="{\"smart_contract\":\"$BASE64_CONTENT\"}"
echo "JSON payload: $JSON_PAYLOAD"

# Send HTTP POST request and save response to output.json
if [ -n "$TIMEOUT" ]; then
  echo "Sending request to ${URL} (timeout: ${TIMEOUT}s, retries: ${RETRIES})..."
  curl -X POST \
    -H "Content-Type: application/json" \
    -H "key: ${APIKEY}" \
    -d "$JSON_PAYLOAD" \
    --connect-timeout $INITIAL_TIMEOUT \
    --max-time $TIMEOUT \
    --retry $RETRIES \
    --retry-delay $RETRY_DELAY \
    --retry-connrefused \
    $URL > "$OUTPUT_FILE"
  
  CURL_EXIT_CODE=$?
  if [ $CURL_EXIT_CODE -eq 28 ]; then
    handle_error "Request timed out after ${TIMEOUT} seconds and ${RETRIES} retry attempts"
  elif [ $CURL_EXIT_CODE -ne 0 ]; then
    handle_error "Failed to send HTTP request to ${URL} (error code: $CURL_EXIT_CODE) after ${RETRIES} retry attempts"
  fi
else
  echo "Sending request to ${URL} (retries: ${RETRIES})..."
  curl -X POST \
    -H "Content-Type: application/json" \
    -H "key: ${APIKEY}" \
    -d "$JSON_PAYLOAD" \
    --connect-timeout $INITIAL_TIMEOUT \
    --retry $RETRIES \
    --retry-delay $RETRY_DELAY \
    --retry-connrefused \
    $URL > "$OUTPUT_FILE"
  
  CURL_EXIT_CODE=$?
  if [ $CURL_EXIT_CODE -ne 0 ]; then
    handle_error "Failed to send HTTP request to ${URL} (error code: $CURL_EXIT_CODE) after ${RETRIES} retry attempts"
  fi
fi

echo "Response saved to $OUTPUT_FILE"
