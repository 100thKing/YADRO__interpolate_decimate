clear; close all; clc;

Fs       = 1000;
duration = 1;
M        = 3;

f_list = ([0:500]);
% f_list = [0, 1, 5, 10, 20, 50, 100, 150, 200, 250, 300, 333, 400, 450, 490, 500];

N_f   = length(f_list);
rmse  = zeros(1, N_f);
nrmse = zeros(1, N_f);
snr_v = zeros(1, N_f);

for idx = 1 : N_f
    f = f_list(idx);

    [t, x_orig] = sin_generator(f, Fs, duration);
    N_orig = length(x_orig);

    x_dec = decimate(x_orig, M);

    x_interp = interpolate(x_dec, M);

    N_out = min(N_orig, length(x_interp));
    x_in  = x_orig(1 : N_out);
    x_out = x_interp(1 : N_out);

    err = x_in - x_out;

    rmse(idx) = sqrt(mean(err.^2));

    amp = max(x_in) - min(x_in);
    if amp > 1e-10
        nrmse(idx) = rmse(idx) / amp * 100;
    else
        nrmse(idx) = 0;
    end

    pwr_sig = sum(x_in.^2);
    pwr_err = sum(err.^2);
    if pwr_err > 1e-15
        snr_v(idx) = 10 * log10(pwr_sig / pwr_err);
    else
        snr_v(idx) = 0;
    end

    fprintf('f = %4d Гц  |  RMSE = %.4f  |  NRMSE = %6.2f %%  |  SER = %7.2f дБ\n', ...
            f, rmse(idx), nrmse(idx), snr_v(idx));
end

figure('Name', 'Ошибка децимации-интерполяции', 'Position', [100 100 1000 1000]);

subplot(2,2,1);
plot(f_list, rmse, 'b-o', 'LineWidth', 1, 'MarkerFaceColor', 'b');
xline(Fs/(2*M), 'r--', 'LineWidth', 1);
text(Fs/(2*M)+5, max(rmse)*0.9, sprintf('f_{Kot}^{dec} = %d Гц', round(Fs/(2*M))), ...
     'Color','r','FontSize',9);
xlabel('Частота f, Гц'); ylabel('RMSE');
title('RMSE vs Частота');
grid on; xlim([0 505]);

subplot(2,2,2);
snr_plot = min(snr_v, 80);
plot(f_list, snr_plot, 'g-s', 'LineWidth', 1, 'MarkerFaceColor', 'g');
xline(Fs/(2*M), 'r--', 'LineWidth', 1);
xlabel('Частота f, Гц'); ylabel('SER, дБ');
title('SER vs Частота');
grid on; xlim([0 505]);

f_demo = 100;
[t100, x100] = sin_generator(f_demo, Fs, duration);
x100_dec    = decimate(x100, M);
x100_interp = interpolate(x100_dec, M);
N_show = min(length(x100), length(x100_interp));

subplot(2,2,3);
t_show = t100(1:min(N_show,100));
plot(t_show*1000, x100(1:length(t_show)), 'b-', 'LineWidth',1); hold on;
plot(t_show*1000, x100_interp(1:length(t_show)), 'r--', 'LineWidth',1);
xlabel('Время, мс'); ylabel('Амплитуда');
title(sprintf('Сигналы при f = %d Гц (первые 100 отсчётов)', f_demo));
legend('Исходный','После дец.+интерп.'); grid on;

f_demo2 = 400;
[t400, x400] = sin_generator(f_demo2, Fs, duration);
x400_dec    = decimate(x400, M);
x400_interp = interpolate(x400_dec, M);
N_show2 = min(length(x400), length(x400_interp));

subplot(2,2,4);
t_show2 = t400(1:min(N_show2,100));
plot(t_show2*1000, x400(1:length(t_show2)), 'b-', 'LineWidth',1); hold on;
plot(t_show2*1000, x400_interp(1:length(t_show2)), 'r--', 'LineWidth',1);
xlabel('Время, мс'); ylabel('Амплитуда');
title(sprintf('Сигналы при f = %d Гц (первые 100 отсчётов)', f_demo2));
legend('Исходный','После дец.+интерп.'); grid on;

sgtitle('Децимация (÷3) → Интерполяция (×3): анализ ошибки', 'FontSize', 13);
