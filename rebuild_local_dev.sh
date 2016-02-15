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

  if [ -z ${WUFOO_API_KEY} ]; then
    echo "Please set the WUFOO_API_KEY in your .bash_profile."
    exit 1
  fi
}

remove_container () {
  CONTAINER_ID=$(docker ps -aq --filter name=$1)
  if [ ! -z "$CONTAINER_ID" ]; then
    docker stop $1 > /dev/null
    docker rm $1 > /dev/null
  fi
}

check_image_exists () {
  docker images -q $1
}

RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'

check_variables_and_folders

echo "removing insight_database container..."
remove_container insight_database

echo "removing pgweb container..."
remove_container pgweb

echo "removing psql container..."
remove_container psql

echo "removing postgres container..."
remove_container postgres

echo "removing postgres persistent storage..."
CONTAINER_ID=$(docker ps -aq --filter name=dbdata --filter status=created)
if [ ! -z "$CONTAINER_ID" ]; then
  docker rm -v dbdata > /dev/null
fi

echo "creating a new postgres persistent storage..."
docker create -v /var/lib/postgresql/data --name dbdata postgres /bin/true > /dev/null

echo "starting the Postgres server container..."
IMAGE_ID=$(check_image_exists postgres)
if [ ! -z "$IMAGE_ID" ]; then
  docker run -d --volumes-from dbdata --name postgres postgres > /dev/null
else
  echo -e "postgres image does not exist! ${RED}Please run ${NC}docker pull postgres"
  exit 1
fi

IMAGE_ID=$(check_image_exists psql)
if [ ! -z "$IMAGE_ID" ]; then
  echo -e "\n${RED}You are in the Postgres Client container.${NC}"
  echo -e "Press ${BLU}CTRL-P${NC} then ${BLU}CTRL-Q${NC} to continue..."
  docker run -it --link postgres:psql --name psql psql
else
  echo "psql image does not exist! Please build it from docker_files repo"
  exit 1
fi

IMAGE_ID=$(check_image_exists pgweb)
if [ ! -z "$IMAGE_ID" ]; then
  echo "starting the pgweb container..."
  docker run -d -p 8081:8081 \
             -e DATABASE_URL=postgres://${PGRES_USER}:${PGRES_PASSWORD}@${PGRES_HOST}:5432/${PGRES_DB}?sslmode=disable \
             --link postgres:pgweb \
             --name pgweb pgweb > /dev/null
else
  echo "pgweb image does not exist! ${RED}Please build it from ${NC}https://github.com/sosedoff/pgweb.git ${RED}repo${NC}"
  exit 1
fi

IMAGE_ID=$(check_image_exists insight_database)
if [ ! -z "$IMAGE_ID" ]; then
  echo -e "\n\ncd into /usr/local/lib/Python3.4/dist-packages/insight_database"
  echo -e "${RED}RUN ${NC}python3 run_admissions_etl.py and then ${BLU}CTRL-D${NC} to continue ..."
  bash ${INSIGHT_DATABASE_PATH}/run_insight_database.sh
else
  echo "insight_database image does not exist! ${RED}Please build it from ${NC}insight_database ${RED}repo${NC}"
  exit 1
fi

