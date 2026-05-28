function y = decimate(x, M)

    if nargin < 2
        M = 3;
    end

    x = x(:);

    order  = 6 * M;
    if mod(order, 2) ~= 0
        order = order + 1;
    end
    Wc = 1 / M;
    h = fir1(order, Wc, 'low', hamming(order + 1));

    x_filt = filtfilt(h, 1, x);

    y = x_filt(1 : M : end);
end
