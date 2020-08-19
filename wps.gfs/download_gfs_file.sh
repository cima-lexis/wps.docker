dataset_date=$1; dataset_hour=$2; filename=$3;

query="file=${filename}&subregion=&${domain}&dir=%2Fgfs.${dataset_date}%2F${dataset_hour}"
echo downloading ${dataset_date}${dataset_hour}/${filename} >&2
curl -sS "${base_url}?${query}" -o ${dataset_date}${dataset_hour}/${filename}.grb
echo ${dataset_date}${dataset_hour}/${filename}
