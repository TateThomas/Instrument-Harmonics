function [] = createGraph(nameValueArgs)

    arguments
        nameValueArgs.graphType (1, 1) string = "line"
        nameValueArgs.instrument (1, 1) string = "-"
        nameValueArgs.note (1, 1) string = "-"
        nameValueArgs.modelDataName (1, 1) string = "modelData3"
        nameValueArgs.x (:, :) double = []
        nameValueArgs.y (:, :) double = []
        nameValueArgs.colorChoices (1, :) string = ['r' 'g' 'b' 'c' 'm']
        nameValueArgs.lineStyle (1, :) string = ' '
        nameValueArgs.markerStyle (1, 1) string = '.'
        nameValueArgs.title (1, 1) string = " "
        nameValueArgs.subplotTitle (1, 1) string = " "
        nameValueArgs.plotSeparately logical = true
        nameValueArgs.newFigure logical = true
    end

    
    function [] = plotData(x, y, graphType, colorChoices, lineStyle, markerStyle, plotSeparately)

        if graphType == "line"
            
            colorChoice = 1;
            styleString = strcat(colorChoices{1}(colorChoice), lineStyle, markerStyle);   % set up style string

            % plot first data point depending on option chosen
            if ~plotSeparately
                hold on
                plot(x(1, :), y(1, :), styleString)
            else
                nexttile
                plot(x(1, :), y(1, :), styleString)
                hold on
            end
            xlabel("Frequency");
            ylabel("Relative Amplitude");
            xticks(x(1, 1:2:size(x, 2)));
            xlim([0 x(1, size(x, 2))+x(1, 1)]);
        
            % add data to plot
            for sample = 2:size(x, 1)
                if plotSeparately
                    colorChoice = mod(colorChoice, length(colorChoices{1})) + 1;
                    styleString = strcat(colorChoices{1}(colorChoice), lineStyle, markerStyle);
                end
                plot(x(sample, :), y(sample, :), styleString)
                xlabel("Frequency");
                ylabel("Relative Amplitude");
            end

            if markerStyle == "."
                averageY = sum(y, 1)./size(y, 1);
                plot(x, averageY, "k", "LineWidth", .01);
            end

            hold off

        elseif graphType == "bar"

            bar(x(1, :), y, .25, "LineStyle", "none");
            xlabel("Frequency");
            ylabel("Relative Amplitude");

        end

    end



    if nameValueArgs.newFigure
        figure
    end

    if (nameValueArgs.instrument == "-") && (nameValueArgs.note == "-") && ~isempty(nameValueArgs.x) && ~isempty(nameValueArgs.y)

        plotData(nameValueArgs.x, nameValueArgs.y, nameValueArgs.graphType, nameValueArgs.colorChoices, nameValueArgs.lineStyle, nameValueArgs.markerStyle, nameValueArgs.plotSeparately);
    
        % set title of plot
        if ~nameValueArgs.plotSeparately
            title(nameValueArgs.title)
        else
            title(nameValueArgs.subplotTitle)
            sgtitle(nameValueArgs.title)
        end
    
        hold off

    elseif (nameValueArgs.instrument ~= "-") && (nameValueArgs.note ~= "-")

        try
            modelData = load(nameValueArgs.modelDataName).modelData;
        catch
            error("Model Data with that name does not exist.");
        end

        instrumentName = nameValueArgs.instrument;
        for i = 1:size(modelData, 1)
            string(strcat(modelData{i, 1}));
            instruments(1, i) = string(strcat(modelData{i, 1}));
        end

        instrumentIndex = find(strcmp(instruments, instrumentName));

        if isempty(instrumentIndex)
            error("Instrument not found.");
        end

        instrumentNote = nameValueArgs.note;
        if isempty([modelData{instrumentIndex, 2}{:, 1}])
            error("Note not found");
        else
            noteIndex = find(string(modelData{instrumentIndex, 2}(:, 1)) == instrumentNote);
        end


        fundamentalFreq = str2double(modelData{instrumentIndex, 2}{noteIndex, 1}(2:length(modelData{instrumentIndex, 2}{noteIndex, 1})));
        xData = fundamentalFreq:fundamentalFreq:fundamentalFreq*size(modelData{instrumentIndex, 2}{noteIndex, 2}, 2);
        maxAmplitude = modelData{instrumentIndex, 2}{noteIndex, 2}(:, 1);

        plotData(repmat(xData, size(modelData{instrumentIndex, 2}{noteIndex, 2}, 1), 1), modelData{instrumentIndex, 2}{noteIndex, 2}./maxAmplitude, nameValueArgs.graphType, nameValueArgs.colorChoices, nameValueArgs.lineStyle, nameValueArgs.markerStyle, nameValueArgs.plotSeparately);

        if nameValueArgs.newFigure && ~nameValueArgs.plotSeparately
            title(nameValueArgs.instrument);
            subtitle(nameValueArgs.note);
        else
            title(nameValueArgs.note);
            sgtitle(nameValueArgs.instrument);
        end

    end

end