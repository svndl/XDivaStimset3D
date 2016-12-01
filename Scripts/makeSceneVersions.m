function varargout = makeSceneVersions(scene_name, listVersions, StereoMode)
         
    scene = getScene(scene_name);    
    scene.shift = scene.offset + scene.dH;
    
    d = getDisplay(StereoMode);
    
    nV = numel(listVersions);
    varargout = cell(1, nV + 1);
    useNonius = 0;
    
    for l = 1:nV
        [left, right] = makeStereoPair(scene, d, listVersions{l}, useNonius);
        varargout{l} = cat(d.catDim, left, right);
        
    end


    %% scrambled
    sceneScrambled = scene;
    scrambled_file = [scene.name '_scrambled.mat'];
    if (~exist(scrambled_file, 'file'))
        scrambled = scrambleRGB_PS(scene.left);
        save(scrambled_file, 'scrambled');
    else
        load(scrambled_file);
    end
    % equalize luminance
    gamma_scene = (scene.left.^(1/2.2));
    s0 = (gamma_scene - min(gamma_scene(:)))/(max(gamma_scene(:)) - min(gamma_scene(:)));
    ratio_R = mean(mean(s0(:, :, 1)))/mean(mean(scrambled(:, :, 1)));
    ratio_G = mean(mean(s0(:, :, 2)))/mean(mean(scrambled(:, :, 2)));
    ratio_B = mean(mean(s0(:, :, 3)))/mean(mean(scrambled(:, :, 3)));
    c0 =  ones(size(scene.left, 1), size(scene.left, 2));
    
    sceneScrambled.left = scrambled.*cat(3, c0*ratio_R, c0*ratio_G, c0*ratio_B);
    mean(mean(rgb2gray(sceneScrambled.left)))
    mean(mean(rgb2gray(s0)))
    sceneScrambled.right = sceneScrambled.left;
    useNonius = 1;
    [lS, rS] =  makeStereoPair(sceneScrambled, d, 'O', useNonius);
    %% blank
%     background = 0;
%     blankScene = scene;
%     blankScene.right = background*ones(size(scene.right));
%     blankScene.left = background*ones(size(scene.right));
    %[lS, rS] =  makeStereoPair(blankScene, d, 'O', useNonius);
    
    varargout{nV + 1} =  cat(d.catDim, lS, rS);
end

function [l, r] = makeStereoPair(scene, d, type, useNonius)
  
    [left, right] = getLeftRight(scene, type);
    [shiftSign, crossSign] = getCrossShiftSigns(type);    
    %crossPosR = crossSign.L*scene.offset;
    l = processScene(left, d, shiftSign.L*scene.shift, useNonius);
    if (d.mirrorFlip)
        right = flipdim(right, 2);
    end
    %crossPosR = crossSign.R*scene.offset;
    r = processScene(right, d, shiftSign.R*scene.shift, -useNonius);    
end
function s = processScene(s0, d, shiftVal, useNonius)
    if(useNonius)
        xs = drawNonius(s0, 45, useNonius);
    else
        xs = s0;
    end
    s1 = imresize(xs, [d.v d.h], 'cubic');
    s = positionScene(s1, [d.v d.h], shiftVal);
end
function [left, right] = getLeftRight(s, type)

    %% pull out different versions of left/right
    switch type
        case 'S'
            left = s.left;
            right = s.right;
        case 'O'
            left = s.left;
            right = s.left;
        otherwise
    end
end

function [shiftSign, crossSign] = getCrossShiftSigns(sceneType)
    switch sceneType
        case 'S' 
            % cross sign
            crossSign.L = 1;
            crossSign.R = -1;
        
            % shift sign
            shiftSign.L = 1;
            shiftSign.R = 1;
        case 'O'          
            % cross sign
            crossSign.L = 1;
            crossSign.R = 1;
            % shift sign
            shiftSign.L = 1;
            shiftSign.R = -1;
        otherwise
            crossSign.L = 1;
            crossSign.R = 1;
        
            % shift sign
            shiftSign.L = 1;
            shiftSign.R = 1;            
    end
end