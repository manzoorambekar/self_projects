close all;
clear var;

time = 15;  % time in seconds

fs = 100;    % sampling frequency
Ts = 1/fs;    % sampling time in seconds
time_vector = (0 :  Ts : time - Ts);
 
N = time./Ts;   % number of samples
%%
noise = rand(1,N).*2; % Generate white noise

%%
% generate main sinus signal for PPG
% 1. sinus
f0 = 1;         % Sin  1 Hz PPG
A = 1;         % Amplitude sin in volt

signal0 = A*sin(2*pi*f0.*time_vector);   % sin signal

% 2. sinewave

f01 = 2;
A1 = 0.5;
signal1 = A1*sin(2*pi*f01.*time_vector);  % sin signal 2


signal = signal0+signal1;    % build simulated PPG signal
signalnoise = signal+noise-8 ;    % signal with noise
%%
y = fft(signalnoise);    % fft og signalnoise
mag=abs(y);     % magnitude complex array

%build frequency vector
freq= (0:N-1)*fs/N;


%build heart rate per minute
 bpm = freq*60;
 

figure(1)
plot(time_vector, signalnoise);
grid on;
axis([0 15 -10 +10]);
xlabel('time in seconds');
ylabel('simulated signal');
title('PPG Test Signal');
legend('Noisy PPG signal ');


figure(2)
plot(bpm, mag);
grid on;
axis([0 5*60 0 max(mag)]);
xlabel('heart rate in bpm');
ylabel('FFT spectrum');
title('PPG Test Signal');
legend('Noisy PPG signal ');


figure(3)
plot(freq, mag);
grid on;
axis([0 5 0 max(mag)]);
xlabel('heart rate in Hz');
ylabel('FFT spectrum');
title('PPG Test Signal');
legend('Noisy PPG signal ');


figure(4)
plot(freq, 20*log10(mag));
grid on;
axis([0.2 5 15 max(20*log10(mag)+1)]);
xlabel('heart rate in Hz');
ylabel('FFT spectrum in dB');
title('PPG Test Signal');
legend('Noisy PPG signal ');

arrangefigures(0);


