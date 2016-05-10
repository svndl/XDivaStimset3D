function mpath = main_setPath

    %
    % add all scene-filter-see subfolders to your path
    [curr_path, ~, ~] = fileparts(mfilename('fullpath'));
    mpath.home = curr_path;
    addpath(mpath.home);

    %default source location
    mpath.source   = [mpath.home filesep 'SrcData'];
    
    %location for matfiles
    mpath.matimages   = [mpath.home filesep 'Data'];
    
    %location for results  
    mpath.results = [mpath.home filesep 'XDivaStimsets'];

    if (~exist(mpath.results, 'dir'))
        mkdir(mpath.results);
    end
    if (~exist(mpath.matimages, 'dir'))
        mkdir(mpath.matimages);
    end
end



