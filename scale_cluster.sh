#! /bin/sh
# Copyright (c) 2011-2015 by Vertica, an HP Company.  All rights reserved.
# Update autoscaling group based on current min, max, desired settings in the
# config file (autoscaling_vars.sh)

. ./autoscaling_vars.sh

function show_help {
   echo "$0 [-s <desired_node_count>]"
   exit 0
}

while getopts "h?S:s:" opt; do
   case "$opt" in
   h|\?)
      show_help
      exit 0
      ;;
   S|s)
      desired="$OPTARG"
      ;;
   esac
done

cat <<EOF
Configuring Autoscaling Group: $autoscaling_group_name
Setting
 - min instances: 	$min
 - max instances: 	$max
 - desired instances:	$desired
EOF

aws autoscaling update-auto-scaling-group --auto-scaling-group-name $autoscaling_group_name --min-size=$min --max-size=$max --desired-capacity=$desired

if [ $? -ne 0 ]; then
  echo "Failed to update auto scaling group"
  exit 1
fi

echo "Done"
exit 0

