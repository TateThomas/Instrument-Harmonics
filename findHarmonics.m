function [locations, relativeAmplitudes] = findHarmonics(X, Y, n, minPeak)
    % Finds the first n harmonics from in the given dataset. minPeak is the
    % minimum value to consider for the first harmonic. If you are getting
    % zeros for the output or the values you find are unexpected, you may
    % need to increase minPeak. Fast Fourier Transform must be done before
    % using this.

    function [peakIndex] = searchInRange(y, start, finish)
        % Finds the max peak in a given range of Y values

        % round numbers in case of non-integer start/finish values
        start = round(start);
        finish = round(finish);

        % correct start and finish if they are out of range
        if start < 1
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
    firstAmplitude = 0;   % amplitude of first harmonic
    ERROR_RANGE = 50;    % range of numbers to check for the peak around

    locations = zeros(1, n);   % frequencies of where the harmonics are found
    relativeAmplitudes = zeros(1, n);  % amplitude of each harmonic divided by the first

    i = 1;
    harmonicsFound = 0;
    while (harmonicsFound < n) && (i <= length(X))

        if (harmonicsFound == 0) && (Y(i) >= minPeak)

            [index] = searchInRange(Y, i - (ERROR_RANGE / 2), i + (ERROR_RANGE / 2));
            
            firstI = index;
            firstAmplitude = Y(index);
            harmonicsFound = harmonicsFound + 1;
            locations(1, harmonicsFound) = X(index);
            relativeAmplitudes(1, harmonicsFound) = firstAmplitude;
            i = i + firstI;

        elseif harmonicsFound > 0

            [index] = searchInRange(Y, i - (ERROR_RANGE / 2), i + (ERROR_RANGE / 2));

            harmonicsFound = harmonicsFound + 1;
            locations(1, harmonicsFound) = X(index);
            %relativeAmplitudes(1, harmonicsFound) = Y(index) / firstAmplitude;
            relativeAmplitudes(1, harmonicsFound) = Y(index);
            i = i + firstI;

        else

            i = i + 1;

        end

    end

end