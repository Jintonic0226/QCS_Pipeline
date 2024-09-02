<h2>Read Me</h2>
<p>The Quality Control Standards pipeline was developed to assist MALDI-MSI users in evaluating and correcting batch effects. This pipeline utilizes a specialized Quality Control Standard, created by the Berta-Cillero group at MERLN Institute in Maastricht, to monitor and control technical variations. By incorporating this standard, the pipeline ensures consistency across experiments, providing a reliable method for addressing technical discrepancies in MALDI-MSI data.</p>

<p>The pipeline consists of two notebooks: Pipeline #1 and Pipeline #2.</p>

<p>* <b>Pipeline #1</b> is used to evaluate intra and interday batch effect occuring in the QCS samples and corrects the batch effect using Internal Standard Normalization.</p>

<p>* <b>Pipeline #2</b> is used to evaluate the intra and interday batch effect occuring in the QCS samples and artifically made tissue homogenate samples and allows user to correct the occuring batch effect amonst multiple correction methods such as Combat, WaveICA, NormAE.</p> 
  
The pipeline #1 is used to evaluate the intra/interday batch effect in the QCS samples using relative standard deviation (RSD). The pipeline #2 is used to evaluate intra/interday batch effect in the QCS samples and also tissue homogenate samples. After evaluation, user can also choose to correct the occuring batch effect amongest multiple correction methods such as: Combat, WaveICA, NormAE, Total Ion Count normalization, and Internal Standard normalization.<p>

<p> The batch correction methods used such as Combat, WaveICA, NormAE, Total Ion Count normalization, and Internal Standard normalizations are currently used batch correction methods in metabolomics, transcriptomics, and genomics data analysis. <p>
  
<p>Each pipeline consist of its own read me to follow through.<p>
<p>Requirements: Visual Code Studio or Anaconda.<p> 

