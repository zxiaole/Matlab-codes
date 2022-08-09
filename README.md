# Matlab-codes


* [plotDensityComp.m](/plotDensityComp.m): Plot density of the scattering plot for a large number of data.

n=10000;

tdata=randn(n,1)*10;

plotDensityComp(tdata,tdata+randn(n,1))

<img src="/residual_distribution.png">

