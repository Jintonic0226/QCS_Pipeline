<h1>Quality Control Standard Pipeline</h1>
<p>The Quality Control Standard (QCS) pipeline was developed to help MALDI-MSI (Matrix-assisted laser desorption/ionization mass spectrometry imaging) users evaluate and correct batch effects in their experiments. This pipeline employs a novel Quality Control Standard, created by the Berta-Cillero group at the MERLN Institute in Maastricht, to monitor and control technical variations. By integrating this standard, the pipeline ensures consistency across experiments, providing a reliable method for addressing technical variation in MALDI-MSI data.</p>

<div align="center">
  <img src="images/workflow.png" alt="Workflow" width="400">
  <p><em>Figure 1: Workflow of Quality Control Standard.</em></p>
</div>


<p>The pipeline consists of three notebooks: Tutorial, Pipeline #1, and Pipeline #2.</p>

<table align="center">
  <tr>
    <td style="padding-right: 100px;">
      <img src="images/pipeline1.drawio.png" alt="pipeline1 drawio" height="400" width="400"/>
      <p style="text-align: center;"><em>Figure 1: Pipeline 1 workflow</em></p>
    </td>
    <td>
      <img src="images/pipeline.drawio.png" alt="pipeline drawio" height="400" width="400"/>
      <p style="text-align: center;"><em>Figure 2: Pipeline 2 workflow</em></p>
    </td>
  </tr>
</table>

<p>* <b>Tutorial</b> is designed to guide users using the pipeline. It will demonstrate how we used the pipeline for experiment in Luo's paper where we conducted a three-day metabolomics batch test to demonstrate the novel QCS's sensitivity to technical variations.</p>

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

```
  # Exported with SCiLS Lab Version ??.??.?????
  # Export time: ????-??-?? ??:??:?? 
  # Generated from file:     
  # Object Full Name: All Features
  # Object ID: afad0ade-9e2e-43bb-9aea-72ec417ef666
  # Object type: Static feature list
  # Object creation time: 2024-04-08 15:47:14
  #
  m/z;Interval Width (+/- Da);Color;Name;Peak area - S1_ChickenHeart_1 - Total Ion Count;Peak area - S1_QCS_1 - Total Ion Count;Peak area - S1_QCS_2 - Total Ion Count;Peak area - S1_QCS_3 - Total Ion Count;Peak area - S1_QCS_4 - Total Ion Count;Peak area - S1_QCS_5 - Total Ion Count;Peak area - S1_QCS_6 - Total Ion Count;
  260.186;0.39999999999998;#ff0000;;24.862476348877;137.73648071289;119.50503540039;52.95552444458;44.430557250977;55.795078277588;120.70277404785;21.331935882568;99.57039642334;91.502296447754;50.931121826172;49.378700256348;50.429401397705;94.79182434082;20.711795806885;149.01470947266;112.04853057861;61.380790710449;50.658771514893;51.290508270264;102.94848632812;18.866115570068;287.92700195312;246.49362182617;128.19694519043;112.51879119873;121.14172363281;211.72250366211;34.84924697876;179.55671691895;184.21817016602;148.84031677246;148.5962677002;168.1051940918;202.28717041016;27.234670639038;236.3073425293;246.68064880371;157.10659790039;131.64770507812;103.87913513184;239.08851623535;21.358554840088;132.6932220459;151.79946899414;75.47811126709;73.037925720215;82.626251220703;150.02458190918;26.866128921509;149.89027404785;149.5133972168;92.417778015137;93.846458435059;93.430221557617;151.45465087891;16.800037384033;174.01013183594;161.53346252441;96.463584899902;96.718109130859;82.386520385742;156.0269317627;19.106182098389;180.47308349609;187.07023620605;102.51469421387;98.917251586914;99.662078857422;191.35638427734;18.008165359497;167.99542236328;178.45771789551;85.210441589355;96.092414855957;106.67995452881;167.41558837891;28.668516159058;160.47941589355;171.96621704102;116.98316955566;92.221908569336;82.57738494873;139.11538696289;26.392351150513;39.753704071045;40.506313323975;40.134765625;40.863285064697;42.837776184082;35.321823120117;24.230098724365;41.483642578125;41.863697052002;39.530323028564;36.233371734619;34.69518661499;40.315093994141;25.993133544922;45.812950134277;41.180057525635;45.596652984619;41.05451965332;40.737815856934;35.12744140625;18.125825881958;120.20398712158;133.71403503418;81.923980712891;87.716033935547;85.721015930176;165.95762634277;31.518629074097;169.203125;164.0277557373;98.977798461914;90.507972717285;89.48420715332;170.20631408691;18.660320281982;130.35289001465;121.69453430176;71.195579528809;65.58325958252;71.810493469238;122.03343963623
  267.187;0.39999999999998;#33a02c;;13.286972999573;97.435554504395;101.62287902832;45.440727233887;36.04857635498;46.473815917969;110.33308410645;14.058776855469;73.237899780273;75.259651184082;41.559638977051;36.565586090088;31.600343704224;77.430030822754;13.630248069763;93.101715087891;85.848373413086;54.281024932861;43.203804016113;45.796901702881;88.173133850098;14.198471069336;161.87211608887;172.45951843262;123.34893035889;104.38571929932;101.53553771973;205.45863342285;13.807366371155;173.42425537109;178.56581115723;113.33050537109;110.98078918457;125.83345031738;185.11181640625;13.207230567932;196.05738830566;166.70748901367;87.753860473633;75.034111022949;69.550987243652;137.28373718262;13.460225105286;87.060729980469;105.67572784424;59.072315216064;59.810432434082;69.618858337402;112.03863525391;13.18640422821;126.63864135742;130.82710266113;79.002334594727;75.627822875977;57.881275177002;128.58056640625;13.615122795105;150.07972717285;138.43949890137;85.91471862793;77.86988067627;52.993545532227;135.87255859375;13.285980224609;152.89916992188;133.12403869629;57.600872039795;59.752708435059;74.524742126465;120.95012664795;12.353779792786;120.90351867676;136.873046875;66.05606842041;68.911338806152;66.93025970459;137.22576904297;14.798279762268;137.13334655762;120.17411804199;67.467277526855;56.59001159668;59.319362640381;81.973815917969;12.603652000427;30.280948638916;31.059616088867;29.979200363159;29.927774429321;29.884693145752;27.439464569092;14.172054290771;27.276578903198;29.187063217163;28.746053695679;27.525789260864;26.33616065979;27.578323364258;12.485769271851;32.542747497559;27.063621520996;31.056589126587;31.076137542725;29.86252784729;26.627750396729;13.284766197205;96.286323547363;115.90483093262;62.727806091309;54.712505340576;53.840354919434;127.50940704346;14.240409851074;121.95536804199;108.82050323486;57.178150177002;56.865535736084;58.207714080811;101.40291595459;15.405156135559;104.90135192871;94.03556060791;52.897029876709;44.809577941895;43.226345062256;94.984130859375
```


<img width="1004" alt="image" src="https://github.com/user-attachments/assets/67d3710c-17ad-4840-8051-70f84f9a9f61">
<p>batch_information (batch information file)</p>

```
sample.name	injection.order	batch
Peak area - S1_ChickenHeart_1 - Total Ion Count	1	1
Peak area - S1_QCS_1 - Total Ion Count	2	1
Peak area - S1_QCS_2 - Total Ion Count	3	1
Peak area - S1_QCS_3 - Total Ion Count	4	1
Peak area - S1_QCS_4 - Total Ion Count	5	1
Peak area - S1_QCS_5 - Total Ion Count	6	1
Peak area - S1_QCS_6 - Total Ion Count	7	1
Peak area - S2_ChickenHeart_2 - Total Ion Count	8	1
Peak area - S2_QCS_1 - Total Ion Count	9	1
Peak area - S2_QCS_2 - Total Ion Count	10	1
Peak area - S2_QCS_3 - Total Ion Count	11	1
Peak area - S2_QCS_4 - Total Ion Count	12	1
Peak area - S2_QCS_5 - Total Ion Count	13	1
Peak area - S2_QCS_6 - Total Ion Count	14	1
```
<img width="365" alt="image" src="https://github.com/user-attachments/assets/898b2eac-8c62-4cc3-96f4-498d3d961565">

<p>Unfortunately, you have to create the batch_information CSV file by yourself. The example can be seen below.</p>


<p>Each pipeline consist of its own read me to follow through.<p>


