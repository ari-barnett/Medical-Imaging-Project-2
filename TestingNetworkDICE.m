load("trained3DUNet-FOLD_1.mat")

a =(niftiread("Data/AugmentedImages/Fold1/BRATS_001.nii_augmented.nii"));
imds = a(140:140+23,75:75+23,75:75+11);
test = semanticseg(imds,net);
test = double(test);

figure('Position', [100, 100, 100, 60]);
subplot(1,2,1)
im2bw(test(:,:,1))


a =(niftiread("Data/AugmentedImagesLabels/Fold1/BRATS_001.nii_augmentedLabels.nii"));
label = double(a(140:140+23,75:75+23,75:75+11));
subplot(1,2,2)
im2bw(label(:,:,1))


DScore_matrix = [];
hd_matrix = [];
for i  = 1:12
    hd = hausdorff_distance(test(:,:,i), label(:,:,i));
    hd_matrix(i) = hd;

    bw1 = im2bw(test(:,:,i));
    bw2 = im2bw(label(:,:,i));
    DScore = dice(test,label);
    DScore_matrix(i) = DScore;
end


function hd = hausdorff_distance(A, B)
    % Calculate the directed Hausdorff distances from A to B and B to A
    hAB = max(min(pdist2(A, B), [], 2));
    hBA = max(min(pdist2(B, A), [], 2));
    
    % Calculate the Hausdorff distance
    hd = max(hAB, hBA);
end