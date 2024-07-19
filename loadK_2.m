function [posiTuningImgCopy, posiTuningImgCopy_OFF, trSub, trSub_OFF, stimOnset, imgMask, K] = loadK_2()
    tic
    cd /home/range1-raid2/sgwarren-data/Deviant/Kananga/Data/Deviant/K
    off = load('DeviantOn_AlignTo_stimulusOnTime.mat');
    cd ~/matlab/OpticalImagingProject
    
    offImg = ImageHelper.convertSparseToFull(off.S, off.IX, off.V); 
    cd ~/matlab/OpticalImagingProject/SGD

    tr = off.T; numTr = size(offImg, 4); deviantPos_ON = zeros(1, numTr);
    for i = 1:numTr; deviantPos_ON(i) = tr(i).trialDescription.deviantPosition; end
    imgB_ON = cell(1, length(unique(deviantPos_ON))); 
    for i = 1:18; imgB_ON{i} = offImg(:,:,:,deviantPos_ON == (i-1)); end
    
    for i = 1:numTr; stimInd_ON(i) = off.T(i).trialDescription.stimulusIndex; end
    trSub = off.T(~(stimInd_ON == -1));

    clear offImg i off deviantPos_ON numTr
    
    cd /home/range1-raid2/sgwarren-data/Deviant/Kananga/Data/Deviant/K
    off = load('DeviantOff_AlignTo_stimulusOnTime.mat');
    cd ~/matlab/OpticalImagingProject

    offImg_OFF = ImageHelper.convertSparseToFull(off.S, off.IX, off.V); 
    cd ~/matlab/OpticalImagingProject/SGD

    tr_OFF = off.T; numTr_OFF = size(offImg_OFF, 4); deviantPos_OFF = zeros(1, numTr_OFF);
    for i = 1:numTr_OFF; deviantPos_OFF(i) = tr_OFF(i).trialDescription.deviantPosition; end
    imgB_OFF = cell(1, length(unique(deviantPos_OFF)));
    for i = 1:18; imgB_OFF{i} = offImg_OFF(:,:,:,deviantPos_OFF == (i-1)); end
    
    for i = 1 : numTr_OFF; stimInd_OFF(i) = off.T(i).trialDescription.stimulusIndex; end
    trSub_OFF = off.T(~(stimInd_OFF == -1));

    clear offImg_OFF i off deviantPos_OFF numTr_OFF
    
    clc; clear ran; timeWindow = 2:20; stimOnset = 11; imgMask = []; K = 2; 
    if exist('posiTuningImg'); clear posiTuningImg; end
    posiTuningImg = imgB_ON(1:end); posiTuningImg = cellfun(@(x) permute(x,[1 2 4 3]), posiTuningImg, 'UniformOutput', 0);posiTuningImgCopy = posiTuningImg; clear imgB_ON
    
    clc; clear ran_O; timeWindow = 2:20; stimOnset = 11; imgMask = []; K = 2; 
    if exist('posiTuningImg'); clear posiTuningImg_OFF; end
    posiTuningImg_OFF = imgB_OFF(1:end); posiTuningImg_OFF = cellfun(@(x) permute(x,[1 2 4 3]), posiTuningImg_OFF, 'UniformOutput', 0);posiTuningImgCopy_OFF = posiTuningImg_OFF; clear imgB_OFF
    toc

    clear posiTuningImg posiTuningImg_OFF 
end
