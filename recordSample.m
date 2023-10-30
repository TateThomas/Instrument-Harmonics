function [X, Y] = recordSample(sampleFrequency, sampleDuration, nBits, nChannels, countdownTime)
    % records an audio sample and performs a fft on it, outputting the
    % positive real x and y.

    L = sampleDuration * sampleFrequency;   % number of samples
    ID = -1;       % default audio input device 

    recObj = audiorecorder(sampleFrequency, nBits, nChannels, ID);

    % countdown
    pause(countdownTime)
    disp('3')
    pause(countdownTime)
    disp('2')
    pause(countdownTime)
    disp('1')
    pause(countdownTime)

    disp("Start")
    recordblocking(recObj, sampleDuration);
    disp("Stop")

    myRecording = getaudiodata(recObj);
    myFFT = fft(myRecording);
    
    X = (1/sampleDuration) * (0:L/2);
    fftY = abs(fftshift(myFFT));
    Y = fftY(L/2:L);

end