# Program: DecodingBrainSignals_LineChart_XTime_YElecRaw_GroupPCh.R
#          Draw a Line Chart from MS competition: Decoding Brain Signals
#            (wrote by Training data)
#
#          X is Timing which assume your order is by time,
#          Y is Electrode data
#          Grouping coloring by Patient and Channel u imput.
#
# Programmer : skylikewater - Jheng-Ting Chen
#              justin666666@gmail.com
#
# History:
# 160410 skylikewater - first release
#

DecodingBrainSignals_LineChart_PatientChannel_2_ElecRaw =
  function(Data,
           GraphNeed = c(1),
  	       PatientNeed = c("p1", "p2", "p3", "p4"),
  	       ChannelNeed = c("Electrode_1", "Electrode_33"),
  	       FileFolder) {

  require(ggplot2)

  # Select Data
  DataRowGraphNeed = which(Data$Stimulus_Type %in% as.character(GraphNeed))
  DataRowPatientNeed = which(Data$PatientID %in% PatientNeed)

  DataRowNeed = intersect(DataRowGraphNeed, DataRowPatientNeed)
  DataColNeed = colnames(Data) %in% c("PatientID", "Stimulus_Type", ChannelNeed)
  DataPlot = Data[DataRowNeed, DataColNeed]
  rm(DataRowGraphNeed, DataRowPatientNeed, DataRowNeed, DataColNeed)

  for (ChannelNeedNum in 1:length(ChannelNeed)) {
    ExecTempDataStr = paste("TempData = as.numeric(as.character(DataPlot$", ChannelNeed[ChannelNeedNum], "))",
                            sep = "")
    eval(parse(text = ExecTempDataStr))
    ExecTempPIDElectrodeChStr =
      paste("TempPIDElectrodeCh = rep('", ChannelNeed[ChannelNeedNum], "', length(TempData))",
                                   sep = "")
    eval(parse(text = ExecPIDTempElectrodeChStr))
    rm(ExecTempDataStr, ExecPIDTempElectrodeChStr)
    TempTiming = c(1:length(TempData))
    if (ChannelNeedNum == 1) {
      Electrode = TempData
      PIDElectrodeCh = TempPIDElectrodeCh
      Timing = TempTiming
    } else {
      Electrode = c(Electrode, TempData)
      PIDElectrodeCh = c(PIDElectrodeCh, TempPIDElectrodeCh)
      Timing = c(Timing, TempTiming)
    }
    rm(TempData,TempPIDElectrodeCh, TempTiming)
  }
  rm(ChannelNeedNum)
  DataPlot = data.frame(Electrode = Electrode,
                        ElectrodeCh = ElectrodeCh,
                        Timing = Timing)
  Graph = ggplot(DataPlot, aes(Timing, Electrode, colour = ElectrodeCh))
  Graph = Graph + geom_line()
  ChannelNeedFileNameStr = apply(matrix(gsub("_", replacement = "", ChannelNeed)), 2, paste, collapse = "_")
  ggsave(file = paste(FileFolder, ChannelNeedFileNameStr, "_Image1_Raw.png", sep = ""), Graph)
  rm(ChannelNeed, ChannelNeedFileNameStr)
  rm(Graph)
}