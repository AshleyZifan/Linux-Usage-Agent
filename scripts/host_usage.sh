#!/bin/bash

#Setup arguments
psql_host=$1
port=$2
db_name=$3
user_name=$4
password=$5

get_memory_free(){
memory_free_kb=$(cat /proc/meminfo | egrep "MemFree" | awk -F':' '{print $2}' | xargs | cut -f1 -d' ')
memory_free=$(($memory_free_kb * 0.001))
}

get_cpu_idel(){
cpu_idel=$(vmstat | awk '{for(i=NF;i>0;i--)if($i=="id"){x=i;break}}END{print $x}')
}

get_cpu_kernel(){
cpu_kernel=$(vmstat | awk '{for(i=NF;i>0;i--)if($i=="sy"){x=i;break}}END{print $x}')
}

get_disk_io(){
disk_io=$(vmstat -d | awk '{for(i=NF;i>0;i--)if($i=="cur"){x=i;break}}END{print $x}')
}

get_disk_available(){
disk_available=$(df -BM ~ | awk '{for(i=NF;i>0;i--)if($i=="Available"){x=i;break}}END{print $x}' | sed s'/M//')
}

#Step 1
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
get_memory_free
get_cpu_idel
get_cpu_kernel
get_disk_io
get_disk_available

#Step 2
insert_stmt=$(cat <<-END
INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idel, cpu_kernel, disk_io, disk_available) VALUES('${timestamp}',$(cat host_id), ${memory_free}, ${cpu_idel}, ${cpu_kernel}, ${disk_io},${disk_available});
END
)
echo $insert_stmt

#Step 3
export PGPASSWORD=$password
psql -h $psql_host -p $port -U $user_name -d $db_name -c "$insert_stmt"
sleep1

