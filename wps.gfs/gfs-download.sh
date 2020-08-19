export base_url="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl"
export domain="leftlon=-18&rightlon=48&toplat=66&bottomlat=23"

enqueue_gfs_file() {
	printf "$1 $2 $3\n" >> curl_queue
}

enqueue_gfs_dataset() {
	dataset_date=$1; dataset_hour=$2; tot_hours=$3

	mkdir -p ${dataset_date}${dataset_hour}

	filename=gfs.t${dataset_hour}z.pgrb2.0p25.anl
	enqueue_gfs_file $dataset_date $dataset_hour $filename
	
	for hour in `seq 0 $tot_hours`
	do
    	hour=`printf "%03d" $hour`
        filename=gfs.t${dataset_hour}z.pgrb2.0p25.f${hour}
		enqueue_gfs_file $dataset_date $dataset_hour $filename
	done
}

start_download_queue() {
	cat curl_queue | xargs -n 3 -P 10 bash download_gfs_file.sh
	echo DONE
}

wrf_run_date=20200716
wrf_run_hour=06

warmup_1_dt=`date '+%Y%m%d' -d "${wrf_run_date}-2 day"`
warmup_2_dt=`date '+%Y%m%d' -d "${wrf_run_date}-1 day"`
tot_hours=24

echo > curl_queue

enqueue_gfs_dataset $warmup_1_dt $wrf_run_hour 24
enqueue_gfs_dataset $warmup_2_dt $wrf_run_hour 24
enqueue_gfs_dataset $wrf_run_date $wrf_run_hour 48

start_download_queue
