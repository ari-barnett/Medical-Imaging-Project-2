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


