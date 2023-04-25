%Training Network;

%Define 3D-UNet 
imageSize = [240 240 156 1];
numClasses = 4;
encoderDepth = 2;

lgraph = unet3dLayers(imageSize,numClasses,"EncoderDepth",encoderDepth) ;


%Visualize Network
figure('Units','Normalized','Position',[0 0 0.5 0.55]);
plot(lgraph)
title("3D-UNet Architecture for Neuro-Oncologic Tumor Segmentation","FontSize",18)


%Augment Images
imds = imageDatastore('imagesTr/', 'FileExtensions', '.gz');
for i = 1:height(imds.Files)
    [~, imageName, imageExt] = fileparts(imds.Files{i});
    V = niftiread(imds.Files{i});
    for j = 1:4
        V(:,:,156,j) = zeros(240,240);
    end
    outputFilename = fullfile('Data/AugmentedImages/', [imageName, '_augmented', imageExt]);
    niftiwrite(V(:,:,:,1), outputFilename);
end

%Augments Labels
labels = imageDatastore('labelsTr/', 'FileExtensions', '.gz');
for i = 1:height(labels.Files)
    [~, imageName, imageExt] = fileparts(labels.Files{i});
    V = niftiread(labels.Files{i});
    for j = 1:4
        V(:,:,156,j) = zeros(240,240);
    end
    outputFilename = fullfile('Data/AugmentedImagesLabels/', [imageName, '_augmentedLabels', imageExt]);
    niftiwrite(V(:,:,:,1), outputFilename);
end

save("3D_UNET.mat", "lgraph");
