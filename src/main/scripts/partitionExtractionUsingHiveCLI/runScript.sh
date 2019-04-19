#!/bin/sh
MYSELF="$(realpath "$0")"
MYDIR="${MYSELF%/*}"

echo "------------------------"
echo "Running Script = $MYSELF"
echo "Current Directory = $MYDIR"
echo "------------------------"


fileItemString=$(cat $MYDIR/tableInput.txt |tr "\n" " ")
TABLE=($fileItemString)


i=0
temp_result="$(mktemp /tmp/PartitionResult.XXXXXX)"
temp_in_hive="$(mktemp /tmp/Partition_SQL.XXXXXX)"
temp_in="$(mktemp /tmp/Partition_DDL.XXXXXX)"
temp_out="$(mktemp /tmp/Location_OUT.XXXXXX)"

for item in ${TABLE[@]}; do
        hive -e "show partitions ${TABLE[$i]};" | sed -e "s/=/='/g" -e "s/$/'/g" -e "s/\//',/g" | while read var; do
                        echo "describe formatted ${TABLE[$i]} partition($var);" >> "${temp_in_hive}"
                        echo "alter table ${TABLE[$i]} drop if exists partition ($var); alter table ${TABLE[$i]} add partition ($var) location " >> "${temp_in}"
                done >> "${temp_in}"
        let "i+=1"
done

hive -f "${temp_in_hive}" | grep Location: | awk '{print $2}' >> "${temp_out}"
paste -d\' "${temp_in}" "${temp_out}" >> "${temp_result}"
sed -i 's/$/'"';"'/' "${temp_result}"
rm "${temp_in}"
rm "${temp_in_hive}"
rm "${temp_out}"
echo ${temp_result}
