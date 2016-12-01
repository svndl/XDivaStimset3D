function main_generateStimSet()
     
    mpath = main_setPath;
    %by default, use SRC scenes!
    
    listOfScenes = dir2([mpath.matimages filesep '*.mat']);
    if (isempty(listOfScenes))
        listOfScenes = dir2(mpath.source);
    end
    if (isempty(listOfScenes))
        error('Scenes not found, exiting the script');
    end
    %rndScenes = randperm(numel(listOfScenes));
    ListofVersions = {'S', 'O'};
    DisplaySettings = 'leftright';
    
    onscreen_time = 4*0.75;
    
    StimFreq = 4*(1/onscreen_time);
    nBins = 4;
    previewImagesOnly = 0;  
    
    generateAll(listOfScenes, ListofVersions, DisplaySettings, StimFreq, nBins, previewImagesOnly, mpath);  
end

function generateAll(listOfScenes, ListofVersions, DisplaySettings, StimFreq, nBins, previewImagesOnly, mpath)
    
    nScenes = numel(listOfScenes);
    %rndScenes = randperm(nScenes);
    %rndScenes = listOfScenes;
    
    i = 1;
    imageSequence = genImageSequence(StimFreq, nBins);
    roosterName = strcat(mpath.results, filesep, 'ScenesAllCND.txt');
    f = fopen(roosterName, 'w+');
    
    
    while i <= nScenes
                
        %num = rndScenes(i);
        num = i;
        list_name = strtok(listOfScenes(num).name, '.');        
        disp(['Generating ' list_name]);
        
        fprintf(f, 'Conditions SO:OS, Trial %d Scene %s\n', i, list_name);
        
        [sceneS, sceneO, blank] = makeSceneVersions(list_name, ListofVersions, DisplaySettings);
                      
        %% SO, OS trials     
        writeXDivaStim(mpath.results, double(blank), sceneS, double(blank), sceneO, 'SO', i, imageSequence, previewImagesOnly);
        writeXDivaStim(mpath.results, double(blank), sceneO, double(blank), sceneS, 'OS', i, imageSequence, previewImagesOnly);
        i = i + 1;
    end
    fprintf(f, 'Set generated on %s', datestr(clock));   
    fclose(f);
end