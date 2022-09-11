%% BEST RUN WITH MATLAB R2018b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code was solely written by Jianjun Jiao in Lanzhou Jiaotong University.
% Correspondence address:Anning West Road of Anning District, Lanzhou, China.
% Contact:jiaojianjun@lzjtu.edu.cn
% Last change: January, 2022.
% Basically, you can run this code SEVERAL times to acquire the most desired result.
% It is welcomed to change the following parameters as you like to see what gonna happen.
%% Inputs:
% cluster_n - Number of clusters
% N -The number of superpixels that the image is presegmented
% G-Gray transformation range
% Offset- Texture direction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  
clear all;
clc;
close all;
%% Set the parameters
cluster_n =3;
N=200;
G=[1,255];
Offset=[0 1;-1 1;-1 0;-1 -1];
%% Input the image
I =imread('113044.jpg');
%%  Get region
[m,n,p]=size(I);
[label,N1] = superpixels(I,N);
BW = boundarymask(label);
figure,imshow(imoverlay(I,BW,'cyan'),'InitialMagnification',100);  
idx = label2idx(label);
%% Calculate the superpixel mean
outputImage = zeros(size(I),'like',I);
output = zeros(N1,3);
sumo=zeros(N1,3);
for labelVal = 1:N1
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+m*n;
    blueIdx = idx{labelVal}+2*m*n;
    sumo(labelVal,:)=[sum(I(redIdx)),sum(I(greenIdx)),sum(I(blueIdx))];
    output(labelVal,:) = [mean(I(redIdx)),mean(I(greenIdx)),mean(I(blueIdx))];
    outputImage(redIdx) = mean(I(redIdx));
    outputImage(greenIdx) = mean(I(greenIdx));
    outputImage(blueIdx) = mean(I(blueIdx));
end    
rgb(:,:,1)=output(:,1);
rgb(:,:,2)=output(:,2);
rgb(:,:,3)=output(:,3);
hsv = rgb2hsv(rgb);
hsv1=mat2gray(hsv(:,:,1));
hsv2=mat2gray(hsv(:,:,2));
hsv3=mat2gray(hsv(:,:,3));

figure,imshow(outputImage,'InitialMagnification',80)
%% Get the region texture feature
Texture = get_texture_features(I,label,N1,G,Offset);
Texture1 =[sum(Texture(:,[1,4,7]),2),sum(Texture(:,[2,5,8]),2),sum(Texture(:,[3,6,9]),2)]./3;
texture =mat2gray(Texture1);
%% Get area texture, mean, color feature
output=mat2gray(output);
data(:,:,1)= texture(:,1);
data(:,:,2)= texture(:,2);
data(:,:,3)= texture(:,3);
data(:,:,4)= output(:,1);
data(:,:,5)= output(:,2);
data(:,:,6)= output(:,3);
data(:,:,7)= hsv1;
data(:,:,8)= hsv2;
data(:,:,9)= hsv3;

data=[data(:,:,1),data(:,:,2),data(:,:,3),data(:,:,4),data(:,:,5),data(:,:,6),data(:,:,7),data(:,:,8),data(:,:,9)].*256;

[~, label2]=SRFFCM(data,cluster_n);
%% Display segmentation results
label3=[];
for labelVal=1:N1  
    id=idx{labelVal};
    label3(id)=label2(labelVal);
end
r2 = reshape(label3, m,n);    
figure,imshow(label2rgb(r2)) 



