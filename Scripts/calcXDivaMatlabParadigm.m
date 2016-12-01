function TotalFrames = calcXDivaMatlabParadigm(freq)

    monitorFrequency = 60;    
    desiredCoreDuration = 1;
    
    nCoreBins = 4;
    nPreludeBins = 0;
    nCoreSteps = 4;
    
    
    nFrmPerTotalCycle = monitorFrequency/freq;
    %% calc desired numbers
%     desiredBinDuration = desiredCoreDuration/nCoreBins;
%     desiredStepDuration = desiredCoreDuration/nCoreSteps;
    
    %minofTwo = min(desiredBinDuration, desiredStepDuration);
    
    %sbs = shortest of bin/step
    nCoreSBS = max(nCoreBins, nCoreSteps);
    
	totalCycleS	= 1/freq;
	sbsDurationS = desiredCoreDuration/nCoreSBS;
	totalCyclesPerSBS = round(sbsDurationS/totalCycleS);
    
    if( totalCyclesPerSBS == 0)	
        totalCyclesPerSBS  = 1;
    end

	%newActualCoreDurS	= totalCyclesPerSBS*totalCycleS * nCoreSBS;
	newNmbFramesPerSBS	= totalCyclesPerSBS*nFrmPerTotalCycle;
    TotalFrames = nCoreSBS*totalCyclesPerSBS*newNmbFramesPerSBS;
end