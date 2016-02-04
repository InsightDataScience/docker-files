# docker_files

Base Dockerfiles

modify your ~/.bash_profile so it holds environment variables to paths of the Insight repositories
```bash
export INSIGHT_DATABASE_PATH=/path/to/insight_database
export INSIGHT_TRELLO_PATH=/path/to/trello-py
export INSIGHT_ADMISSIONS_PATH=/path/to/InsightAdmissions
export INSIGHT_UTILS_PATH=/path/to/insight_utils
export INSIGHT_KEYS_PATH=/path/to/.insight_keys
export INSIGHT_CREDENTIALS_PATH=/path/to/.insight_credentials
export PGRES_DB=insight
export PGRES_HOST=172.17.0.2
export PGRES_USER=postgres
export PGRES_PASSWORD=mysecretpassword
```
