SELECT cpu_number, id as host_id, total_mem from host_info
GROUP BY id
ORDER BY total_mem DESC;

SELECT host_info.id as host_id, host_info.hostname, host_info.total_mem as total_memory, AVG(host_info.total_mem - host_usage.memory_free) as used_memory_percentage, (date_trunc('hour', host_usage."timestamp") + date_part('minute',host_usage."timestamp")::int / 5 * interval '5 min') as _5min_timestamp
FROM host_info
INNER JOIN host_usage ON host_info.id = host_usage.host_id 
GROUP BY _5min_timestamp, id;
