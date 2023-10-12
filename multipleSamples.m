
% SAMPLE VARIABLES
nSets = 2;               % number of sets of samples
nSamples = 2;            % number of samples to take
countdownTime = .75;     % time between countdown numbers
restTime = 2;            % time in seconds between samples

% RECORDING VARIABLES
Fs = 44100;         % sampling frequency
recDuration = 3;    % record duration in seconds
nBits = 16;         % sample bit precision
nChannels = 2;

% HARMONICS VARIABLES
minPeak = 500;      % minimum amplitude of first harmonic peak
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
harmonicsData = zeros(nSamples, nHarmonics);
relativeAmpData = zeros(nSamples, nHarmonics);
dataCollection = cell(nSets, 3);

% reset plots
clf('reset');

if ~plotSetsSeparate
    groupName = input('What is the name of this group of samples?', 's');   % all data is on one plot, needs name
end

% sample iterations
for i = 1:nSets

    fprintf('\n\nSET %d:\n', i);
    setName = input('What is the name of this set of samples?', 's');

    for j = 1:nSamples

        % countdown
        fprintf('\nSAMPLE %d:\n', j);
        pause(countdownTime)
        disp('3')
        pause(countdownTime)
        disp('2')
        pause(countdownTime)
        disp('1')
        pause(countdownTime)

        [x, y] = recordSample(Fs, recDuration, nBits, nChannels);   % records sample, performs fft
        [harmonicsData(j, :), relativeAmpData(j, :)] = findHarmonics(x, y, nHarmonics, minPeak);    % finds the harmonics in the fft data

        pause(restTime)     % rest in between samples

    end

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
        title(groupName)
    else
        title(setName)
    end

    % turn hold off
    if plotSetsSeparate || (i == nSets)
        hold off
    end

end
