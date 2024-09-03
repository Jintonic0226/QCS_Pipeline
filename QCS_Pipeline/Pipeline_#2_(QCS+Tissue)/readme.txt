Visual Studio Code Setup:
1) Install R version 4.33 from https://www.r-project.org/
2) Install R package ‘IRkernel’
3) Install python version 3.3 or greater from https://www.python.org/downloads/ 
4) Install python library ‘jupyter'’
5) Install Visual Studio code (VS code) from https://code.visualstudio.com/
6) Setup VS to work with R. Follow instructions from https://code.visualstudio.com/docs/languages/r
7) Open file ‘QCS_Pipeline.ipynb’ in VScode
7) Select kernel -> Jupyter kernel -> R (from the computer)
8) Run ‘Pipeline #2.ipynb’


Anaconda Setup:
1) Install anaconda from https://www.anaconda.com/
2) Setup an R environment. Follow instructions from https://docs.anaconda.com/free/working-with-conda/packages/using-r-language/# 
3) Activate the created R environment
4) Install R package ‘IRkernel’
5) Open jupyterlab through anaconda navigator or anaconda prompt
6) Open file ‘Pipeline #2.ipynb’ to run

How to use Pipeline #2:
- Upload 3 csv files into input folder: no normalization dataset, TIC (Total Ion Count) normalization dataset, batch information
- Give file path for the 3 csv files, QCS m/z values, tissue type names (sample_set) in input information cell
- Run everything in order by either clicking the run button or pressing shift + enter
   1) QCS batch effect evaluation
   2) Tissue + QCS batch effect evaluation
   3) Batch effect correction (Combat, WaveICA, and NormAE)
      *** Notice *** For NormAE correction cell, you would need to run NormAE externally and upload Ys and Rec_nobe fies obtained after running NormAE 
   4) Comparison
   5) Outputs (csv files of each dataset, excel sheets with intra/inter-batch, overview result pdf)
      *** Notice *** For excel sheet generation, user needs to give number of batches existing in dataset

- If you were to change the input dataset, you would still need to run the whole cells to see the changes. 
