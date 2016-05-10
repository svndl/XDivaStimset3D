function writeXDivaStim(where, blankA, sceneA, blankB, sceneB, ConditionType, number, imageSequence, previewImagesOnly)

        images(:, :, :, 1) = single(blankA);        
        images(:, :, :, 2) = single(sceneA);
        images(:, :, :, 3) = single(blankB);        
        images(:, :, :, 4) = single(sceneB);
                   
        number = [num2str(floor(number/10)) num2str(rem(number, 10))];
        filename = [ConditionType  '_' number];
        jpeg_dir = [where filesep 'jpegs'];
        
        if (~exist(jpeg_dir, 'dir'))
            mkdir(jpeg_dir);
        end
        
        imwrite(sceneA.^(1/2.2), fullfile(jpeg_dir,[filename 'A.jpeg']));
        imwrite(sceneB.^(1/2.2), fullfile(jpeg_dir, [filename 'B.jpeg']));
        
%         imwrite(blankA, fullfile(jpeg_dir, [filename 'blankA.jpeg']));
%         imwrite(blankB, fullfile(jpeg_dir, [filename 'blankB.jpeg']));
        if (~previewImagesOnly)
            save(strcat(where, filesep, filename, '.mat'), 'images', 'imageSequence');
        end
end

