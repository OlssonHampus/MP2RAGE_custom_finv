clear all; clc
addpath([pwd, '\NIfTI_20140122'])

def_path = pwd;
[nii_file_re,nii_path_re]=uigetfile('*.nii.gz','Select 4D Real NIfTI data',def_path,...
    'MultiSelect', 'off');
[nii_file_im,nii_path_im]=uigetfile('*.nii.gz','Select 4D Imaginary NIfTI data',nii_path_re,...
    'MultiSelect', 'off');

%Real image data here
nii = load_untouch_nii(strcat(nii_path_re, filesep ,nii_file_re));
re1 = double(nii.img(:,:,:,1));
re2 = double(nii.img(:,:,:,2));
%Imaginary image data here
nii = load_untouch_nii(strcat(nii_path_im,'\',nii_file_im));
im1 = double(nii.img(:,:,:,1));
im2 = double(nii.img(:,:,:,2));


gre1 = re1+1i*im1;
gre2 = re2+1i*im2;
s = real(conj(gre1).*gre2./(abs(gre1).^2+abs(gre2).^2));
%conjugate on gre2 produces identical result
% s = real(gre1.*conj(gre2)./(abs(gre1).^2+abs(gre2).^2));

nii.hdr.dime.dim = [3 nii.hdr.dime.dim(2) nii.hdr.dime.dim(3)...
    nii.hdr.dime.dim(4) 1 1 1 1];
nii.img = s;

split_str = strsplit(nii_file_re, '_');
name_prefix_temp = split_str{1};
if length(name_prefix_temp)==3
    name_prefix = strcat('s0',name_prefix_temp(1));
elseif length(name_prefix_temp)==4
    name_prefix = strcat('s',name_prefix_temp(1:2));
end

mp2rage_filename = strcat(name_prefix, '_mp2rage.nii.gz');
save_untouch_nii(nii,strcat(nii_path_re, filesep, mp2rage_filename));

slice = round(length(s(:,1,:))/2);
window = [-0.5 0.5];
figure
imshow(rot90(squeeze(s(:,slice,:))),window)
colorbar

