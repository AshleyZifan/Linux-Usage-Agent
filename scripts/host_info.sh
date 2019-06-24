#!/bin/bash

psql_host=$1
port=$2
db_name=$3
user_name=$4 
password=$5

lscpu_out=`lscpu`

get_hostname(){
  hostname=$(hostname -f)
}

get_cpu_number(){
  cpu_number=$(echo "$lscpu_out" | egrep "^CPU\(s\)::" | awk '{print $2}' | xargs)
}

#Helper function
get_lscpu_value(){
  pattern=$1
  value=$(echo "lscpu_out" | egrep "$pattern" | awk -F':' '{print $2}' | xargs)
  echo "value=$value"
}

get_cpu_architecture(){
  get_lscpu_value "Architecture"
  cpu_architecture=$value
}

get_cpu_model(){
  get_lscpu_value "Model name:"
  cpu_model=$value
}

get_cpu_mhz(){
  get_lscpu_value "CPU MHz:"
  cpu_nhz=$value
}

get_L2_cache(){
  get_lscpu_value "L2 cache:"
  L2_cache=$(echo $value | sed s'/K//')
}

#Step 1
get_host_name
get_cpu_number
get_cpu_architecture
get_cpu_model
get_cpu_mhz
get_L2_cache
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

#Step 2
insert_stmt=$(cat <<-END
INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, "timestamp") VALUES('${hostname}', ${cpu_number},'${cpu_architecture}','${cpu_model}',${cpu_mhz},${L2_cache},${total_mem},'${timestamp}');
END
)
echo $insert_stmt

#Step 3
export PGPASSWORD=$password
psql -h $psql_host -p $port -U $user_name -d $dbname -c "$insert_stmt"
sleep 1

#Step 4
host_id=`psql -h localhost -U postgres host_gent -c "select id from host_info where hostname='${hostname}'" | tail -3 | head -1 | xargs`
echo $host_id > ~/host_id
cat ~/host_id
