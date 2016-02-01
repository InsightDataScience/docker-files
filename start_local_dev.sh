#!/bin/bash

check_variables_and_folders () {
  if [ -z ${INSIGHT_DATABASE_PATH} ]; then
    echo "Please set the insight_database repo path."
    exit 1
  elif [ ! -d ${INSIGHT_DATABASE_PATH} ]; then
    echo "${INSIGHT_DATABASE_PATH} does not exist"
    exit 1
  fi

  if [ -z ${INSIGHT_TRELLO_PATH} ]; then
    echo "Please set the trello-py repo path."
    exit 1
  elif [ ! -d ${INSIGHT_TRELLO_PATH} ]; then
    echo "${INSIGHT_TRELLO_PATH} does not exist"
    exit 1
  fi

  if [ -z ${INSIGHT_ADMISSIONS_PATH} ]; then
    echo "Please set the insight_admissions repo path."
    exit 1
  elif [ ! -d ${INSIGHT_ADMISSIONS_PATH} ]; then
    echo "${INSIGHT_ADMISSIONS_PATH} does not exist"
    exit 1
  fi

  if [ -z ${INSIGHT_UTILS_PATH} ]; then
    echo "Please set the insight_utils repo path."
    exit 1
  elif [ ! -d ${INSIGHT_UTILS_PATH} ]; then
    echo "${INSIGHT_UTILS_PATH} does not exist"
    exit 1
  fi

  if [ -z ${INSIGHT_KEYS_PATH} ]; then
    echo "Please set the .insight_keys path."
    exit 1
  elif [ ! -d ${INSIGHT_KEYS_PATH} ]; then
    echo "${INSIGHT_KEYS_PATH} does not exist"
    exit 1
  fi

  if [ -z ${INSIGHT_CREDENTIALS_PATH} ]; then
    echo "Please set the .insight_credentials path."
    exit 1
  elif [ ! -d ${INSIGHT_CREDENTIALS_PATH} ]; then
    echo "${INSIGHT_CREDENTIALS_PATH} does not exist"
    exit 1
  fi
}

RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'

check_variables_and_folders

echo "removing insight_db container..."
docker stop insight_db > /dev/null
docker rm insight_db > /dev/null

echo "removing pgweb container..."
docker stop pgweb > /dev/null
docker rm pgweb > /dev/null

echo "removing psql container..."
docker stop psql > /dev/null
docker rm psql > /dev/null

echo "removing postgres container..."
docker stop pserver > /dev/null
docker rm pserver > /dev/null

echo "removing postgres persistent storage..."
docker rm -v dbdata > /dev/null

echo "creating a new postgres persistent storage..."
docker create -v /var/lib/postgresql/data --name dbdata postgres /bin/true > /dev/null

echo "starting the Postgres server container..."
docker run -d --volumes-from dbdata --name pserver postgres > /dev/null

echo -e "\n${RED}You are in the Postgres Client container.${NC} Press ${BLU}CTRL-P${NC} then ${BLU}CTRL-Q${NC} to continue..."
docker run -it --link pserver:psql --name psql psql

echo -e "\n\n${RED}RUN ${NC}python3 run_admissions_etl.py and then ${BLU}CTRL-C${NC} to continue ..."
docker run -it --rm --name insight_db --link pserver:insight_db \
           -v ${INSIGHT_DATABASE_PATH}:/usr/local/lib/python3.4/dist-packages/insight_database:ro \
           -v ${INSIGHT_TRELLO_PATH}:/usr/local/lib/python3.4/dist-packages/trello/:ro \
           -v ${INSIGHT_ADMISSIONS_PATH}:/usr/local/lib/python3.4/dist-packages/InsightAdmissions/:ro \
           -v ${INSIGHT_UTILS_PATH}:/usr/local/lib/python3.4/dist-packages/insight_utils/:ro \
           -v ${INSIGHT_KEYS_PATH}:/root/.insight_keys \
           -v ${INSIGHT_CREDENTIALS_PATH}:/root/.insight_credentials \
           --env PGRES_DB=insight \
           --env PGRES_HOST=172.17.0.2 \
           --env PGRES_USER=postgres \
           --env PGRES_PASSWORD=mysecretpassword \
           insight_database

echo "starting the pgweb container..."
docker run -d -p 8081:8081 \
           -e DATABASE_URL=postgres://postgres:mysecretpassword@172.17.0.2:5432/insight?sslmode=disable \
           --link pserver:pgweb \
           --name pgweb pgweb > /dev/null


