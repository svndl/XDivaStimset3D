function scene = loadScenefromSrc(path)
    
    found = strfind(path, filesep);
    dir_name = path(found(end) + 1:end);
    db_type = strtok(dir_name, '_');
    
    try
        switch db_type
            case 'mb'
                scene = loadMB(path);
             case {'ut','utc'}
               scene = loadUT(path);
        end
    catch err
        disp('LoadImages:Error');
        disp(err.message);
        disp(err.cause);
        disp(err.stack(1));
        disp(err.stack(2));
    end
end
%% LOAD MB
function image = loadMB(path)
    % first -- left, second -- right
    filenames_new = {'im0.png', 'im1.png'};
    filenames_old = {'view1.png', 'view5.png'};
    
    if (exist([path filesep filenames_new{1}], 'file'))
        filenames = filenames_new;
    else
        filenames = filenames_old;
    end
    
    left_im = fullfile(path, filesep, filenames{1});
    right_im = fullfile(path, filenames{2});
            
    
    %% MB images are gamma-corrected, stored as 8 bit PNG!
    image.right = (double(imread(right_im))/(2^8 - 1)).^2.2;
    image.left = (double(imread(left_im))/(2^8 - 1)).^2.2;
end

%% LOAD UT
function image = loadUT(path)

    found = strfind(path, filesep);
    dir_name = path(found(end) + 1:end);

    findnumber = strfind(dir_name, '_');
    filenumber = dir_name((findnumber(end) + 1):end);
    
    % UT images are LINEAR 16-bit PNG files
    
    read_fmt = 'png';
     
    image.right = double(imread([path filesep 'rImage' filenumber 'LinRGB'], read_fmt))/(2^16 - 1);
    image.left = double(imread([path filesep 'lImage' filenumber 'LinRGB'], read_fmt))/(2^16 - 1);    
end

