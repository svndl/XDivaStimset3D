function scenes = loadXDivaScene(type)    
    path = main_setPath;

    %% first, look for the gui scenes
    search_path = path.matimages;
    subList = dir([search_path filesep type '*']);
    
    %% no gui scenes, check mat scenes folder
    if (isempty(subList))
        search_path =  path.source;
        subList = dir([search_path filesep type '*']);
    end
    if (~isempty(subList))
        s = loadListElements(subList);
    end
    scenes = s(~cellfun(@isempty, s));
 end

function s = loadListElements(list)
    nS = length(list);
    s = cell(nS, 1);
    
    for i = 1:nS
        try            
            s{i} =  getScene(list(i).name);          
        catch
            %do nothing, we'll remove empty cells afterwards
        end
    end
end


