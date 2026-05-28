function [t, x] = sin_generator(f, fs, duration)

    if nargin < 2
        fs = 1000;
    end
    if nargin < 3
        duration = 1;
    end

    if f > fs / 2
        warning('Частота f=%g Гц превышает частоту по теореме Котельникова (%g Гц)! ', ...
        'Возникнет aliasing.', f, fs/2);
    end

    Ts = 1 / fs;
    t  = (0 : Ts : duration - Ts)';

    x = sin(2 * pi * f * t);
end
