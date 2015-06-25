# ellipsoids-analysis-paper

## Introduction

The purpose of this code is to analyze fluorescent 3D spheroid in vitro cell cultures, where the cells are stained with a specific marker.
Therefore, the spheroids need to be segmented (the spheroid cells need to be stained or labeled) and cells positive for the marker need to be detected.
For the segmentation the spheroids are assumed to have an ellipsoidal shape, while the identification of positive stained cells is done with a spot detection algorithm.
The goal of the algorithm is to analyze 3D image stacks where deep spheroid imaging suffered from light attenuation issue.
Light attenuation makes that only the upper hemispheres of the spheroids are visible in such images, making the analysis difficult:
even if one succeeds segmenting the spheroids this still biases the analysis
 because not all positive cells will be visible and accounted for in the spheroid.
The proposed solution which we use in the algorithm can be summarized as follows:

- We segment the spheroids by assuming a 3D elliptical shape
- We detect the positive cells using a spot detection algorithm
- Further assuming that the spheroid characteristics are symmetric for 
its upper and lower hemisphere, we only use the upper hemisphere for the 
identification of positive cells and extrapolate the results to the lower hemisphere.
- We verify the validity of taking the upper hemisphere for the analysis by checking the intensity profile through the middle of the spheroid. 
When the intensity (which is assumed to be constant throughout the spheroid)
 drops too low (because of attenuation of the signal) before the center of 
the spheroid is reached, this spheroid is not fully analyzable.

With the solution proposed we don't use any attenuation correction algorithm, 
which is a better alternative when you have high quality images from which the signal isn't severely attenuated.

## Installation

This algorithm is written in MATLAB, you need a working MATLAB environment to be able to execute the scripts.
It makes extensive use of DIPimage, an image processing toolbox written for MATLAB (Quantitative Imaging Group of the TU Delft, Delft), which can be obtained from [DIPlib/DIPimage website](http://www.diplib.org/) (free for non-commercial use only).

Other external libraries which are used: [bfmatlab (Bio-Formats toolbox for MATLAB)](http://www.openmicroscopy.org/site/support/bio-formats5.1/users/matlab/),
 [JSONlab](http://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files-in-matlab-octave), 
[munkres (Munkres Assignment Algorithm)](http://www.mathworks.com/matlabcentral/fileexchange/20328-munkres-assignment-algorithm), 
[ReadImageJROI](http://www.mathworks.com/matlabcentral/fileexchange/32479-load---import-imagej-roi-files/content/ReadImageJROI.m),
 can be found under the directory 'libExternal', and information about them is provided in their corresponding folders.

## Description of the package folder structure

- algorithm: contains an implementation of the above method,
- figureGeneration: generate_paper_figures.m is the script which will generate images which show,
- lib: contains common functions for the method,
- libExternal: external libraries needed,
- example: example input & output of the method, the example images are not included because they're larger than 300 MB each

## License

Although the code is released under the free MIT license, MATLAB is not free, and 
DIPimage is only free for non-commercial use, please consult the [DIPlib/DIPimage website](http://www.diplib.org/) for more information.
Further, the use of the external libraries (bfmatlab, jsonlab, munkres, ReadImageJROI) is restricted under their proper licenses, which can be found inside their corresponding folders.
