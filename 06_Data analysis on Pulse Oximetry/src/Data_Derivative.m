%% Display and filtering (savitzky Golay) of PPG data form the PMD 1 device
% Calculation of the 1st derivative of the data
%%
close all; clear variables;

%Loading data
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

%%
%the PMD1 device has a 16-bit AD converter (resolution 65535 steps)
%raw data of the transmission signals are output with sign bit (-32767 to
%+32767)
%Convert the ADC PPG values into voltage values (measuring range 0-10
%Volts)

L670nm=(-(L670nm-32768)*10)/65537;  %this transformation can be used for this 

%%

%Savitzky Golay filter 
L670f=sgolayfilt(L670nm,6,41);      % Savitzky Golay filter with a 6th order polynomial, use 41 samples


%% Derivative 1 method: 2-point-central from matlab diff function

derv1 = diff(L670f);                % first dervivative

t1 = (1:length(derv1))*0.00852;     % Sampling period of PDM1

%%
% 2-point-central results were not much accurate --> diff function from matlab

%% try FIR

Ts = 1/117.370892;                  % sample period
fs=1/Ts;                            % sample freq
order=28;                           % FIR filter order
L=4;                                % Skip factor
fc=.05;                             % Cut-off freq of derivative

% time vector from vector length

T = (1:length(L670f))*Ts;

f=[0 fc fc+0.1 .9];                 % freq vector
A=[0 (fc*fs*pi) 0 0];               % gain vector
b=firpm(order,f,A,'differentiator'); % build filter coefficients

derv1_1=filter(b,1,L670f);          % first dervivative with 2nd method

derv1_1=derv1_1((60:length(derv1_1)));
T=T([60:length(T)]);

f1 = figure(1)
figure(1)
subplot(3,1,1)
plot(t,L670nm,t,L670f,'red');
axis([60 62 5 +6]);
grid on;
title('Time data of PPG Signal for 670nm');
xlabel('Time (sec)');
ylabel('Voltage (V)');

subplot(3,1,2)
plot(t1,derv1,'blue');
axis([60 62 -0.015 +0.015]);
grid on;
title('Diff derivative with Savitsky-Golay Filter of time data');
xlabel('Time (sec)');
ylabel('Derivative');

subplot(3,1,3)
plot(T,derv1_1,'red');
axis([60 62 -1.5 +1.5]);
grid on;
title('FIR filter derivative of time data');
xlabel('Time (sec)');
ylabel('Derivative');
%saveas(f1, strcat('Data_Derivative/Derivative (',FileName,').jpeg'))




[timeMin,locs_Swave] = findpeaks(derv1_1,'MinPeakHeight',0.5);

hrtime = [];
hr = [];     % help vector or calculations
for i=1:1:length(timeMin)
    hr(i) = 60./timeMin(i);
    if(i > 1)
        hrtime(i) = hrtime(i-1)+timeMin(i);
    else
        hrtime(i) = timeMin(i);
    end
end
hrf=sgolayfilt(hr,6,41);      % Savitzky Golay filter with a 6th order polynomial, use 41 samples
% timeDiff = [];     % help vector or calculations
% windowsize = 2;      % windowing size   235 sample  values*0.00852  --> 2seconds
% for i=1:windowsize:length(timeMin)
%     % get data from specified vector
%     
%     % check requested window is smaller than windowsize
%     if(length(timeMin)-i)<= windowsize
%         break
%     end
%     temp=timeMin(i:(i+windowsize));
%     
%     first = temp(1);
%     second = temp(2);
%     timeDiff(i) = first - second;
%     
%     %lenRet=windowsize;
%     %timeDiff=[timeDiff; repmat(AC,lenRet,1)];
%     
% end

f2 = figure(2)
plot(hrtime,hr,'magenta',hrtime,hrf,'green');
axis([0 62 85 130]);
grid on;
title('Heart rate in time domain');
xlabel('Time (sec)');
ylabel('Heart rate in BPM');
saveas(f2, strcat('Data_Derivative/HR (',FileName,').jpeg'))

% 
% localmaxind = 1; 
% localmaxs = [];
% counter = 1;
% a = derv1_1;
% for i =2:length(a)       
%     if a(i)>a(localmaxind)
%         localmaxind = i;        
%          localmaxs(counter) = i;
%     end
%     if a(i)<=0 && a(i-1)>0
%         counter= counter+1;
%          localmaxind = i;
%     end
% end
% figure(2)
% plot(a)
% hold on
% plot(localmaxs,a(localmaxs),'ro')
% title('Heart rate in time domain');
% xlabel('Time (sec)');
% ylabel('Heart rate in BPM');

