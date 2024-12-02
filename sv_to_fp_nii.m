clear all; clc; close all;

%Need toolbox:
% https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
addpath(fullfile(pwd,'NIfTI_20140122'))

% Get NIfTI data to be scaled
def_path = pwd;
[nii_file,nii_path]=uigetfile('*.nii.gz','Select NIfTI data',def_path,...
    'MultiSelect', 'on');

% One .nii file or several?
if ischar(nii_file) == 0
    nniis = length(nii_file);
else
    nniis = 1;
end

for ix = 1:nniis
    if nniis == 1
        nii = load_untouch_nii(strcat(nii_path,nii_file));
        [~,name,~] = fileparts(nii_file);
    else
        nii = load_untouch_nii(strcat(nii_path,nii_file{ix}));
        [~,name,~] = fileparts(nii_file{ix});
    end
    % dcm2niix specific Scale Slope / Intercept
    scl_slope = nii.hdr.dime.scl_slope;
    scl_inter = nii.hdr.dime.scl_inter;

    % Load Stored Value data
    img_sv = double(nii.img);

    % Conver to Floating Point (Precise value) using NifTI scaling factors
    img_fp = img_sv*scl_slope+scl_inter;

    % Optional scaling by 1000 to avoid very large values
    img_fp = img_fp./10^3;

    % Save the data to the NIfTI structure
    nii.img = img_fp;

    % Remove all scaling factors from the already scaled data
    nii.hdr.dime.scl_slope = 1;
    nii.hdr.dime.scl_inter = 0;

    % Save the data as 32bit double
    nii.hdr.dime.datatype = 16;
    nii.hdr.dime.bitpix = 32;

    % Save as a new NIfTI file with modified header
    [~,name,~] = fileparts(name);
    save_untouch_nii(nii,strcat(nii_path,name,'_fp.nii.gz'))
end