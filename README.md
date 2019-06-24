##Introduction
Cluster Monitor Agent is an internal tool that monitors the cluster resources. It helps the infrastructure team to keep track of the hardware specifications and resource usages of a Linux cluster. It also helps to persist the data in an RDBMS databse.

## Architecture and Design
1) Draw a cluster diagram with three Linux hosts, a DB , and agents
2) tables:
   `host_info` stores the hardware specification information
   `host_usage` stores the resource usages information
3) `host_info.sh` collects the host hardware info and insert it into the database. It will be run only once. `host_usage.sh` collects the current host usage (CPU and MEmory) and then insert into the database. It will be triggered by the crontab job every minute. `init.sql` creates a database and two tables. Run only once.

## Usage
1) How to init database and tables:
   init.sql
2) `host_info.sh` usage: 
   `bash host_info.sh psql_host psql_port db_name psql_user psql_password`
3) `host_usage.sh` usage:
   `bash host_usage.sh psql_host psql_port db_name psql_user psql_password`
4) crontab setup:
   `crontab -e
    ***** bash
    host_usage.sh psql_host psql_port db_name psql_user psql_password > /tmp/host_usage.log`

## Improvements
1) handle hardware update
2) 
3)


