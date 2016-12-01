function writeXDivaStim(where, blankA, sceneA, blankB, sceneB, ConditionType, number, imageSequence, previewImagesOnly)

        %linearize blankA, blankB
        gamma = 2.2;
        
        images(:, :, :, 1) = uint8(255*(blankA.^gamma));        
        images(:, :, :, 2) = uint8(255.*sceneA);
        images(:, :, :, 3) = uint8(255.*(blankB.^gamma));        
        images(:, :, :, 4) = uint8(255.*sceneB);
        images(:, :, :, 5) = uint8(zeros(size(sceneB)));
                   
        number = [num2str(floor(number/10)) num2str(rem(number, 10))];
        filename = [ConditionType  '_' number];
        jpeg_dir = [where filesep 'jpegs'];
        
        if (~exist(jpeg_dir, 'dir'))
            mkdir(jpeg_dir);
        end

        sA = sceneA.^(1/gamma);
        sB = sceneB.^(1/gamma);
        
        bA = uint8(255*blankA);
        bB = uint8(255*blankB);
        
        
        imwrite(sA, fullfile(jpeg_dir,[filename 'A.jpeg']));
        imwrite(sB, fullfile(jpeg_dir, [filename 'B.jpeg']));
        
        
        imwrite(bA, fullfile(jpeg_dir, [filename 'A_blank.jpeg']));
        imwrite(bB, fullfile(jpeg_dir, [filename 'B_blank.jpeg']));
                
        
        if (~previewImagesOnly)
            save(strcat(where, filesep, filename, '.mat'), 'images', 'imageSequence');
        end
end

