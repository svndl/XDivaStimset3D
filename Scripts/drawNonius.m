function out = drawNonius(image, height, upperlower)
    
    %default value of cross liner;
    outer = 0.5;
  
    % zero offset = > place cross exactly on image center
    offset = [0, 0];
    
    % outer parameters: mean lum, 1 pix off center
    delta_O = 3;
    outer_code = 1;
    
    % inner parameters: white, 1 pix off center
    inner_code = 0.5;
    delta_I = 3;
    
    %gap between the dot and the line
    gap = 5;
      
    dummy = zeros(size(image, 1), size(image, 2));   
    center0 = floor([size(image, 1), size(image, 2)]*0.5);
    
    center = center0 + offset; 
    x0 = center(1); y0 = center(2);
    
    %draw innner dot
    dummy(x0 - delta_I:x0 + delta_I, y0 - delta_I:y0 + delta_I) = inner_code;
    % draw outer dot boundaries
    
    dummy(x0 - delta_I - delta_O:x0 - delta_I - 1 , y0 - delta_I - delta_O:y0 + delta_I + delta_O) = outer_code;
    dummy(x0 + delta_I + 1:x0 + delta_I + delta_O, y0 - delta_I - delta_O:y0 + delta_I + delta_O) = outer_code;
    
    dummy(x0 - delta_I - delta_O:x0 + delta_I + delta_O, y0 - delta_I - delta_O:y0 - delta_I - 1) = outer_code;
    dummy(x0 - delta_I - delta_O:x0 + delta_I + delta_O, y0 + delta_I + 1:y0 + delta_I + delta_O) = outer_code;
    
        
    d1 = drawVertNonius(dummy, x0, y0, delta_I, delta_O, gap, height, inner_code, outer_code);  
    d2 = drawVertNonius(rot90(d1, 1), y0, x0, delta_I, delta_O, gap + 1, height, inner_code, outer_code);
        
    % 1 for upper, -1 for lower
    if (upperlower > 0)
        d2 = rot90(d2, 2);
    end
    dummyOut = repmat(d2',[1,1,size(image, 3)]);
    
    out = image;
    out(dummyOut == 0.5) = 0.9;
    out(dummyOut == 1) = outer;
end

function dummyOut = drawVertNonius(dummyIn,x0, y0, delta_I, delta_O, gap, height, inner_code, outer_code)
    
    dummyOut = dummyIn;
    
    xI = [x0 + gap + delta_I + delta_O, height + x0 + gap + delta_I + delta_O]; 
    yI = [y0 - delta_I, y0 + delta_I];
    
    xO = [xI(1) - delta_O, xI(2) + delta_O];
    yO = [yI(1) - delta_O, yI(2) + delta_O];
    
    dummyOut(xI(1):xI(2), yI(1):yI(2)) = inner_code;    
    
    dummyOut(xO(1):xO(2), yO(1):yI(1)) = outer_code;
    dummyOut(xO(1):xO(2), yI(2):yO(2)) = outer_code;

    dummyOut(xO(1):xI(1), yO(1):yO(2)) = outer_code;
    dummyOut(xI(2):xO(2), yO(1):yO(2)) = outer_code;
    
%     dummyOut(xO(1):xO(2), yO(1):yI(1)) = outer_code;
%     dummyOut(xO(1):xO(2), yO(2):yI(2)) = outer_code;
% 
%     dummyOut(xO(1):xO(2), yO(1):yI(1)) = outer_code;
%     dummyOut(xO(1):xO(2), yO(2):yI(2)) = outer_code; 
end