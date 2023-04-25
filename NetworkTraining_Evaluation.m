%Train Network

for folds = 1:5
    volLoc = fullfile("Data/AugmentedImages/Fold" + folds);
    volds = imageDatastore(volLoc,FileExtensions=".nii",ReadFcn=@niftiread);
    
    lblLoc = fullfile("Data/AugmentedImagesLabels/Fold" + folds);
    classNames = ["background","non_enhancing_tumor","peritumoral_edema","GD_enhancing_tumor"];
    pixelLabelID = [0 1 2 3];
    pxds = pixelLabelDatastore(lblLoc,classNames,pixelLabelID, ...
        FileExtensions=".nii",ReadFcn=@niftiread);
    
    
    patchds = randomPatchExtractionDatastore(volds,pxds,[24 24 12], ...clear
        PatchesPerImage=16);
    
    
    training = combine(volds,pxds);
    
    volLocVal = fullfile("Data/validation/");
    voldsVal = imageDatastore(volLocVal,FileExtensions=".nii", ...
        ReadFcn=@niftiread);
    
    lblLocVal = fullfile("Data/validationlabels/");
    pxdsVal = pixelLabelDatastore(lblLocVal,classNames,pixelLabelID, ...
        FileExtensions=".nii",ReadFcn=@nifitread);
    
    dsVal = randomPatchExtractionDatastore(voldsVal,pxdsVal,[24 24 12], ...
        PatchesPerImage=16);
    
    val = combine(voldsVal,pxdsVal);
    
    imageSize = [24 24 12 1];
    numClasses = 4;
    encoderDepth = 2;
    lgraph = unet3dLayers(imageSize,numClasses,"EncoderDepth",encoderDepth) ;
    
    
    options = trainingOptions("adam", ...
        MaxEpochs=5, ...
        InitialLearnRate=1e-3, ...
        ValidationData=dsVal, ...
        ValidationFrequency=5, ...
        Plots="training-progress", ...
        Verbose=true, ...
        MiniBatchSize=10,...
        ExecutionEnvironment="parallel",...or
        ValidationPatience=2);
    
    
    doTraining = true;
    if doTraining
        [net,info] = trainNetwork(patchds,lgraph,options);
        modelDateTime = string(datetime("now",Format="yyyy-MM-dd-HH-mm-ss"));
        save("trained3DUNet-FOLD_"+ folds + "_"+modelDateTime+".mat","net");
    end
end


function data = nifitread(filename)
    data = niftiread(filename);
end
