#!/bin/sh
#PBS -N cpr_test
#PBS -W sandbox=PRIVATE
#PBS -c w=1

# © Copyright 2012 Altair Engineering, Inc.  All rights reserved.
# This code is provided Òas isÓ without any warranty, express or implied, or
# indemnification of any kind.  All other terms and conditions are as
# specified in the Altair PBS EULA.

# Assumption:

# Purpose:

#
write_restart_file() {
        echo `date` Writing restart file...
        echo $number > ${PBS_JOBID}_data.chk
}

#
if [ -n "$1" ]; then
        number=`cat $1`
        echo `date` Restarting from $number...
else
        number=0
fi

#
trap write_restart_file 20

#
while [ $number -lt 500 ]; do
        echo $number ...
        sleep 1
        number=$(( $number + 1 ))
done
