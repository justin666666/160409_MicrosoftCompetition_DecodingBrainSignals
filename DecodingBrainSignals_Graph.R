# Program: DecodingBrainSignals_Graph.R
#          Draw a Line Chart from MS competition: Decoding Brain Signals
#            (wrote by Training data)
#
#          X is Timing which assume your order is by time,
#          Y is Electrode data
#          Grouping coloring by Patient and Channel u imput.
#
#          GraphMerge and PatientMerge is for
#          if you wanna merge all graph/subject Electrode together,
#          you can set it TRUE. But WHY ~ ?
#
# Programmer : skylikewater - Jheng-Ting Chen
#              justin666666@gmail.com
#
# History:
# 160410 skylikewater - first release
# 160420 skylikewater - finish:
#   add LoadData, Filename, DataSelect, DataRearrange,
#   extention basic function to Graph,
#   lower LineChart_XTime_YElecRaw_GroupPCh to subfunction.
#   And copy previous work: InstallPackagesIfNot.
#

# if you need DecodingBrainSignals_LoadData() to load csv,
# set FileFolder first.

DecodingBrainSignals_LoadData = function(FileFolder) {
  DataPath = file.path(paste(FileFolder, "ecog_train_with_labels.csv", sep = ""))
  Data = read.csv(DataPath)

  return(Data)
}

####################################

DecodingBrainSignals_Graph =
  function(Data = DecodingBrainSignals_LoadData(FileFolder),
           GraphNeed = c(1),
           GraphMerge = FALSE,
           PatientNeed = c("p1", "p2", "p3", "p4"),
           PatientMerge = FALSE,
           ChannelNeed = c("Electrode_1", "Electrode_33"),
           OutputFolder) {

  # set filename
  FilenameOuput = DecodingBrainSignals_Filename(
                    GraphNeed, GraphMerge,
                    PatientNeed, PatientMerge,
                    ChannelNeed, OutputFolder)
  Filename = FilenameOuput$Filename
  # trans variable for grid check use.
  GridCheck = (FilenameOuput$GraphNum)*(FilenameOuput$PatientNum)
  rm(FilenameOuput)

  # Data Select
  DataSelect = DecodingBrainSignals_DataSelect(
           Data, GraphNeed, PatientNeed, ChannelNeed)

  # planning grid
  if (!((GridCheck == 0)||(GridCheck == 1))) {
    InstallPackagesIfNot("gridExtra")
    require(gridExtra)

    for (GraphNeedNum = 1:length(GraphNeed)) {

    }
    NowDataPlot = DecodingBrainSignals_DataRearrange(
      DataSelect, GraphNeed, PatientNeed, ChannelNeed)
    NowGraph = DecodingBrainSignals_LineChart_XTime_YElecRaw_GroupPCh(DataPlot)
    ggsave(file = Filename, Graph)
  } else {
    # you only output one graph, ignore "gridExtra"
    DataPlot = DecodingBrainSignals_DataRearrange(
      DataSelect, GraphNeed, PatientNeed, ChannelNeed)
    Graph = DecodingBrainSignals_LineChart_XTime_YElecRaw_GroupPCh(DataPlot)
    ggsave(file = Filename, Graph)
    rm(DataPlot, Graph)
  }
}

####################################

DecodingBrainSignals_Filename =
  function(GraphNeed, GraphMerge,
           PatientNeed, PatientMerge,
           ChannelNeed, OutputFolder) {

  # file name: re-prefix
    # for fill zero function: str_pad
    require(stringr)
  if (length(GraphNeed) == 100) {
    GraphNeedFileNameStr = "All"
  } else {
    GraphNeedFileNameStr =
      apply(matrix(
        paste0("G",
          str_pad(GraphNeed, 3, pad = "0")
        )
      ), 2, paste, collapse = "_")
  }
  if (length(PatientNeed) == 4) {
    PatientNeedFileNameStr = "All"
  } else {
    PatientNeedFileNameStr =
      apply(matrix(
        paste0("G",
          str_pad(PatientNeed, 3, pad = "0")
        )
      ), 2, paste, collapse = "_")
  }
  if (length(ChannelNeed) == 64) {
    ChannelNeedFileNameStr = "All"
  } else {
    ChannelNeedFileNameStr =
      apply(matrix(
        gsub("_", replacement = "", ChannelNeed)
      ), 2, paste, collapse = "_")
  }

  # Merge condition
  if (GraphMerge == TRUE) {
    GraphNum = 0
    GraphNeedFileNameStr = paste(GraphNeedFileNameStr, "Merge", sep = "")
  } else {
    GraphNum = length(GraphNeed)
  }
  if (PatientMerge == TRUE) {
    PatientNum = 0
    PatientNeedFileNameStr = paste(PatientNeedFileNameStr, "Merge", sep = "")
  } else {
    PatientNum = length(PatientNeed)
  }


  # filename: combined
  Filename =
    paste(OutputFolder, GraphNeedFileNameStr, PatientNeedFileNameStr, ChannelNeedFileNameStr, ".png", sep = "")
  rm(GraphNeedFileNameStr, PatientNeedFileNameStr, ChannelNeedFileNameStr)

  return(list(Filename = Filename,
              GraphNum = GraphNum,
              PatientNum = PatientNum))
}

####################################

DecodingBrainSignals_DataSelect =
  function(Data,
           GraphNeed,
           PatientNeed,
           ChannelNeed) {

  # Select Data
  DataRowGraphNeed = which(Data$Stimulus_Type %in% as.character(GraphNeed))
  DataRowPatientNeed = which(Data$PatientID %in% PatientNeed)
  DataRowNeed = intersect(DataRowGraphNeed, DataRowPatientNeed)
  DataColNeed = colnames(Data) %in% c("PatientID", "Stimulus_Type", ChannelNeed)

  Data = Data[DataRowNeed, DataColNeed]
  rm(DataRowGraphNeed, DataRowPatientNeed, DataRowNeed, DataColNeed)

  return(Data)
}

####################################

DecodingBrainSignals_DataRearrange =
  function(Data,
           GraphNeed,
           PatientNeed,
           ChannelNeed) {

  NowPatient = gsub("p", replacement="P", as.character(Data$PatientID))
  PatientLevels = levels(as.factor(NowPatient))
  for (PatientNum in 1:length(PatientLevels)) {
    NowPatientName = PatientLevels[PatientNum]

    if (PatientNum == 1) {
      TempTiming = 1:length(which(NowPatient %in% NowPatientName))
    } else {
      TempTiming = c(TempTiming, 1:length(which(NowPatient %in% NowPatientName)))
    }
    rm(NowPatientName)
  }
  rm(PatientLevels, PatientNum)
  Timing = rep(TempTiming, length(ChannelNeed))

  for (ChannelNeedNum in 1:length(ChannelNeed)) {
    # I just a little bit don't trust of type transfer in re-dataframe
    ExecTempDataStr = paste("TempData = as.numeric(as.character(Data$", ChannelNeed[ChannelNeedNum], "))",
                            sep = "")
    eval(parse(text = ExecTempDataStr))
    # ggplot2 need this arrangment to read.
    # rep data.
    NowChName = ChannelNeed[ChannelNeedNum]
    NowChName = strsplit(NowChName, split="_", fixed=T)
      # for fill zero function: str_pad
      require(stringr)
    NowChName = paste("Ch",
                      str_pad(as.numeric(NowChName[[1]][2]), 2, pad = "0"),
                      sep = "")
    ExecTempPIDElectrodeChStr =
      paste("TempPIDElectrodeCh = rep('", NowChName, "', length(TempData))",
                                   sep = "")
    eval(parse(text = ExecTempPIDElectrodeChStr))
    TempPIDElectrodeCh = paste(NowPatient, TempPIDElectrodeCh, sep = "_in_")
    # remove
    rm(ExecTempDataStr, NowChName, ExecTempPIDElectrodeChStr)

    if (ChannelNeedNum == 1) {
      Electrode = TempData
      PIDElectrodeCh = TempPIDElectrodeCh
    } else {
      Electrode = c(Electrode, TempData)
      PIDElectrodeCh = c(PIDElectrodeCh, TempPIDElectrodeCh)
    }
    rm(TempData,TempPIDElectrodeCh)
  }
  rm(ChannelNeedNum, NowPatient)

  Data = data.frame(Electrode = Electrode,
                    PIDElectrodeCh = PIDElectrodeCh,
                    Timing = Timing)

  return(Data)
}

####################################

DecodingBrainSignals_LineChart_XTime_YElecRaw_GroupPCh =
  function(Data) {

  InstallPackagesIfNot("ggplot2")
  require(ggplot2)

  Graph = ggplot(Data, aes(Timing, Electrode, colour = PIDElectrodeCh))
  Graph = Graph + geom_line()

  return(Graph)
}

####################################

# Program: InstallPackagesIfNot.R
#          Install Packages If Not exist
#
# Programmer : skylikewater - Jheng-Ting Chen, NTU GIBMS 2nd, R01454016
#              justin666666@gmail.com
#
# History:
# 150826 skylikewater - first release
#

InstallPackagesIfNot = function(Str) {
  eval(parse(text = paste("RequireResult = require(", Str, ")", sep = "")))

  if (!RequireResult) {
    eval(parse(text = paste("install.packages('", Str, "')", sep = "")))
  }
}