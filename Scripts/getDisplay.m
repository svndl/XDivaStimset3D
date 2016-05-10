function display = getDisplay(StereoMode)
    X = 16;
    Y = 9;
        
    %max vertical and horisontal resolution w. respect to aspect ratio    
    vert = 1080;
    horiz = 1080*X/Y;
    
    switch StereoMode
        case 'leftright'
            vScale = 1;
            hScale = 0.5;
            catDim = 2;
            mirror = 0;            
        case 'topbottom'
            vScale = 0.5;
            hScale = 1;
            mirror = 0;
            catDim = 2;
        case 'mirror'
            vScale = 1;
            hScale = 1;
            mirror = 1;
            catDim = 2;
    end
    display.v = round(vert*vScale);
    display.h = round(horiz*hScale);
    display.catDim = catDim;
    display.mirrorFlip = mirror;
end