function [] = updateModelData(dataCell, overwrite)

    % load or create cell to store model data
    try
        if overwrite
            error("Overwrite");
        end
        modelData = load("modelData2").modelData;
        nInstruments = size(modelData, 1);  % number of rows in model data
    catch
        modelData = cell(1, 2);
        nInstruments = 0;
    end
    
    n = size(dataCell, 1);   % number of rows in given data
    for i = 1:n

        instrumentName = dataCell{i, 1};
        %[modelData{:, 1}]
        instrumentIndex = find(strcmp([modelData{:, 1}], instrumentName));

        if isempty(instrumentIndex)
            nInstruments = nInstruments + 1;
            instrumentIndex = nInstruments;
            modelData{instrumentIndex, 1} = instrumentName;
            modelData{instrumentIndex, 2} = cell(1, 2);
        end

        m = size(dataCell{i, 2}, 1);    % number of rows in given instrument data
        for j = 1:m

            instrumentNote = dataCell{i, 2}{j, 1};
            if isempty([modelData{instrumentIndex, 2}{:, 1}])
                noteIndex = [];
            else
                noteIndex = find(string(modelData{instrumentIndex, 2}(:, 1)) == instrumentNote);
            end
            measurementIndex = 3;

            if isempty(noteIndex)
                noteIndex = size(modelData{instrumentIndex, 2}, 1) + 1;
                if isempty(modelData{instrumentIndex, 2}{1, 1})
                    noteIndex = 1;
                end
                modelData{instrumentIndex, 2}{noteIndex, 1} = instrumentNote;
                modelData{instrumentIndex, 2}{noteIndex, 2} = dataCell{i, 2}{j, measurementIndex};
            else
                nNoteSamples = size(modelData{instrumentIndex, 2}{noteIndex(1, 1), 2}, 1);
                k = size(dataCell{i, 2}{j, measurementIndex}, 1);   % number of rows in given instrument note data
                modelData{instrumentIndex, 2}{noteIndex(1, 1), 2}(nNoteSamples+1:nNoteSamples+k, :) = dataCell{i, 2}{j, measurementIndex};
            end

        end

    end

    save("modelData2", "modelData");

end