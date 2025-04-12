#!/bin/bash

HOST="localhost"
PORT="5432"
DB="postgres"
USER="postgres"
PASSWORD=""
ITERATIONS=10
QUERY_FILE="queries.sql"
OUTPUT_FILE="results.json"

while getopts ":h:p:d:u:P:i:f:o:" opt; do
  case $opt in
  h) HOST="$OPTARG" ;;
  p) PORT="$OPTARG" ;;
  d) DB="$OPTARG" ;;
  u) USER="$OPTARG" ;;
  P) PASSWORD="$OPTARG" ;;
  i) ITERATIONS="$OPTARG" ;;
  f) QUERY_FILE="$OPTARG" ;;
  o) OUTPUT_FILE="$OPTARG" ;;
  \?)
    echo "Wrong param."
    exit 1
    ;;
  esac
done

if [ -z "$PASSWORD" ]; then
  echo "ERROR! Password is required."
  exit 1
fi

echo "[" >"$OUTPUT_FILE"

first_query=true
while IFS= read -r QUERY; do
  if [[ -z "$QUERY" || "$QUERY" == \#* ]]; then
    continue
  fi

  echo "Testing query: $QUERY"

  for i in $(seq 1 $ITERATIONS); do
    START=$(date +%s%3N)
    PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -d $DB -U $USER -c "$QUERY" >/dev/null 2>&1
    END=$(date +%s%3N)
    DURATION=$(echo "$END - $START" | bc)

    if $first_query; then
      first_query=false
    else
      echo "," >>"$OUTPUT_FILE"
    fi
    echo "  {\"iteration\": $i, \"query\": \"$QUERY\", \"duration_ms\": $DURATION}" >>"$OUTPUT_FILE"
  done
done <"$QUERY_FILE"

echo "]" >>"$OUTPUT_FILE"

jq . "$OUTPUT_FILE" >"${OUTPUT_FILE}.tmp" && mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"

echo "All done! Results saved to: $OUTPUT_FILE"
