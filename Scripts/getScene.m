function scene = getScene(scene_name)
    path = main_setPath;
    try
        load([path.matimages filesep scene_name]);
    catch
        scene = loadScenefromSrc([path.source filesep scene_name]); 
        %place crosses
        scene.offset = -0.5*calc_estimateDisparity(scene.left, scene.right);
        scene.dH = [0 0];
        scene.name = scene_name;
        rx = edit_drawCross(scene.right, 30, [scene.offset(1), -scene.offset(2)]);
        lx = edit_drawCross(scene.left, 30, [scene.offset(1), scene.offset(2)]);
    
        d = calc_getDisplay('topbottom');
        shiftH = scene.offset + scene.dH;
        lrx = imresize(lx, [d.v, d.h]);
        rrx = imresize(rx, [d.v, d.h]);
    
        lA = edit_positionScene(lrx, [d.v, d.h], shiftH, 'hv');
        rA = edit_positionScene(rrx, [d.v, d.h], shiftH, 'hv');
   
        sceneA = cat(2, lA, rA);
        sceneA = sceneA.^(1/2.2);
        imwrite(sceneA, [path.matimages filesep 'gui_' scene.name '.jpeg']);

        save([path.matimages filesep scene_name '.mat'], 'scene');
        
        
        
    end
end