fs = 100; % sampling rate
T = 1/fs;
f0 = 1500; % carrier frequency
L = 30; % the main signal energy is centered about sample number L

%
num_samples = 1024;
sample_idx = 0:(num_samples-1);
TimeInstants_for_Tx = sample_idx*T;
delay_idx = 180;
TimeInstants_for_Rx = (sample_idx-delay_idx)*T;

% Original signal
x = 5.*cos(2*pi*f0*TimeInstants_for_Tx).*exp(-42.*((TimeInstants_for_Tx-L*T).^2));
% Received signal without noise
y = 5.*cos(2*pi*f0*TimeInstants_for_Rx).*exp(-42.*((TimeInstants_for_Rx-L*T).^2));
% Noise and Received noisy signal
noise = rand(1,num_samples);
y = y + noise;

% Auto-Correlation
[corr_xx, lag_xx] = xcorr(x, x); % Auto-correlation of x
% Cross-Correlation . NOTE: xcorr(x,y) is DIFFERENT from xcorr(y,x)
[corr_yx, lag_yx] = xcorr(y, x); % Cross-correlation of y and x

% find the maximum of the auto-correlation function
[peak_xx, idx_peak_xx] = max(corr_xx);

% find the maximum of the cross-correlation function
[peak_yx, idx_peak_yx] = max(corr_yx);

% estimate the delay
delay_est = idx_peak_yx - idx_peak_xx


% plot signals
figure
plot(sample_idx,x)
hold on
plot(sample_idx, y)
xlabel('Sample index','FontSize',12)
ylabel('Signal','FontSize',12)
legend('Original signal','Received noisy signal','FontSize',10)

% plot correlation functions
figure
plot(lag_yx, corr_yx,'r','LineWidth', 1.4);
hold on
plot(lag_yx, corr_xx,'--b','LineWidth', 1.4);
xlabel('Lag','FontSize',12)
ylabel('Correlation','FontSize',12)
legend('Cross-correlation xcorr(y,x)','Auto-correlation xcorr(x)', ...
    'FontSize',10,'Location','best')
