#!/bin/sh -x

# © Copyright 2012 Altair Engineering, Inc.  All rights reserved.
# This code is provided Òas isÓ without any warranty, express or implied, or
# indemnification of any kind.  All other terms and conditions are as
# specified in the Altair PBS EULA.

# Assumption:

# Purpose:

exec >/tmp/checkpoint_abort.debug 2>&1

#
CHECKPOINTPATH=$1
if [ ! -d ${CHECKPOINTPATH} ]; then
  mkdir -p ${CHECKPOINTPATH} || exit 1
fi

# Source in PBS specific environment variables from pbs.conf
PBS_CONF=${PBS_CONF:-/etc/pbs.conf}
[ -f ${PBS_CONF} ] && . ${PBS_CONF}

#
JOB_JB=${PBS_HOME}/mom_priv/jobs/${PBS_JOBID}.JB
JOB_SC=${PBS_HOME}/mom_priv/jobs/${PBS_JOBID}.SC
PIDS=`ps --sid ${PBS_SID} -o pid=`

#
cp ${JOB_SC} ${CHECKPOINTPATH}/${PBS_JOBID}.SC
kill -SIGTSTP ${PIDS}
sleep 1
cp ${PBS_JOBDIR}/${PBS_JOBID}_data.chk ${CHECKPOINTPATH}
kill -15 ${PIDS}
