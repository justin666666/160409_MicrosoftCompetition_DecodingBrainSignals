FileFolder = "D:\\Dropbox\\840_Github\\[Private]_Data\\160409_MicrosoftCompetition_DecodingBrainSignals\\"
OutputFolder = FileFolder

DataPath = file.path(paste(FileFolder, "ecog_train_with_labels.csv", sep = ""))
Data = read.csv(DataPath)

# head(Data) in "head(Data)" file

# I perfer to draw 2D dot plot first
# install.packages("ggplot2")
require(ggplot2)
  # Draw01. Single electrode raw
  # use ch.1, kick INI, ignore 0 in stimulus type
  DataRowNeed = intersect(which(Data$Stimulus_Type != 0), which(Data$Stimulus_Type != 101))
  DataColNeed = colnames(Data) %in% c("PatientID", "Electrode_1", "Stimulus_Type")
  DataPlot = Data[DataRowNeed, DataColNeed]
  rm(DataRowNeed, DataColNeed)
  Electrode_1 = as.numeric(as.character(DataPlot$Electrode_1))
  Stimulus_Type = as.numeric(as.character(DataPlot$Stimulus_Type))
  DataPlot = data.frame(Electrode_1 = Electrode_1,
                        Stimulus_Type = Stimulus_Type)
  rm(Electrode_1, Stimulus_Type)
  Graph = ggplot(DataPlot, aes(Electrode_1, Stimulus_Type))
  Graph = Graph + geom_point()
  ggsave(file = paste(FileFolder, "Electrode1_WholeImage_Raw.png", sep = ""), Graph)
  rm(Graph)

  # Draw02. Six electrode raw in one graph
  # use ch.1 n' 33, Graph 01
  PatientNeed = c("p1", "p2", "p3", "p4")
  ChannelNeed = c("Electrode_1", "Electrode_33")
  source(paste(FileFolder, "DecodingBrainSignals_LineChart_XTime_YElecRaw_GroupPCh.R", sep = "")
  DecodingBrainSignals_LineChart_XTime_YElecRaw_GroupPCh(
    Data = Data, GraphNeed = c(1), PatientNeed = PatientNeed, ChannelNeed = ChannelNeed, FileFolder = FileFolder)


  # then paste all face in one variable, all house in another variable

