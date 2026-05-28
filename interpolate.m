function y = interpolate(x, L)

    if nargin < 2
        L = 3;
    end

    x = x(:);
    N = length(x);

    t_in  = (0 : N-1)';
    t_out = (0 : 1/L : N-1)';

    y = interp1(t_in, x, t_out, 'linear');

    target_len = L * N;
    if length(y) < target_len
        y(end+1 : target_len) = x(end);
    end
    y = y(1 : target_len);
end
