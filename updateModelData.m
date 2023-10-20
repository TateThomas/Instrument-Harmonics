function [] = updateModelData(dataCell, overwrite)

    % load or create cell to store model data
    try
        if overwrite
            error("Overwrite");
        end
        modelData = load("modelData");
        nInstruments = size(modelData, 1);  % number of rows in model data
    catch
        modelData = cell(1, 2);
        nInstruments = 0;
    end
    
    n = size(dataCell, 1);   % number of rows in given data
    for i = 1:n

        instrumentName = dataCell{i, 1};
        instrumentIndex = find(strcmp(modelData{:, 1}, instrumentName));

        if isempty(instrumentIndex)
            nInstruments = nInstruments + 1;
            instrumentIndex = nInstruments;
            modelData{instrumentIndex, 1} = instrumentName;
            modelData{instrumentIndex, 2} = cell(1, 2);
        end

        m = size(dataCell{i, 2}, 1);    % number of rows in given instrument data
        for j = 1:m

            instrumentNote = dataCell{i, 2}{j, 1};
            %modelData{i, 2}
            noteIndex = find(strcmp(modelData{i, 2}{:, 1}, instrumentNote));
            measurementIndex = 3;
            %noteIndex

            if isempty(noteIndex)
                noteIndex = size(modelData{i, 2}, 1) + 1;
                %modelData{i, 2}{1, 1}
                if isempty(modelData{i, 2}{1, 1})
                    noteIndex = 1;
                end
                modelData{i, 2}{noteIndex, 1} = instrumentNote;
                modelData{i, 2}{noteIndex, 2} = dataCell{i, 2}{j, measurementIndex};
                %modelData{i, 2}
            else
                nNoteSamples = size(modelData{i, 2}{noteIndex, measurementIndex}, 1);
                k = size(dataCell{i, 2}{j, measurementIndex}, 1);   % number of rows in given instrument note data
                modelData{i, 2}{noteIndex, 2}(nNoteSamples+1:nNoteSamples+1+k, :) = dataCell{i, 2}{j, measurementIndex}(:, 1:10);
            end

        end

    end

    save("modelData", "modelData");

end