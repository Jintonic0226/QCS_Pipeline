Input Data Description:

The metabolomics dataset was collected from a three-day metabolomics batch test using MALDI-MSI to measure 18 tissue section slides prepared from three types of animal organs. Raw data were processed via SCiLS Lab MVS 2024b Premium 3D (SCiLS GmbH, Bruker, Bremen, Germany) through the following steps:

Raw data files from consecutive batches in one experiment were imported together into one SCiLS file.
The imported mass spectrum was processed with baseline subtraction (convolution algorithm with peak width set to 20).
Peak picking was performed based on regions of entire tissue sections. Tissue feature finding involved filtering 200 peaks from the mean spectrum across different tissue types.
The final filtered features were stored in a tissue feature list.
Final feature tables, including QCS features and/or tissue features, were exported in two formats: no normalization and total ion count (TIC) normalization.

How to use Pipeline #2:

-Upload 3 CSV files into the input folder: no normalization dataset, TIC (Total Ion Count) normalization dataset, and batch information.

-Provide file paths for the 3 CSV files, QCS m/z values, and tissue type names (sample_set) in the input information cell.

-Run everything in order by either clicking the run button or pressing Shift + Enter:

1) Preprocessing datasets (no normalization, TIC normalization, IS normalization)
2) QCS batch effect evaluation
3) Tissue + QCS batch effect evaluation
4) Batch effect correction (Combat, WaveICA, NormAE). For NormAE correction, you would need to run NormAE externally and upload Ys and Rec_nobe files obtained after running NormAE
5) Comparision
6) Output (CSV files of each dataset, Excel sheets of each dataset with intra/inter-batch, and overview result PDF). For the Excel sheet, the system will prompt you to enter the number of batches in the dataset.

-If you change the input dataset, you will still need to run all the cells to see the updates.
