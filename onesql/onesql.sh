#!/bin/sh

getval() {
	/usr/local/onesql5632/bin/mysql -u root -proot123 \
		-e "show status like 'oneagent_$1%'\G" \
		2>>/dev/null | \
		grep Value | \
		awk -F: 'BEGIN{ORS=","}{print $2}' | \
		sed -s "s/,$//g"
}

getval_ex() {
	/usr/local/onesql5632/bin/mysql -u root -proot123 \
		-e "show status where Variable_name='$1'\G" \
		2>>/tmp/errorlog | \
		grep Value | \
		awk -F: 'BEGIN{ORS=","}{print $2}' | \
		sed -s "s/,$//g"
}

# Get Queries per Second
questions=`getval_ex questions`
uptime=`getval_ex uptime`
#echo "questions=$questions"
#echo "uptime=$uptime"
qps=`echo "scale=2;$questions/$uptime" | bc`
#echo "qps=$qps"

result=$qps

# Get TPS
com_commit=`getval_ex com_commit`
com_rollback=`getval_ex com_rollback`
uptime=`getval_ex uptime`
#echo "com_commit=$com_commit"
#echo "com_rollback=$com_rollback"
#echo "uptime=$uptime"
tps=`echo "scale=2;($com_commit+$com_rollback)/$uptime" | bc`
#echo "tps=$tps"

result="$result,$tps"

# Get Read Ratio
qcache_hits=`getval_ex qcache_hits`
com_select=`getval_ex com_select`
com_insert=`getval_ex com_insert`
com_update=`getval_ex com_update`
com_delete=`getval_ex com_delete`
com_replace=`getval_ex com_replace`
#echo "qcache_hits=$qcache_hits"
#echo "com_select=$com_select"
#echo "com_insert=$com_insert"
#echo "com_update=$com_update"
#echo "com_delete=$com_delete"
#echo "com_replace=$com_replace"
total=`echo "$com_select+$qcache_hits+$com_insert+$com_update+$com_delete+$com_replace" | bc`
if [ $total == 0 ]
then
	read_ratio=0
else
	read_ratio=`echo "scale=2;($com_select+$qcache_hits)/$total*100" | bc`
fi
#echo "read_ratio=$read_ratio"

result="$result,$read_ratio"

# Get Innodb Buffer Read Hits
innodb_buffer_pool_reads=`getval_ex innodb_buffer_pool_reads`
innodb_buffer_pool_read_requests=`getval_ex innodb_buffer_pool_read_requests`
#echo "innodb_buffer_pool_reads=$innodb_buffer_pool_reads"
#echo "innodb_buffer_pool_read_requests=$innodb_buffer_pool_read_requests"
if [ $innodb_buffer_pool_read_requests == 0 ]
then
	innodb_buffer_rd_hits=0
else
	innodb_buffer_rd_hits=`echo "scale=2;(1-$innodb_buffer_pool_reads/$innodb_buffer_pool_read_requests)*100" | bc`
fi
#echo "innodb_buffer_rd_hits=$innodb_buffer_rd_hits"

result="$result,$innodb_buffer_rd_hits"

# Get MyISAM Index Read Hits
key_reads=`getval_ex key_reads`
key_read_requests=`getval_ex key_read_requests`
#echo "key_reads=$key_reads"
#echo "key_read_requests=$key_read_requests"
if [ $key_read_requests == 0 ]
then
	key_buf_rd_hits=0
else
	key_buf_rd_hits=`echo "scale=2;(1-$key_reads/$key_read_requests)*100" | bc`
fi
#echo "key_buf_rd_hits=$key_buf_rd_hits"

result="$result,$key_buf_rd_hits"

# Get MyISAM Index Write Hits
key_writes=`getval_ex key_writes`
key_write_requests=`getval_ex key_write_requests`
#echo "key_writes=$key_writes"
#echo "key_write_requests=$key_write_requests"
if [ $key_write_requests == 0 ]
then
	key_buf_wr_hits=0
else
	key_buf_wr_hits=`echo "scale=2;(1-$key_writes/$key_write_requests)*100" | bc`
fi
#echo "key_buf_wr_hits=$key_buf_wr_hits"

result="$result,$key_buf_wr_hits"

# Get Query Cache Hits
qcache_hits=`getval_ex qcache_hits`
qcache_inserts=`getval_ex qcache_inserts`
#echo "qcache_hits=$qcache_hits"
#echo "qcache_inserts=$qcache_inserts"
total=`echo "$qcache_hits+$qcache_inserts" | bc`
if [ $total == 0 ]
then
	query_cache_hits=0
else
	query_cache_hits=`echo "scale=2;$qcache_hits/$total*100" | bc`
fi
#echo "query_cache_hits=$query_cache_hits"

result="$result,$query_cache_hits"

# Get Thread Cache Hits
threads_created=`getval_ex threads_created`
connections=`getval_ex connections`
#echo "threads_created=$threads_created"
#echo "connections=$connections"
if [ $connections == 0 ]
then
	thread_cache_hits=0
else
	thread_cache_hits=`echo "scale=2;(1-$threads_created/$connections)*100" | bc`
fi
#echo "thread_cache_hits=$thread_cache_hits"

result="$result,$thread_cache_hits"

# Get Innodb Row Lock Waits
innodb_row_lock_waits=`getval_ex innodb_row_lock_waits | sed -s "s/^ //g"`
#echo "innodb_row_lock_waits=$innodb_row_lock_waits"

result="$result,$innodb_row_lock_waits"

echo "$result"


