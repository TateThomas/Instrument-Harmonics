function [peaksMatrix, locsMatrix] = findAllHarmonics(x, y)

    Y = y;
    sigTest = 1:1:10;
    harmonicsFound = 0;
    syms t
    factorN = 1;
    peaksMatrix = [];
    locsMatrix = [];

    while true

        try
            [firstPks, firstLocs] = findpeaks(Y, "MinPeakHeight", 150, "NPeaks", 2, "MinPeakDistance", 50);
            %round(firstPks(1) / 100)
            if firstLocs(1) > ((factorN*100) + 100)
                factorN = factorN + 2;
            end
            envelopeFunction = -(sin( (3*pi/2) + x.*(2*pi/x(firstLocs(1))) )).^factorN;
            harmonicExtract = (( envelopeFunction > 0 ).*envelopeFunction).*Y;
        catch
            %disp("1")
            break
        end
        %x(firstLocs)

        plot(x, y);
        hold on
        fplot((-(sin( (3*pi/2) + t*(2*pi/x(firstLocs(1))) )^factorN) )*1000);
        plot(x, harmonicExtract);
        %xlim([0 1000]);
        %input("continue", "s");
    
        [pks, locs] = findpeaks(harmonicExtract, "MinPeakDistance", firstLocs(1) - 25);

        %length(locs)

        try
            if x(locs(1)) < 50
                %newPks = pks(2:16);
                newPks = y(locs(2:16));
                newLocs = x(locs(2:16));
            else
                %newPks = pks(1:15);
                newPks = y(locs(1:15));
                newLocs = x(locs(1:15));
            end
        catch
            %disp("2")
            break
        end

        plot(newLocs, newPks);
        %hold off
        xlim([0 3000]);
        pause(.01)
        %input("continue", "s");

        %numel(intersect(newLocs(1, :), newLocs(2, :)));
        %newLocs(1)
        %mod(newLocs(1:8), newLocs(1))./newLocs(1)

        testSig = mod(newLocs(1:8), newLocs(1))./newLocs(1);
        %testSig > .9
        %testSig < .1
        if ((sum(testSig > .1) == 0) || ((sum(testSig > .9) + sum(testSig < .1)) == 8)) && (sum(newPks < 1) == 0)
            %mod(newLocs(1:8), newLocs(1))./newLocs(1)

            isRepeat = false;
            for i = 1:size(locsMatrix)
                repeats = intersect(locsMatrix(i, :), newLocs);
                if numel(repeats) >= 2
                    if (2 * find(locsMatrix(i, :) == repeats(1))) == (find(locsMatrix(i, :) == repeats(2)))
                        isRepeat = true;
                        break
                    end
                end
            end

            if ~isRepeat

                harmonicsFound = harmonicsFound + 1;
                peaksMatrix(harmonicsFound, 1:15) = newPks;
                locsMatrix(harmonicsFound, 1:15) = newLocs;
    
                plot(newLocs, newPks);
                %xlim([0 2000]);
                pause(1)

            end

        end

        hold off

        if length(firstLocs) == 2
            Y = Y.*(x > x(firstLocs(2)-10));
        else
            %disp("3")
            break
        end
        %plot(x, Y);
        %xlim([0 1000]);
        %input("continue", "s");

    end

end