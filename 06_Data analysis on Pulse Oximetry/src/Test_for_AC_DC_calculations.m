% example on posibility of AC DC calculation

 
%%
close all;
clear variables;

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

% one sample every 8.52 ms   sampling time 

t=t./1000; %the time vector t is converted into seconds

%Display the ADC raw data from PMD device for a first overview of data

L670nm=M(:,2);  %take the second column from M and name it L670nm
L905nm=M(:,4);  %take the second column from M and name it L905nm

%%
%the PMD1 device has a 16-bit AD converter (resolution 65535 steps)
%raw data of the transmission signals are output with sign bit (-32767 to
%+32767)
%Convert the ADC PPG values into voltage values (measuring range 0-10
%Volts)

L670nm=(-(L670nm-32768)*10)/65537;  %this transformation can be used for this 
L905nm=(-(L905nm-32768)*10)/65537;  %this transformation can be used for this

%%
%Savitzky Golay filter 

L670nmf=sgolayfilt(L670nm,6,41);   %Savitzky Golay filter with a 6th order polynomial, use 41 samples
L905nmf=sgolayfilt(L905nm,6,41);   %Savitzky Golay filter with a 6th order polynomial, use 41 samples


L1AC= L670nm./L670nmf;

f1 = figure(1)
plot(t,L670nm,'--k',t,L905nm,'--red ');
hold on;
plot(t,L670nmf,'green',t,L905nmf,'blue','linewidth', 1.5);
grid Minor;
xlabel('Time [sec]');
ylabel('PPG signal [V]');
title('Filtering of data (Savitzky Golay');
legend( 'PPG 670nm unfiltered','PPG 905nm unfiltered', 'PPG 670nm filtered','PPG 905nm filtered');
saveas(f1, strcat('AC_DC/SG (',FileName,').jpeg'))


%%
% 1. DC vector for L670nm

DC670nm = [];     % help vector or calculations
windowsize = 235;      % windowing size   235 sample  values*0.00852  --> 2seconds
PPG1 = L670nmf;
for i=1:windowsize:length(PPG1)
    % check requested window is smaller than windowsize
    if(length(PPG1)-i)<windowsize
        windowsize=length(PPG1)-i;
    end
    % get data from specified vector
    
    temp=PPG1(i:(i+windowsize));
    % DC=mean(temp)
    DC=median(temp);
    lenRet=windowsize;
    DC670nm=[DC670nm; repmat(DC,lenRet,1)];
    
end

DC670nm=[DC670nm; DC670nm(length(DC670nm),:)];

% 2. DC vector for L905nm

DC905nm = [];     % help vector or calculations
windowsize = 235;      % windowing size   235 sample  values*0.00852  --> 2seconds
PPG2 = L905nmf;
for i=1:windowsize:length(PPG2)
    % check requested window is smaller than windowsize
    if(length(PPG2)-i)<windowsize
        windowsize=length(PPG2)-i;
    end
    % get data from specified vector
    
    temp=PPG2(i:(i+windowsize));
    % DC=mean(temp)
    DC=median(temp);
    lenRet=windowsize;
    DC905nm=[DC905nm; repmat(DC,lenRet,1)];
    
end

DC905nm=[DC905nm; DC905nm(length(DC905nm),:)];

T = ((0:length(DC670nm) - 1).*0.00852);

f2 = figure(2)
plot(t, L670nmf, T, DC670nm, t, L905nmf, T, DC905nm);
xlabel('time [sec]');
ylabel('PPG signals with DC part');
legend('PPG_Signal_DC670nm', 'PPG_Signal_DC905nm');
title('DC part for L670nm and L905nm');
grid on;
saveas(f2, strcat('AC_DC/DC for L670nm & L905nm (',FileName,').jpeg'))

%%
% AC part for L670nm

AC670nm = [];     % help vector or calculations
windowsize = 235;      % windowing size   235 sample  values*0.00852  --> 2seconds
PPG1 = L670nmf;
for i=1:windowsize:length(PPG1)
    % check requested window is smaller than windowsize
    if(length(PPG1)-i)<windowsize
        windowsize=length(PPG1)-i;
    end
    % get data from specified vector
    
    temp=PPG1(i:(i+windowsize));
    
    ACmax = max(temp);
    ACmin = min(temp);
    AC = ACmax - ACmin;
    
    lenRet=windowsize;
    AC670nm=[AC670nm; repmat(AC,lenRet,1)];
    
end

AC670nm=[AC670nm; AC670nm(length(AC670nm),:)];

% AC part for L905nm

AC905nm = [];     % help vector or calculations
windowsize = 235;      % windowing size   235 sample  values*0.00852  --> 2seconds
PPG2 = L905nmf;
for i=1:windowsize:length(PPG2)
    % check requested window is smaller than windowsize
    if(length(PPG2)-i)<windowsize
        windowsize=length(PPG2)-i;
    end
    % get data from specified vector
    
    temp=PPG2(i:(i+windowsize));
    
    ACmax = max(temp);
    ACmin = min(temp);
    AC = ACmax - ACmin;
    
    lenRet=windowsize;
    AC905nm=[AC905nm; repmat(AC,lenRet,1)];
    
end

AC905nm=[AC905nm; AC905nm(length(AC905nm),:)];

T = ((0:length(AC670nm) - 1).*0.00852);

f3 = figure(3)
plot(t, L670nmf, T, AC670nm, t, L905nmf, T, AC905nm);
xlabel('time [sec]');
ylabel('PPG signals with AC part');
legend('PPG_Signal_AC670nm', 'PPG_Signal_AC905nm');
title('AC part for L670nm and L905nm');
grid on;
saveas(f3, strcat('AC_DC/AC for L670nm & L905nm (',FileName,').jpeg'))

Ratio_1 = AC670nm./DC670nm;
Ratio_2 = AC905nm./DC905nm;

SpO2_Ratio = 1.5 - (Ratio_1./Ratio_2);

f4 = figure(4)
plot(t, SpO2_Ratio, 'square');
xlabel('time [sec]');
ylabel('ratio of ratio for SpO2 calibration');
axis([0 250 0.80 1]);
legend('ACDC1/ACDC2');
title('SpO2 calibration');
grid on;
saveas(f4, strcat('AC_DC/SpO2 calibration (',FileName,').jpeg'))


