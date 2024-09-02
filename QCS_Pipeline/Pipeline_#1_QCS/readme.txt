How to set up for Pipeline #1
Visual Studio Code Setup:
- Install R version 4.33 from https://www.r-project.org/
- Install R package ‘IRkernel’
- Install python version 3.3 or greater from https://www.python.org/downloads/ 
- Install python library ‘jupyter'’
- Install Visual Studio code (VS code) from https://code.visualstudio.com/
- Setup VS to work with R. Follow instructions from https://code.visualstudio.com/docs/languages/r
- Open file ‘Pipeline #1.ipynb’ in VScode
- Select kernel -> Jupyter kernel -> R (from the computer)
- Run ‘Pipeline #1.ipynb’


Anaconda Setup:
- Install anaconda from https://www.anaconda.com/
- Setup an R environment. Follow instructions from https://docs.anaconda.com/free/working-with-conda/packages/using-r-language/# 
- Activate the created R environment
- Install R package ‘IRkernel’
- Open Jupyterlab through anaconda navigator or anaconda prompt
- Open file ‘Pipeline #1.ipynb’ to run

How to use Pipeline #1:
- Upload 3 csv files into input folder: no normalization dataset, TIC normalization dataset, batch information 
- Give file path for the 3 csv files, QCS m/z values, tissue type names (sample_set) in input information cell
- Run everything in order by either clicking the run button or pressing shift + enter 
  1) Preprocessing datasets (no normalization, TIC normalization, IS normalization)    2) RSD calculation
  3) Intensity plot
  4) Violin plot
  5) Output (csv files of each datasets, excel sheets of each dataset with intra/inter-batch, overview result pdf). **For excel sheet, they will ask you to insert number of batches existing in dataset**
- If you were to change the input dataset, you would still need to run the whole cells to see the changes. 
