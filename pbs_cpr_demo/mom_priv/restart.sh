#!/bin/sh -x

# © Copyright 2012 Altair Engineering, Inc.  All rights reserved.
# This code is provided Òas isÓ without any warranty, express or implied, or
# indemnification of any kind.  All other terms and conditions are as
# specified in the Altair PBS EULA.

# Assumption:

# Purpose:

exec > /tmp/restart.debug 2>&1

#
env | sort

#
CHECKPOINTPATH=$1

# Source in PBS specific environment variables from pbs.conf
PBS_CONF=${PBS_CONF:-/etc/pbs.conf}
[ -f ${PBS_CONF} ] && . ${PBS_CONF}

#
if [ -f ${PBS_HOME}/spool/${PBS_JOBID}.OU ] ; then
   JOB_OU=${PBS_HOME}/spool/${PBS_JOBID}.OU
   JOB_ER=${PBS_HOME}/spool/${PBS_JOBID}.ER
else
   JOB_OU=${PBS_JOBDIR}/${PBS_JOBID}.OU
   JOB_ER=${PBS_JOBDIR}/${PBS_JOBID}.ER
fi

#
ls -l ${CHECKPOINTPATH}/

#
cp ${CHECKPOINTPATH}/${PBS_JOBID}.SC ${PBS_JOBDIR}/${PBS_JOBID}.SC
cp ${CHECKPOINTPATH}/${PBS_JOBID}_data.chk ${PBS_JOBDIR}/${PBS_JOBID}_data.chk
cd ${PBS_JOBDIR}
chown ${USER} ${PBS_JOBID}.SC ${PBS_JOBID}_data.chk
chmod u+x ${PBS_JOBID}.SC

# For SLES OS, perhaps a version of su?
su ${USER} -c "${PBS_JOBDIR}/${PBS_JOBID}.SC ${PBS_JOBID}_data.chk" >>${JOB_OU} 2>>${JOB_ER}

# For RHEL OS, perhaps a version of su?
#su ${USER} --session-command "${PBS_JOBDIR}/${PBS_JOBID}.SC ${PBS_JOBID}_data.chk" >>${JOB_OU} 2>>${JOB_ER}
