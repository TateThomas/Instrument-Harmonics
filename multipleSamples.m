
% RECORDING VARIABLES
Fs = 44100;         % sampling frequency
recDuration = 3;    % record duration in seconds
nBits = 16;
nChannels = 2;

% HARMONICS VARIABLES
minPeak = 150;      % minimum amplitude of first harmonic peak
nHarmonics = 10;    % number of harmonics to find
nSamples = 2;       % number of samples to take
restTime = .5;      % time in seconds between samples

% initialize matrices
harmonicsData = zeros(nSamples, nHarmonics);
relativeAmpData = zeros(nSamples, nHarmonics);

for i = 1:nSamples
    fprintf('\nSAMPLE %d:\n', i);
    [x, y] = recordSample(Fs, recDuration, nBits, nChannels);   % records sample, performs fft
    [harmonicsData(i, :), relativeAmpData(i, :)] = findHarmonics(x, y, nHarmonics, minPeak);    % finds the harmonics in the fft data
    pause(restTime)
end

% plot each sample on top of each other, with x being frequency and y being
% relative amplitude
plot(harmonicsData(1, :), relativeAmpData(1, :))
hold on
for sample = 2:nSamples
    plot(harmonicsData(sample, :), relativeAmpData(sample, :))
end
hold off
