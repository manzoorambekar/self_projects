% Example to generate sine wave with a linear change in freq.
% time-frequency charactersitics using STFT

clear var; close all;

% constants 

N = 512;                        % number of points
fs = 500;                       % sampling frequency
f1 = 10;                        % minimum frequency
f2 = 200;                       % maximum frequency
nfft = 32;                      % window size

colormap('hot');
t = (1:N)/fs;

% generate test signal(chirp signal ----> linear change in freq)

fc = ((1:N)*((f2 - f1)/N))+f1;
x = sin(pi*t.*fc);
str = 'Test signal'
f1 = figure(1);
plot(t, x, 'red');
axis([0 0.4 -1.25 +1.25]);
xlabel('time [sec]');
ylabel('test signal x(t)');
saveas(f1, strcat('Spectrogam_Tests/1 (',str,').jpeg'))

% Standard FFT
z = fft(x);
z = abs(z);
freq = (1:N)*fs/N;

f2 = figure(2);
stem(freq, z, 'blue');
axis([0 250 0 30]);
xlabel('frequency [Hz]');
ylabel('power spectra of test signal');
saveas(f2, strcat('Spectrogam_Tests/2 (',str,').jpeg'))

% compute spectrogram

[B,f,t]=spectrogram(x,nfft,[],nfft,fs);

f3 = figure(3);
surf(t,f,abs(B));
shading interp;
ylabel('frequency [Hz]');
xlabel('time [Sec]');
axis([0 1 0 250 0 12]);
saveas(f3, strcat('Spectrogam_Tests/3 (',str,').jpeg'))

f4 = figure(4) 
contour(t,f,abs(B));
axis([0 1 0 250]);
saveas(f4, strcat('Spectrogam_Tests/4 (',str,').jpeg'))
