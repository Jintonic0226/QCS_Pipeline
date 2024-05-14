<h2>Read Me</h2>

<p>This pipeline is to evaluate the Quality Control Standard and compare different normalizations (TIC, IS) and evaluation QCS and tissue sample.</p>
<p>After evaluation, we can correct batch effects using three packages (Combat, WaveICA, NormAE) and compare them again.</p>
<p>Then, we can apply this pipeline to varying tissue samples.</p>
<p>It is recommended to replace the existing files into new files (such as upload the new file and change the name in cells for check file path).</p>
<p>As well each time we run the cell, it will overwrite the file except for excel files (for instance, each time you run combat it will overwrite combat results for csv file).</p>
<p>You can click to blue linked text to directly go to the section </p>
<p>To run this notebook, it is recommended to run via anaconda with r-environment or through vs code with r-environment.</p>

<b>Step 1: Go to Anaconda Navigator </b><br>
<b>Step 2: Go to Environment </b><br>
<b>Step 3: Click Create (plus sign) and create R-environment (choose R and give a name) </b><br>
<b>Step 4: Either run notebook in VS Code or Anaconda (JupyterLab) </b><br>
<b>Step 5: If you choose VS Code, you need to choose kernel at the top right and choose Jupyter kernel (or R-env directly) </b><br>

Guide Images
![IMG_2264](https://github.com/Jintonic0226/QCS_Pipeline/assets/160440173/69091330-6f32-4a01-b330-09941a0dadfe)
