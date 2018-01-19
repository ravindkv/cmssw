
#####################################
# Basic setup at lxplus using acron
#####################################
# Ref: http://information-technology.web.cern.ch/services/fe/afs/howto/authenticate-processes
# (a) kinit
# (b) acrontab -e
# (c) chmod +x FillInfoUpdate.sh

# The acrontab acript will look like:
# */1 * * * * lxplus049 $PATH/FillInfoUpdate.sh > $PATH/cron_log.txt
# Ref: https://raw.githubusercontent.com/cms-sw/cmssw/09c3fce6626f70fd04223e7dacebf0b485f73f54/RecoVertex/BeamSpotProducer/scripts/READMEMegascript.txt


# SHELL SCRIPT TO BE RUN BY ACRON
# Ref: https://github.com/cms-sw/cmssw/blob/09c3fce6626f70fd04223e7dacebf0b485f73f54/CondTools/Ecal/python/updateO2O.sh

#-------------------------------------
# Setup CMSSW area and log files
#-------------------------------------
RELEASE=CMSSW_8_0_20
RELEASE_DIR=/afs/cern.ch/work/r/rverma/private/o2o/
DIR=/afs/cern.ch/work/r/rverma/private/o2o/CMSSW_8_0_20/src/CondTools/RunInfo/test
LOGFILE=${DIR}/FillInfoTriggerO2O.log
DATEFILE=${DIR}/FillInfoTriggerO2ODate.log
DATE=`date --utc`
OUTFILE="/afs/cern.ch/work/r/rverma/private/o2o/CMSSW_8_0_20/src/CondTools/RunInfo/test/o2oUpdate_$$.txt"
pushd $RELEASE_DIR/$RELEASE/src/
#@R#export SCRAM_ARCH=slc6_amd64_gcc493
source /cvmfs/cms.cern.ch/cmsset_default.sh
eval `scramv1 runtime -sh` 

#-------------------------------------
# Define functions
#-------------------------------------
function log() {
    echo "[`date`] : $@ " | tee -a $OUTFILE
}
function submit() {
    log $@
     $@ | tee -a -a $OUTFILE
}

#-------------------------------------
# Get previous triggering date
#-------------------------------------
log "-----------------------------------------------------------------------"
echo "--------: FillInfo O2O was triggered at :-------- " | tee -a $LOGFILE
echo "$DATE" | tee -a $LOGFILE
LOGDATE=`cat $DATEFILE | awk 'NR ==1 {print $0}'`
TMSLOGDATE=`date --utc -d "$LOGDATE" +%s`
echo "timestamp for the log (last log)" $TMSLOGDATE "corresponding to date" | tee -a $LOGFILE
echo $LOGDATE | tee -a $LOGFILE
rm -f $DATEFILE
echo $DATE > $DATEFILE
pushd $DIR


#-------------------------------------
# Run FillInfoPopConAnalyzer.py 
#-------------------------------------
submit cmsRun FillInfoPopConAnalyzer.py       
log DONE
exit 0 
