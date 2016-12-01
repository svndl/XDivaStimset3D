function out = drawHalfCross(image, height, upperlower)
    
    %default value of cross liner;
    outer = 0.5;
    
    if (size(image, 3) > 1)
        outer = mean(mean(rgb2gray(image)));
    else
        outer = mean(image(:));
    end
    % zero offset = > place cross exactly on image center
    offset = [0, 0];
    
    % outer parameters: mean lum, 1 pix off center
    delta_O = 1;
    outer_code = 1;
    
    % inner parameters: white, 1 pix off center
    inner_code = 0.5;
    delta_I = 1;
      
    dummy = zeros(size(image, 1), size(image, 2));   
    center0 = floor([size(image, 1), size(image, 2)]*0.5);
    
    center = center0 + offset; 
    x0 = center(1); y0 = center(2);
    
    %draw inner
    dummy(x0 + 1:upperlower:x0 + height*upperlower,y0 - delta_I:y0 + delta_I) = inner_code;
    dummy(x0 - delta_I + 1:x0 + delta_I, y0:upperlower:y0 + height*upperlower) = inner_code;
    
    %outer boundaries
    outerX = [x0 + upperlower*(height + delta_O), x0 + upperlower*height, ...
        x0 - (delta_I + delta_O), x0 - delta_I, ...
        x0 + delta_I, x0 + delta_I + delta_O];
    
    outerY = [y0 + upperlower*(height + delta_O), y0 + upperlower*height, ...
        y0 - (delta_I + delta_O), y0 - delta_I, ...
        y0 + delta_I, y0 + delta_I + delta_O];
      
    %draw vertical outer
    dummy(outerX(3):outerX(6), outerY(1):-upperlower:outerY(2)) = outer_code;
    dummy(outerX(1):-upperlower:outerX(3), ...
        outerY(4 + upperlower):outerY(5 + upperlower)) = outer_code;
    
    dummy(outerX(1):-upperlower:outerX(6), ...
        outerY(4 - upperlower):outerY(5 - upperlower)) = outer_code;    
   
    %draw horizontal outer
    dummy(outerX(1):-upperlower:outerX(2), outerY(3):outerY(6)) = outer_code;
    dummy(outerX(4 + upperlower):outerX(5 + upperlower), ...
        outerY(1):-upperlower:outerY(3)) = outer_code;
    
    dummy(outerX(4 - upperlower):outerX(5 - upperlower), ...
        outerY(1):-upperlower:outerY(6)) = outer_code;    
    
    %
    dummy = repmat(dummy,[1,1,size(image,3)]);
    out = image;
    out(dummy == 0.5) = 0.7;
    out(dummy == 1) = outer;
end


