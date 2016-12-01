function nScrambled = scrambleRGB_PS(inImage)
    xyc = 0.5*size(inImage);
    xy = size(inImage);
    
    % Synthetic image dimensions(multiples of 32)
    dx = 256;
    dy = 448;
    
    Nsx = 2*dy;  
    Nsy = 2*dx;
    
    gamma = 2.2;
    %cut the center 
    centerCut = inImage(xyc(1) - dx:xyc(1) + dx - 1, xyc(2) - dy:xyc(2) + dy - 1, :);
    
    centerCutGamma = 255*(double(centerCut)).^(1/gamma);
    %centerCutGamma = uint8(255*(centerCutGamma - min(centerCutGamma(:))/ (max(centerCutGamma(:) - min(centerCutGamma(:))))));
    % 
    Nsc = 3; % Number of pyramid scales
    Nor = 4; % Number of orientations
    Na = 9; % Number of spatial neighbors considered for spatial correlations
    Niter = 10; % Number of iterations of the synthesis loop

    [params] = textureColorAnalysis(centerCutGamma, Nsc, Nor, Na);
    synth = textureColorSynthesis(params, [Nsy Nsx], Niter);
    resized = imresize(synth, [xy(1) xy(2)]);
    
    %resize and undo the gamma-correction
    nScrambled = ( double(resized - min(resized(:))) )./( double(max(resized(:)) - min(resized(:))));
end