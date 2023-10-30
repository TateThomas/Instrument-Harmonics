
% SAMPLE VARIABLES
nSets = 6;               % number of sets of samples
nSamples = 5;            % number of samples to take
countdownTime = .75;     % time between countdown numbers
restTime = 1.5;            % time in seconds between samples

% RECORDING VARIABLES
Fs = 44100;         % sampling frequency
recDuration = 3;    % record duration in seconds
nBits = 16;         % sample bit precision
nChannels = 2;

% HARMONICS VARIABLES
minPeak = 250;      % minimum amplitude of first harmonic peak
nHarmonics = 15;    % number of harmonics to find

% PLOT VARIABLES
colorStyles = ['r' 'g' 'b' 'c' 'm' 'y' 'k', 'w'];    % red, green, blue, cyan, magenta, yellow, black, white
lineStyles = [' ' '-' '--' ':' '-.'];                % none, solid line, dashed line, dotted line, dash-dotted line
markerStyles = [' ' 'o' '+' '.' 'x' '_' '|'];        % none, circle, plus sign, point, cross, horizontal line, vertical line

colorChoices = [1 6 2 3 4 5];                        % choice of colors to loop through
lineChoice = 2;                                      % line style choice
markerChoice = 3;                                    % marker style choice
plotSetsSeparate = true;                            % plot the sets on different plots if true, or plot all on one plot otherwise


% ============= EXECUTION STARTS HERE ============= %

% initialize matrices
harmonicsData = zeros(1, nHarmonics);
relativeAmpData = zeros(1, nHarmonics);
dataCollection = cell(nSets, 3);
allData = cell(1, 2);

% reset plots
clf('reset');

% get instrument name if samples are being recorded
if nSamples > 0
    instrumentName = input('What is the instrument for these samples?', 's');
    [allData{1, 1}] = instrumentName;
end

% sample iterations
for i = 1:nSets

    fprintf('\n\nSET %d:\n', i);
    setName = input('What is the name of this set of samples?', 's');
    nSampleErrors = 0;  % keeps track of how many samples have all 0's which have been left out of final data

    %hold on
    j = 1;
    while j <= nSamples

        fprintf('\nSAMPLE %d:\n', j);
        [x, y] = recordSample(Fs, recDuration, nBits, nChannels, countdownTime);   % records sample, performs fft
        [tempHarmonicsData, tempRelativeAmpData] = findHarmonics(x, y, nHarmonics, minPeak);    % finds the harmonics in the fft data
        if sum(tempRelativeAmpData) ~= 0
            harmonicsData(j, :) = tempHarmonicsData;
            relativeAmpData(j, :) = tempRelativeAmpData;
            j = j + 1;
        else
            disp('This sample has failed. Retry.')
        end
        %plot(x, y)
        pause(restTime)     % rest in between samples

    end
    %hold off

    dataCollection{i, 1} = setName;             % add set name to cell array
    dataCollection{i, 2} = harmonicsData;       % add harmonics data to cell array
    dataCollection{i, 3} = relativeAmpData;     % add relative amplitude data to cell array

    colorChoice = mod(i - 1, length(colorChoices)) + 1;     % choose color for first data points
    styleString = strcat(colorStyles(1, colorChoices(1, colorChoice)), lineStyles(1, lineChoice), markerStyles(1, markerChoice));   % set up style string

    % plot first data point depending on option chosen
    if (~plotSetsSeparate) && (i == 1)
        plot(harmonicsData(1, :), relativeAmpData(1, :), styleString)
        hold on
    elseif ~plotSetsSeparate
        plot(harmonicsData(1, :), relativeAmpData(1, :), styleString)
    else
        nexttile
        plot(harmonicsData(1, :), relativeAmpData(1, :), styleString)
        hold on
    end

    % add data to plot
    for sample = 2:nSamples
        if plotSetsSeparate
            colorChoice = mod(i + sample - 1, length(colorChoices)) + 1;
            styleString = strcat(colorStyles(1, colorChoices(1, colorChoice)), lineStyles(1, lineChoice), markerStyles(1, markerChoice));
        end
        plot(harmonicsData(sample, :), relativeAmpData(sample, :), styleString)
    end

    % set title of plot
    if (~plotSetsSeparate) && (i == 1)
        title(instrumentName)
    else
        title(setName)
    end

    % turn hold off
    if plotSetsSeparate || (i == nSets)
        hold off
    end

end

% update model if samples were taken
if nSamples > 0
    [allData{1, 2}] = deal(dataCollection);
    updateModelData(allData, false);
end
[model, identifier] = createModel();    % create model for testing

userContinue = lower(input("Would you like to test a sample? yes/no", 's')) == "yes";
while userContinue

    [x, y] = recordSample(Fs, recDuration, nBits, nChannels, countdownTime);   % records sample, performs fft
    [testHarmonicsData, testRelativeAmpData] = findHarmonics(x, y, nHarmonics, minPeak);    % finds the harmonics in the fft data
    
    identifier(predict(model, testRelativeAmpData(1, 2:10)))

    userContinue = lower(input("Would you like to test another sample? yes/no", 's')) == "yes";

end
