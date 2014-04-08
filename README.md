murphylab189
============

This source code contains the neccesary information to generate the figures and tables from the article

Jieyue Li, Aabid Shariff, Mikaela Wiking, Emma Lundberg, Gustavo K. Rohde and Robert F. Murphy. Estimating microtubule distributions from 2D immunofluorescence microscopy images reveals differences among human cultured cell lines. PLoS ONE (2012).

To download the source code, raw data and intermediate results manually, please visit
http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/

To download the original papaer, please visit
http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0050292

Downlading the Source Code
==========================

You can download the latest stable copy of the source code from

http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_Code.tgz

You can download the source code directly using a web-browser. From terminal you can use 

wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_Code.tgz
tar -xvf http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_Code.tgz
cd CellLines


Or you can get a copy of the source code repository from (not guaranteed to be stable)

https://bitbucket.org/icaoberg/murphylab189

You can download the repository using git. From terminal you can use
git clone https://icaoberg@bitbucket.org/icaoberg/murphylab189.git
cd murphyabl189

Comments: the first stable version of the source was tested in CentOS using Matlab 2007a. Older versions of the source code might not run in newer versions of Matlab.


Recreating Results from Raw Image Data
--------------------------------------

To recreate the results from the article from intermediate results download the source code and use the run.m script to generate the results.

For example, in Ubuntu, start Matlab and run

icaoberg@developers:~$ matlab
Warning: No display specified.  You will not be able to display graphics on the screen.

                                                           < M A T L A B (R) >
                                                 Copyright 1984-2011 The MathWorks, Inc.
                                                  R2011b (7.13.0.564) 64-bit (glnxa64)
                                                             August 13, 2011

 
To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.
 
>> run()

or

icaoberg@developers:~$ matlab
Warning: No display specified.  You will not be able to display graphics on the screen.

                                                           < M A T L A B (R) >
                                                 Copyright 1984-2011 The MathWorks, Inc.
                                                  R2011b (7.13.0.564) 64-bit (glnxa64)
                                                             August 13, 2011

 
To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.
 
>> run('scratch')

Recreating Results from Intermediate Results
---------------------------------------------

To recreate the results from the article from intermediate results download the source code and use the run.m script to generate the results.

For example, in Ubuntu, start Matlab and run

icaoberg@developers:~$ matlab
Warning: No display specified.  You will not be able to display graphics on the screen.

                                                           < M A T L A B (R) >
                                                 Copyright 1984-2011 The MathWorks, Inc.
                                                  R2011b (7.13.0.564) 64-bit (glnxa64)
                                                             August 13, 2011

 
To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.
 
>> run('intermediate')


