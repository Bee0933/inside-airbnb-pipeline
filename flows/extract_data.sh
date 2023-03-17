#!/bin/bash

# "http://data.insideairbnb.com/the-netherlands/north-holland/amsterdam/2022-12-05/data/listings.csv.gz"

set -e

YEAR=$1
MONTHS_AVAILABLE=$2
DATA_TABLES=$3
CITY="amsterdam"

BASE_URL="http://data.insideairbnb.com/the-netherlands/north-holland/amsterdam"

for MONTH in $MONTHS_AVAILABLE; do
    echo "extracting data for $MONTH ..."
    for TABLE in $DATA_TABLES; do
        
        URL="${BASE_URL}/${YEAR}-${MONTH}/data/${TABLE}.csv.gz"
        
        LOCAL_DIR="../data/raw/${CITY}/${TABLE}/${YEAR}-${MONTH}"
        LOCAL_FILE="${CITY}_${TABLE}_${YEAR}_${MONTH}.csv.gz"
        LOCAL_PATH="${LOCAL_DIR}/${LOCAL_FILE}"
        
        echo "downloading ${URL} to ${LOCAL_PATH}"
        mkdir -p ${LOCAL_DIR}
        wget ${URL} -O ${LOCAL_PATH}

        # gunzip ${LOCAL_PATH}
    done
done
