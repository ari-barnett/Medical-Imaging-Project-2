V = niftiread("imagesTr/BRATS_002.nii.gz");
volumeData = V(:, :, :, 1);
a = volumeData(:,:,78);
volshow(volumeData,Colormap=jet);


V = niftiread("labelsTr/BRATS_002.nii.gz");
volumeData = V(:, :, :, 1);

sliceViewer(volumeData)
b = volumeData(:,:,78);
c = double(a) + double(b);
%imagesc(c);

% Define the colormaps for each image
cmap1 = gray(256);
cmap2 = jet(256);

rgbImg1 = ind2rgb(im2uint8(mat2gray(a)), cmap1);
rgbImg2 = ind2rgb(im2uint8(mat2gray(b)), cmap2);

% Define the blending function and transparency (alpha) values
blendFunction = @(x, y) x .* (1 - y) + y;

% Blend the two RGB images together
blendedImg = blendFunction(rgbImg1, rgbImg2);

% Display the blended image
figure;
imshow(blendedImg);
