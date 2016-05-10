function scene = getScene(scene_name)
    path = main_setPath;
    try
        load([path.matimages filesep scene_name]);
    catch
        scene = loadScenefromSrc([path.source filesep scene_name]); 
        %place crosses
        scene.offset = -0.5*estimateDisparity(scene.left, scene.right);
        scene.dH = -scene.offset;
        scene.name = scene_name;
        save([path.matimages filesep scene_name '.mat'], 'scene');
    end
end