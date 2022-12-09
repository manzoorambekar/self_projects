%% QAM Transmitter with ADALM-PLUTO Radio
close all; clear; clc;

%% Date collector initialization for the Transmitter parameters

QAMTx_DataCollector = QAM_Tx_Init;

QAMTx = QAM_Tx_Run(QAMTx_DataCollector);
QAMTx.MessageGeneration();
QAMTx.ScramblePayload();
QAMTx.CreateFrame()
QAMTx.AddPaddingBits();
QAMTx.QAM_Modulation();
QAMTx.TxFilter();
QAMTx.PlutoTx();