## Introduction
Cluster Monitor Agent is an internal tool that monitors the cluster resources. It helps the infrastructure team to keep track of the hardware specifications and resource usages of a Linux cluster. It also helps to persist the data in an RDBMS databse.

## Architecture and Design
1) 
<img src="linux sql arch diagram.jpg">
2) Tables:
   `host_info` stores the hardware specification information
   `host_usage` stores the resource usages information
3) `host_info.sh` collects the host hardware info and insert it into the database. It will be run only once. `host_usage.sh` collects the current host usage (CPU and MEmory) and then insert into the database. It will be triggered by the crontab job every minute. `init.sql` creates a database and two tables. Run only once.

## Usage
1) How to init database and tables: Instead of running SQL statement in REPL, you can use psql CLI client to execute sql files as `psql -h localhost -U postgres -W host_agent -f init.sql`
2) `host_info.sh` usage: 
   `bash host_info.sh psql_host psql_port db_name psql_user psql_password`
3) `host_usage.sh` usage:
   `bash host_usage.sh psql_host psql_port db_name psql_user psql_password`
4) crontab setup:
`* * * * * /home/centos/dev/jrvs/bootcamp/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log` 

## Improvements
1) handle hardware update
2) expand tables to provide more information
3) provide certain quick sql search


