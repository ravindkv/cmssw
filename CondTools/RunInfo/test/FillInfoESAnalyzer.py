import FWCore.ParameterSet.Config as cms

process = cms.Process("Test")
process.load("CondCore.DBCommon.CondDBCommon_cfi")

#process.CondDBCommon.connect = 'oracle://cms_orcoff_prep/CMS_CONDITIONS'
process.CondDBCommon.connect = 'sqlite_file:test_output.db'
#process.CondDBCommon.connect = 'sqlite_file:fill_info_2016_17.db'
process.CondDBCommon.DBParameters.authenticationPath = '/afs/cern.ch/user/r/rverma/'
#process.CondDBCommon.DBParameters.authenticationPath = '.'

process.maxEvents = cms.untracked.PSet(
  input = cms.untracked.int32(-1)
)


process.source = cms.Source("EmptyIOVSource",
    timetype = cms.string('timestamp'),
    firstValue = cms.uint64(6477277751951493408),
    #firstValue = cms.uint64(6477060826480649336),
    lastValue = cms.uint64(6477277751951493408),
    interval = cms.uint64(6477277751951493408)
)


process.rn = cms.ESSource("PoolDBESSource",
    process.CondDBCommon,
    timetype = cms.string('timestamp'),
    toGet = cms.VPSet(cms.PSet(
        record = cms.string('FillInfoRcd'),
        tag = cms.string('fillinfo_test')
    ))
)


process.get = cms.EDAnalyzer("EventSetupRecordDataGetter",
    toGet = cms.VPSet(cms.PSet(
        record = cms.string('FillInfoRcd'),
        data = cms.vstring('fillinfo_test')
    )),
    verbose = cms.untracked.bool(True)
)

process.prod = cms.EDAnalyzer("FillInfoESAnalyzer")

process.asciiprint = cms.OutputModule("AsciiOutputModule")

process.p = cms.Path(process.prod)
process.ep = cms.EndPath(process.asciiprint)
