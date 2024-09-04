<h1>Quality Control Standard Pipeline</h1>
<p>The Quality Control Standard (QCS) pipeline was developed to help MALDI-MSI (Matrix-assisted laser desorption/ionization mass spectrometry imaging) users evaluate and correct batch effects in their experiments. This pipeline employs a novel Quality Control Standard, created by the Berta-Cillero group at the MERLN Institute in Maastricht, to monitor and control technical variations. By integrating this standard, the pipeline ensures consistency across experiments, providing a reliable method for addressing technical variation in MALDI-MSI data.</p>

![workflow]()

<p>The pipeline consists of three notebooks: Tutorial, Pipeline #1, and Pipeline #2.</p>

<table align="center">
  <tr>
    <td style="padding-right: 100px;">
      <img src="images/pipeline1.drawio.png" alt="pipeline1 drawio" height="400" width="400"/>
    </td>
    <td>
      <img src="images/pipeline.drawio.png" alt="pipeline drawio" height="400" width="400"/>
    </td>
  </tr>
</table>


<p>Tutorial is designed to guide users using the pipeline. It will demonstrate how we used the pipeline for experiment in Luo's paper where we conducted a three-day metabolomics batch test to demonstrate the novel QCS's sensitivity to technical variations.</p>

<p>* <b>Pipeline #1</b> is designed to evaluate and correct intra- and interday batch effects occurring in the QCS samples using Internal Standard Normalization. To evaluate batch effects, we used relative standard deviation (RSD) to measure of the variation occurring in the samples.</p>

<p>* <b>Pipeline #2</b> is used to assess intra- and interday batch effects in both QCS samples and artificially created tissue homogenate samples. It allows users to correct batch effects using various methods such as Combat, WaveICA, and NormAE, Total Ion Count normalization, and Internal Standard normalization. To evaluate batch effects, we used relative standard deviation (RSD) to measure the coefficient of variation occurring in the samples. As well, we perform Principal Component Analysis and assess their clusterness to evaluate the similarity of samples.</p> 

<p> As proposed in the diagram, the input used for this pipeline are no normalization dataset, TIC normalization dataset, and batch information. The no normalization dataset means a CSV file obtained from SCiLS Lab software </p>

<p> The batch correction methods used such as Combat, WaveICA, NormAE, Total Ion Count normalization, and Internal Standard normalizations are currently used batch correction methods in metabolomics, transcriptomics, and genomics data analysis.</p>

--- 

<h3>Paper: **Luo's paper name** </h3>

--- 
<h2>Table of Contents</h2> 
  * Requirements
  * How to use

<h2>Requirements</h2>
<p>Visual Code Studio or Anaconda </p>

<h2>How to use</h2>
<h3>Data preparation</h3>
<p>metabolomics_data (no normalization / TIC normalization dataset obtained from SCiLS Lab)</p>
<p>You can obtain the dataset CSV file from SCiLS Lab and it will look like below for instance. </p> 



<p>batch_information (batch information file)</p>
<p>Unfortunately, you have to create the batch_information CSV file by yourself. The example can be seen below.</p>


<p>Each pipeline consist of its own read me to follow through.<p>


