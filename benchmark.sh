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

    echo "  {\"iteration\": $i, \"query\": \"$QUERY\", \"duration_ms\": $DURATION}," >>"$OUTPUT_FILE"
  done
done <"$QUERY_FILE"

sed -i '$ s/,$//' "$OUTPUT_FILE"
echo "]" >>"$OUTPUT_FILE"
echo "All done! results saved to: $OUTPUT_FILE"
