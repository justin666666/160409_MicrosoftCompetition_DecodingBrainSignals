Project Name:
-------------
MicrosoftCompetition_DecodingBrainSignals  
  
  
  
- Project Date: 160409 - first created  
- README version:
  - 160420 - add Script, Data n' Document, and Graph explanation.  
  - 160417 - first created  
- Programmer:  
  1. skylikewater  
      - Jheng-Ting Justin Chen  
      - justin666666@gmail.com  
  
  
  
Purpose:
-------------
Visualization and breaf introduction of the Decoding Brain Signals competition.  
  
  
  
Introduction:
-------------
This project is for a breaf introduction  
of the Decoding Brain Signals competition, which holded by Microsoft.  
You can check [Project website] [DBS_Web] for more detail.  
  
For blogging need, I wrote a simplfy visualization for competition data.  
  
  
  
Script:
-------
1. DecodingBrainSignals_LineChart_XTime_YElecRaw_GroupPCh.R  
   **require ggplot2 and gridExtra package**  
   *or it will install automatically*  
		\# My workspace info.  
		> sessionInfo()  
		R version 3.2.2 (2015-08-14)  
		Platform: x86_64-w64-mingw32/x64 (64-bit)  
		Running under: Windows 8 x64 (build 9200)  
		> packageVersion("ggplot2")  
		[1] ‘2.1.0’  
		> packageVersion("gridExtra")  
		[1] ‘2.2.1’  
   This script can simplify output train data graph.  
   Two function have been including:  
   1. DecodingBrainSignals_LineChart_XTime_YElecRaw_GroupPCh  
      For draw a graph
   2. DecodingBrainSignals_DataRearrange

  
  
  
Data and Document situation:
----------------------------
1. Data: &#x2611;
  1. ecog_train_with_labels.csv
     &#x2612; [Download link] [DBS_TrainData]
     The training data in csv format.
		> dim(Data)  
		[1] 690200     67  
		> colnames(Data)  
		 [1] "PatientID"     "Electrode_1"   "Electrode_2"   "Electrode_3"  
		\# (Electrode_4 ~ Electrode_63 in col 5 ~ 64)  
		[65] "Electrode_64"  "Stimulus_Type" "Stimulus_ID"  
  
2. Document: &#x2611;
  1. [2016 Miller] Spontaneous Decoding of the Timing and Content of Human Object Perception from Cortical Surface Recordings ....PDF  
     &#x2612; [Download link] [Miller2016Paper]  
     The publish paper which including together but use another 7 subjects data.  
  2. DataDescription.docx  
     &#x2612; [Download link] [DBS_DataDescription]  
     The breif introduce of data as same as "Data files > Background" on web.  
     Including column index information table.  
  3. Tutorial_1.docx  
     &#x2612; [Download link] [Cortana_Tutorial]  
     The document help you learning Azure ML for your analysis.  
  4. Tutorial_2.docx  
     &#x2612; [Download link] [R_Tutorial]  
     The document help you work under R, and build your script to Azure.  
  5. Quickstart tutorial for the R programming language for Azure Machine Learning.pdf  
     &#x2612; [Download link] [R_Quickstart]  
     The official document for R work for Azure.  
  
  
  
Graph:
----------------------------

  
  
  
- Copyright: CC BY-NC-SA 2.5 TW  
  - Attribution, NonCommercial, and ShareAlike  
> You can confirm the detail of copyright policy by follow link:  
> English version:  
> https://creativecommons.org/licenses/by-nc-sa/2.5/tw/deed.en  

[DBS_Web]: https://gallery.cortanaintelligence.com/Competition/Decoding-Brain-Signals-2
[DBS_TrainData]: http://az754797.vo.msecnd.net/competition/ecog/datasets/ecog_train_with_labels.csv
[Miller2016Paper]: http://journals.plos.org/ploscompbiol/article/metrics?id=10.1371/journal.pcbi.1004660
[DBS_DataDescription]: http://az754797.vo.msecnd.net/competition/ecog/docs/DataDescription.docx
[Cortana_Tutorial]: http://az754797.vo.msecnd.net/competition/ecog/docs/Tutorial_1.docx
[R_Tutorial]: http://az754797.vo.msecnd.net/competition/ecog/docs/Tutorial_2.docx
[R_Quickstart]: https://azure.microsoft.com/en-us/documentation/articles/machine-learning-r-quickstart/