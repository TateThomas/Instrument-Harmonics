function [model, identifier] = createModel()

    try
        modelData = load("modelData").modelData;
    catch
        model = NaN;
        return
    end
    
    measurementMatrix = modelData{1, 2}{1, 2}(2:10);
    categoryVector = ones(size(measurementMatrix, 1), 1);
    identifier = strcat(modelData{1, 1}, " ", modelData{1, 2}{1, 1});

    nInstruments = size(modelData, 1);
    nHarmonics = size(measurementMatrix, 2);

    for i = 1:nInstruments
        nNotes = size(modelData{i, 2}, 1);
        for j = 1:nNotes
            nMeasurements = size(measurementMatrix, 1);
            nNewMeasurements = size(modelData{i, 2}{j, 2}, 1);
            measurementMatrix(nMeasurements+1:nMeasurements+nNewMeasurements, :) = modelData{i, 2}{j, 2}(:, 2:nHarmonics+1);
            if ~((i == 1) && (j == 1))
                categoryId = categoryVector(nMeasurements, 1) + 1;
                identifier(size(identifier, 1)+1, 1) = strcat(modelData{i, 1}, " ", modelData{i, 2}{j, 1});
            else
                categoryId = 1;
            end
            categoryVector(nMeasurements+1:nMeasurements+nNewMeasurements, 1) = categoryId;
        end
    end

    model = fitcdiscr(measurementMatrix, categoryVector);

end