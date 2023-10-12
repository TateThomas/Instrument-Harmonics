function [X, Y] = recordSample(sampleFrequency, sampleDuration, nBits, nChannels)
    % records an audio sample and performs a fft on it, outputting the
    % positive real x and y.

    L = sampleDuration * sampleFrequency;   % number of samples
    ID = -1;       % default audio input device 

    recObj = audiorecorder(sampleFrequency, nBits, nChannels, ID);

    disp("Start")
    recordblocking(recObj, sampleDuration);
    disp("Stop")

    myRecording = getaudiodata(recObj);
    myFFT = fft(myRecording);
    
    X = (1/sampleDuration) * (0:L/2);
    fftY = abs(fftshift(myFFT));
    Y = fftY(L/2:L);

end