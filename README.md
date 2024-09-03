<h2>Quality Control Standard Pipeline</h2>
<p>The Quality Control Standard (QCS) pipeline was developed to help MALDI-MSI users evaluate and correct batch effects in their experiments. This pipeline employs a specialized Quality Control Standard, created by the Berta-Cillero group at the MERLN Institute in Maastricht, to monitor and control technical variations By integrating this standard, the pipeline ensures consistency across experiments, providing a reliable method for addressing technical variation in MALDI-MSI data.</p>

<p>The pipeline consists of two notebooks: Pipeline #1 and Pipeline #2.</p>
![pipeline](https://github.com/Jintonic0226/QCS_Pipeline/blob/e2f12d8e4e859dc84284606a258b92ce09642fe5/pipeline.drawio.png?raw=true)
![pipeline2](pipeline.drawio.png)

<p>* <b>Pipeline #1</b> is designed to evaluate and correct intra- and interday batch effects occurring in the QCS samples using Internal Standard Normalization. To evaluate batch effects, we used relative standard deviation (RSD) to measure of the variation occurring in the samples.</p>

<p>* <b>Pipeline #2</b> is used to assess intra- and interday batch effects in both QCS samples and artificially created tissue homogenate samples. It allows users to correct batch effects using various methods such as Combat, WaveICA, and NormAE, Total Ion Count normalization, and Internal Standard normalization. To evaluate batch effects, we used relative standard deviation (RSD) to measure the variation occurring in the samples. As well, we perform Principal Component Analysis and assess their clusterness to evaluate the similarity of samples.</p> 

<p> The batch correction methods used such as Combat, WaveICA, NormAE, Total Ion Count normalization, and Internal Standard normalizations are currently used batch correction methods in metabolomics, transcriptomics, and genomics data analysis. <p>
  
<p>Each pipeline consist of its own read me to follow through.<p>
<p>Requirements: Visual Code Studio or Anaconda.<p> 

