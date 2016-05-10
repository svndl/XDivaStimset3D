function varargout = makeSceneVersions(scene_name, listVersions, StereoMode)
         
    scene = getScene(scene_name);    
    scene.shift = scene.offset + scene.dH;
    
    d = getDisplay(StereoMode);
    
    nV = numel(listVersions);
    varargout = cell(1, nV + 1);
    
    for l = 1:nV
        [left, right] = makeStereoPair(scene, d, listVersions{l});
        varargout{l} = cat(d.catDim, left, right);
        
    end
    background = 0;
    %% blank
    blankScene = scene;
    blankScene.right = background*ones(size(scene.right));
    blankScene.left = background*ones(size(scene.right));
    
    [lB, rB] =  makeStereoPair(blankScene, d, 'O');
    varargout{nV + 1} =  cat(d.catDim, lB, rB);
end


function [l, r] = makeStereoPair(scene, d, type)
  
    [left, right] = getLeftRight(scene, type);
    [shiftSign, crossSign] = getCrossShiftSigns(type);    
    l = processScene(left, d, shiftSign.L*scene.shift, crossSign.L*scene.offset);
    if (d.mirrorFlip)
        right = flipdim(right, 2);
    end
    r = processScene(right, d, shiftSign.R*scene.shift, crossSign.R*scene.offset);    
end
function s = processScene(s0, d, shiftVal, crossPos)
    s1 = imresize(s0, [d.v d.h]);
    xs = drawCross(s1, 30, crossPos);
    s = positionScene(xs, [d.v d.h], shiftVal);
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