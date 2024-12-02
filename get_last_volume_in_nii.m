clear all
addpath(fullfile(pwd,'NIfTI_20140122'))
def_path = pwd;
[nii_file,nii_path]=uigetfile('*.nii.gz','Select 4D NIfTI data',...
    def_path,'MultiSelect', 'off');
nii = load_untouch_nii(strcat(nii_path,nii_file));
img = double(nii.img(:,:,:,end));
xdim = nii.hdr.dime.dim(2);
ydim = nii.hdr.dime.dim(3);
zdim = nii.hdr.dime.dim(4);
nii.hdr.dime.dim = [3 xdim ydim zdim 1 1 1 1];
[~,name,~] = fileparts(nii_file);
[~,name,~] = fileparts(name);
nii.img = img;
save_untouch_nii(nii,strcat(nii_path,name,'_last.nii.gz'));