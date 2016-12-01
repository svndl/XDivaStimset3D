function nScrambled = scrambleRGB(inImage)
    nScrambled = uint8(ones(size(inImage)));
    inImage = (double(inImage)).^(1/2.2);
    
    inImage = (inImage - min(inImage(:)))/(max(inImage(:)) - min(inImage(:)));
    
    %shift the phases of all channels by equal and rand matrix
    randPhase = angle(fft2(rand(size(inImage, 1), size(inImage, 2))));
    
    % gamma-correct 
    for ch = 1:size(inImage, 3)
        currImCh = double(squeeze(inImage(:, :, ch)));
        % range of current channel 
        
        minImageCh = min(currImCh(:));
        maxImageCh = max(currImCh(:));
        inSpectra_ch = fft2(currImCh);
        imMag_ch = abs(inSpectra_ch);
        imPhase_ch = angle(inSpectra_ch);
                
        %randImg = minImageCh + (maxImageCh - minImageCh).*rand(size(imMag_ch));
        
        shiftedPhase_ch = - pi + mod(imPhase_ch + randPhase, 2*pi);
        scrambled = ifft2(imMag_ch.*exp(1i.*shiftedPhase_ch), 'symmetric');
        
        %normalize each channel to 0-255
        minS = min(scrambled(:));
        maxS = max(scrambled(:));
        normScr = (scrambled - minS)/(maxS - minS);
        
        %normalize to a given range
        range2 = maxImageCh - minImageCh;
        nScrambled(:, :, ch) = uint8(normScr*range2 + minImageCh);         
    end
end
