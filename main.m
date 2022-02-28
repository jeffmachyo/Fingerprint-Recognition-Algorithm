clear all
clc
%Set the location of this m-file and the other m-files as the default
%MATLAB directory
%The main.m is the body of the program and it executes the fingerprint
%matching using the cellular automata theory
 
%defining the input image%
[filename,pathname]=uigetfile('*.bmp','Select an image File');
img=imread(fullfile(pathname,filename));
%Resizing the image so as to obtain the region with the important
%characteristics
 
%binarizing the image%
img2=img<(graythresh(img)*255);
%Getting the vertical profile of the image%
vertical_profile=any(img2,2);
%getting the horizontal profile of the image%
horizontal_profile=any(img2,1);
%Obtaining the index of the bounding box%
toprow=find(vertical_profile,1,'first');
bottomrow=find(vertical_profile,1,'last');
leftcol=find(horizontal_profile,1,'first');
rightcol=find(horizontal_profile,1,'last');
%Crop it out of the original image%
croppedimage=img(toprow:bottomrow,leftcol:rightcol);
 
croppedimage2=croppedimage(200:280,80:160);
i2=croppedimage2;
 
%obtaining the image threshold so as to perform binarization
level=graythresh(i2);
 
%Performing the binarization
i3=im2bw(i2,level);
 
%Performing the sliding neighbourhood operation using the cellular automata
%rules set out in the pearsonweight.m file
i4=nlfilter(i3,[3 3],'pearsonweight');
 
found=0; %Found is a variable that determines whether the statement 'match found' or 'no match found' should be output
for a=101:1:103
    for b=1:1:4
        c=strcat(num2str(a),'_',num2str(b),'.bmp');
        j=imread(c);
        level1=graythresh(j);
        j3=im2bw(j,level1);
        cc=normxcorr2(i4,j3);
        cc2=normxcorr2(i3,j3);
        
        [max_cc,imax]=max(abs(cc(:)));
        [max_cc1,imax1]=max(abs(cc2(:)));
        
        if max_cc>=0.2 %the threshold for the recognition of a match%
            disp('Match found');
            max_cc
            max_cc1
            c
            
            found=1;
            break
          
        end
    end
   if a==103 && found == 0
       disp('No Match Found')
   
   end
end
 
