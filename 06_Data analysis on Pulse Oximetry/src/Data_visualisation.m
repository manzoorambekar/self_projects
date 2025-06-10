%% Display of PPG data form the PMD 1 device
%%
close all; clear variables;

[FileName,PathName]=uigetfile('*.txt','Wismar Research Seminar with our indian Students');

M=load(FileName);

%Matrix M:
%Colum1 - time vector
%Blood spectra
%C 2 - PPG 670nm (photoplethysmogram for 670nm wavelength - oxigeneted O2HB
%C 3 - PPG 808nm (isosbestic point)
%C 4 - PPG 905nm (deoxygenated hemoglobin - HHB)
%C 5 - PPG 980nm (deoxygenated  hemoglobin + water)
%C 6 - PPG 1310nm (mainly water absoption)

%%
t=M(:,1);   %get the first column from the matrix M - Time in miliseconds

% one sample every 8.52 ms

t=t./1000; %the time vector t is converted into seconds

%Display the ADC raw data from PMD device for a first overview of data

L670nm=M(:,2);  %take the second column from M and name it L670nm
L808nm=M(:,3);  %take the second column from M and name it L808nm
L905nm=M(:,4);  %take the second column from M and name it L905nm
L980nm=M(:,5);  %take the second column from M and name it L980nm
L1310nm=M(:,6); %take the second column from M and name it L1310nm

%%
%the PMD1 device has a 16-bit AD converter (resolution 65535 steps)
%raw data of the transmission signals are output with sign bit (-32767 to
%+32767)
%Convert the ADC PPG values into voltage values (measuring range 0-10
%Volts)

L670nm=(-(L670nm-32768)*10)/65537;  %this transformation can be used for this 
L808nm=(-(L808nm-32768)*10)/65537;  %this transformation can be used for this
L905nm=(-(L905nm-32768)*10)/65537;  %this transformation can be used for this
L980nm=(-(L980nm-32768)*10)/65537;  %this transformation can be used for this
L1310nm=(-(L1310nm-32768)*10)/65537; %this transformation can be used for this


%%
%Representation of the result in a plot

f1 = figure(1)
plot(t,L670nm,'blue',t,L808nm,'green',t,L905nm,'black',t,L980nm,'cyan',t,L1310nm,'magenta','lineWidth',1.5);
grid Minor;
xlabel('Time [sec]','fontsize',24);
ylabel('Transmission signals [V]','fontsize',24);
title('Visualization of data','fontsize',24);
legend('PPG 670nm','PPG 808nm','PPG 905nm','PPG 980nm','PPG 1310nm');
saveas(f1, strcat('Data_Visualisation/Raw (',FileName,').jpeg'))

%%

%Savitzky Golay filter 

PPGunfiltered=L808nm;

PPGfiltered=sgolayfilt(PPGunfiltered,6,41);   %Savitzky Golay filter with a 6th order polynomial, use 41 samples

f2 = figure(2)
plot(t,PPGunfiltered,'red',t,PPGfiltered,'green','lineWidth',1.5);
grid Minor;
xlabel('Time [sec]','fontsize',24);
ylabel('PPG signal [V]','fontsize',24);
title('Savitzky Golay Filtering','fontsize',24);
legend('PPG unfiltered','PPG filtered');
saveas(f2, strcat('Data_Visualisation/SG (',FileName,').jpeg'))


PPGunfiltered=L808nm;

PPGfiltered=sgolayfilt(PPGunfiltered,6,41);   %Savitzky Golay filter with a 6th order polynomial, use 41 samples

f2 = figure(5)
plot(t,PPGunfiltered,'red',t,PPGfiltered,'green','lineWidth',1.5);
grid Minor;
axis([0 2 5.2 5.8]);                    % axis range: x = 0 to 20, y = 0 to 1
xlabel('Time [sec]','fontsize',24);
ylabel('PPG signal [V]','fontsize',24);
title('Savitzky Golay Filtering(close-up pulse view)','fontsize',24);
legend('PPG unfiltered','PPG filtered');
saveas(f2, strcat('Data_Visualisation/SG_P (',FileName,').jpeg'))



%%

%Classical spectral analysis with DFFT for UNFILTERED

FFTPPG = PPGunfiltered;

% Normalization by mean value complete set:

FFTPPGmean = mean(FFTPPG);

FFTPPGN = (FFTPPG./FFTPPGmean)-1;

N = length(FFTPPGN);                % Determining the number of sample values
fs = 117.370892;                    % Sampling freq of PMD1 device (1/8.52msec) in Hz (1/sec)
z = fft(FFTPPGN);                   % Determining FFT

FFTPPG = abs(z);                    % Absolute value of the result

freq = (1:N)*fs/N;                  % Calculation of the corresponding frequency axis

Maximum =  max(FFTPPG);

FFTPPGnormu = (FFTPPG./Maximum);     % Normalization to 1




%Classical spectral analysis with DFFT for FILTERED

FFTPPG = PPGfiltered;

% Normalization by mean value complete set:

FFTPPGmean = mean(FFTPPG);

FFTPPGN = (FFTPPG./FFTPPGmean)-1;

N = length(FFTPPGN);                % Determining the number of sample values
fs = 117.370892;                    % Sampling freq of PMD1 device (1/8.52msec) in Hz (1/sec)
z = fft(FFTPPGN);                   % Determining FFT

FFTPPG = abs(z);                    % Absolute value of the result

freq = (1:N)*fs/N;                  % Calculation of the corresponding frequency axis

Maximum =  max(FFTPPG);

FFTPPGnormf = (FFTPPG./Maximum);     % Normalization to 1






%plot the result

f3 = figure(3)
plot(freq, FFTPPGnormu,'red', freq*60, FFTPPGnormf,'green','lineWidth',1.5);
axis([0 5*60 0 1]);                    % axis range: x = 0 to 20, y = 0 to 1
grid Minor;
xlabel('Frequency [Hz]','fontsize',24);
ylabel('Spectrum of PPG signal','fontsize',24);
title('Classical spectral analysis with DFFT','fontsize',24);
saveas(f3, strcat('Data_Visualisation/DFFT (',FileName,').jpeg'))


%plot the result heart rate

f4 = figure(4)
plot(freq*60, FFTPPGnormu,'red', freq*60, FFTPPGnormf,'green','lineWidth',1.5);
axis([0 5*60 0 1]);                    % axis range: x = 0 to 5*60, y = 0 to 1
grid Minor;
xlabel('Heart Rate [bpm]','fontsize',24);
ylabel('Spectrum of PPG signal','fontsize',24);
title('Heart Rate in bpm','fontsize',24);
saveas(f4, strcat('Data_Visualisation/Heart_Rate_DFFT (',FileName,').jpeg'))


%%

%Wigner Ville Distributions
% 
% PPGfiltered=wvd(L808nm, 'smoothedPseudo');
% 
% f5 = figure(5)
% plot(t,PPGunfiltered,'red',t,PPGfiltered,'green','lineWidth',1.5);
% grid Minor;
% xlabel('Time [sec]','fontsize',24);
% ylabel('PPG signal [V]','fontsize',24);
% title('Filtering of data (Savitzky Golay)','fontsize',24);
% legend('PPG unfiltered','PPG filtered');
% saveas(f5, strcat('Data_Visualisation/Wigner_Ville_Distributions (',FileName,').jpeg'))




%%
%try other filter types
%form derivative 1 and derivative 2 of signals 
%calculate the Heart beat in bpm
%go into the frequency domain an peform an FFT
%Analyze the data also in the time -frequency range STFFT,
%Wavlet-Transformation or Wiegner-Ville-Distribution
%Calculate the AC/DC ratios and R=Ratio of Ratio for calculation of the
%oxygen saturation (usefull is L670nm and L905nm etc. etc.) 

