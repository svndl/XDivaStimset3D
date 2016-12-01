function imageSequence = genImageSequence(freq, nBins)

    nFrames = calcXDivaMatlabParadigm(freq);
    %bin = image
    framesPerBin = nFrames/nBins;
        
    imageSequence = uint32(zeros(nFrames, 1));
    imageSequence(1) = 1;
    imageSequence(framesPerBin + 1) = 2;
    imageSequence(2*framesPerBin + 1) = 3;
    imageSequence(3*framesPerBin + 1) = 4;    
    imageSequence(nFrames, 1) = 5;    
end