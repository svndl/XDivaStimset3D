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
    
    StimFreq = 0.375;
    previewImagesOnly = 1;    
    
    generateAll(listOfScenes, ListofVersions, DisplaySettings, StimFreq, previewImagesOnly, mpath);  
end

function generateAll(listOfScenes, ListofVersions, DisplaySettings, StimFreq, previewImagesOnly, mpath)
    
    nScenes = numel(listOfScenes);
    rndScenes = randperm(nScenes);
    i = 1;
    imageSequence = calcImageSeq2AFC(StimFreq);
    roosterName = strcat(mpath.results, filesep, 'ScenesAllCND.txt');
    f = fopen(roosterName, 'w+');
    
    
    while i <= nScenes
                
        num = rndScenes(i);
        list_name = strtok(listOfScenes(num).name, '.');        
        disp(['Generating ' list_name]);
        
        fprintf(f, 'Conditions SO:OS, Trial %d Scene %s\n', i, list_name);
        
        [sceneS, sceneO, blank] = makeSceneVersions(list_name, ListofVersions, DisplaySettings);
                      
        %% SO, OS trials     
        writeXDivaStim(mpath.results, blank, sceneS, blank, sceneO, 'SO', i, imageSequence, previewImagesOnly);
        writeXDivaStim(mpath.results, blank, sceneO, blank, sceneS, 'OS', i, imageSequence, previewImagesOnly);
        i = i + 1;
    end
    fprintf(f, 'Set generated on %s', datestr(clock));   
    fclose(f);
end