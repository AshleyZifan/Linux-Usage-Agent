SELECT cpu_number, host_id, total_mem from host_info
GROUP BY cpu_number
ORDER BY total_mem DESC

SELECT host_info.host_id, host_info.host_name, host_info.total_mem as total_memory, AVG(host_info.total_mem - host_usage.memory_free) as used_memory_percentage, (date_trunc('hour', timestamp) + date_part('minute', timestamp)::int / 5 * interval '5 min') as 5_min_timestamp
FROM host_info
INNER JOIN host_usage ON host_info.timestamp = host_usage.timestamp 
GROUP BY 5_min_timestamp
