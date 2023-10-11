function [locations, relativeAmplitudes] = findHarmonics(X, Y, n, minPeak)
    % Finds the first n harmonics from in the given dataset. minPeak is the
    % minimum value to consider for the first harmonic. If you are getting
    % zeros for the output or the values you find are unexpected, you may
    % need to increase minPeak. Fast Fourier Transform must be done before
    % using this.

    function [peakIndex] = searchInRange(y, start, finish)
        % Finds the max peak in a given range of Y values

        % correct start and finish if they are out of range
        if start < 0
            start = 1;
        end
        if finish > length(y)
            finish = length(y);
        end

        peakIndex = 0;
        maxPeak = 0;

        for j = start:finish
            if y(j) > maxPeak
                peakIndex = j;
                maxPeak = y(peakIndex);
            end
        end

    end

    if (length(X) ~= length(Y))
        error('Error: Length of X and Y must be the same');
    end

    firstI = 0;     % index of first harmonic
    maxAmplitude = 0;   % amplitude of first harmonic
    ERROR_RANGE = 50;    % range of numbers to check for the peak around

    locations = zeros(1, n);   % frequencies of where the harmonics are found
    relativeAmplitudes = zeros(1, n);  % amplitude of each harmonic divided by the first

    i = 1;
    harmonicsFound = 0;
    while (harmonicsFound < n) && (i <= length(X))

        if (harmonicsFound == 0) && (Y(i) >= minPeak)

            [index] = searchInRange(Y, i - (ERROR_RANGE / 2), i + (ERROR_RANGE / 2));
            firstI = index;
            maxAmplitude = Y(index);
            locations(1, harmonicsFound + 1) = X(index);
            relativeAmplitudes(1, harmonicsFound + 1) = 1;
            i = i + firstI;
            harmonicsFound = harmonicsFound + 1;

        elseif harmonicsFound > 0

            [index] = searchInRange(Y, i - (ERROR_RANGE / 2), i + (ERROR_RANGE / 2));

            if Y(index) >= maxAmplitude
                % since the peak found is greater than the maxAmplitude,
                % this peak must be the actual first harmonic
                firstI = index;
                maxAmplitude = Y(index);
                locations(1, 1) = X(index);
                harmonicsFound = 1;
                i = i + firstI;
            else
                locations(1, harmonicsFound + 1) = X(index);
                relativeAmplitudes(1, harmonicsFound + 1) = Y(index) / maxAmplitude;
                i = i + firstI;
                harmonicsFound = harmonicsFound + 1;
            end

        else

            i = i + 1;

        end

    end

end