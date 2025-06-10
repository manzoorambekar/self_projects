%% QAM Transmitter with ADALM-PLUTO Radio
close all; clear; clc;
IS_HARDWARE_CONNECTED = 0;

% Deactivate the plots
set(gcf,'Visible','off')              % turns current figure "off"
set(0,'DefaultFigureVisible','off');  % all subsequent figures "off"

%% Date collector initialization for the Transmitter parameters
QAM_DataCollector = QAM_Init;

%% QAM Transmitter
QAMTx = QAM_Tx_Run(QAM_DataCollector);
QAMTx.MessageGeneration();
QAMTx.ScramblePayload();
QAMTx.CreateFrame()
QAMTx.AddPaddingBits();
QAMTx.QAM_Modulation();
QAMTx.TxFilter();
if IS_HARDWARE_CONNECTED
    QAMTx.PlutoTx();
else
    % Local transreciever to check the data processing
    QAM_DataCollector.ReceivedSignal = QAMTx.DC.txFiltSignal;
end

set(gcf,'Visible','on')              % turns current figure "off"
set(0,'DefaultFigureVisible','on');  % all subsequent figures "off"

%% QAM Reciever
disp('******************************************* Reciever *******************************************')
% Updating the Data collector with the variables modified in the QAM_Tx_Run 

% To load the local data file uncomment this
% load SimpleRx_data.mat
% QAM_DataCollector.ReceivedSignal = data;

QAMRx = QAM_Rx_Run(QAM_DataCollector);

if IS_HARDWARE_CONNECTED
    QAMRx.PlutoRx();
else
    QAMRx.RxFilter();
    QAMRx.QAM_Demodulation();
    QAMRx.GetPayload();
    QAMRx.Descramble();
end