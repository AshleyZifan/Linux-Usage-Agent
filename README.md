## Introduction
Cluster Monitor Agent is an internal tool that monitors the cluster resources. It helps the infrastructure team to keep track of the hardware specifications and resource usages of a Linux cluster. It also helps to persist the data in an RDBMS databse.

## Architecture and Design
1) <mxfile modified="2019-06-24T14:25:16.849Z" host="www.draw.io" agent="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" etag="yW20LxRFKUmTprlhdQEY" version="10.8.0"><diagram id="TIBJpkMNU8xp5p95hWty" name="Page-1">3ZhRd5owGIZ/jZd6CAHES7XddrHueI4XXXuXQQo5i8SFqLBfv2QEMImdbm3V9Uryknzhe96PkDiA81X1kaN1fsdSTAe+l1YDeDPwfeABT/4opW6UMASNkHGS6k69sCQ/cTtSqxuS4tLoKBijgqxNMWFFgRNhaIhztjO7PTFqzrpGGXaEZYKoq96TVOSNGvvjXv+ESZa3M4No0txZobazzqTMUcp2exK8HcA5Z0w0V6tqjqmC13Jpxn145m73YBwX4pQBqJp+vgePX27jGs2Wd8PH7ZAMdZQtohudsH5YUbcEONsUKVZBwADOdjkReLlGibq7k55LLRcrqm/rcJgLXD37nKDLXpYNZisseC276AEw0MB0xcS6uevxg5Zpvoc+0hrSjmdd5B6KvNBc/oKRf32MfIuR710aErw+SEF0bZACB9Ki/KFG3SCBvqES/4GZd57CGh9nNjmADL4VstBBNkNlLpVpplK6OC/7RQxcXuMDvPy34hVdNy/nnbw0r/F187I/ht16dSlescNriblMUWrAoSXzFiaSUnD2Hc8ZZVwqBStkz9kTodSSECVZIZuJ5CSDw5miSOS2bKpvrEiaqmkOemC69CrLYmjacGBTEp7ThnZ7fMgH+H59CCbX5oO7ge58cHdA78YHGJvLUnRpG07Yo+MinaoDoaJIUVmSxLRCps7rr4rRaAKiVniQwtAbgWDcKjeV5ti06v3WAnMiM1IONWJFRBMy1K2HdjZ53UdSjdqwB6fOudQyRybHNjzBxz9uAvEMi2P7UtfsI262GscUCbI1H/eQxXqGBSPqy9q90771ibO3302aetT+AdcKBO1FOrACNRycQL8rrkv7BUV4whnoaBG2BbNXLt7ID89VMdElKwHGloHhv1ZC5BuBnIXnrSvBPei9ZDmKwnh/OQIvWYmAUVhnq6vwf1iJoHU4gXbZnFx/HhyZpQxh9EoVKJv9f4ZN9/6fV3j7Cw==</diagram></mxfile>
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
   `crontab -e
    ***** bash
    host_usage.sh psql_host psql_port db_name psql_user psql_password > /tmp/host_usage.log`

## Improvements
1) handle hardware update
2) expand tables to provide more information
3) provide certain quick sql search


