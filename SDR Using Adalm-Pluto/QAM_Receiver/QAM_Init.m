function DC = QAM_Init

%% General simulation parameters
DC.Rsym = 150e3;             % Symbol rate in Hertz
DC.ModulationOrder = 64;      % QAM alphabet size
DC.Interpolation = 2;        % Interpolation factor
DC.Decimation = 1;           % Decimation factor
DC.Tsym = 1/DC.Rsym;  % Symbol time in sec
DC.Fs   = DC.Rsym * DC.Interpolation; % Sample rate

%% Frame Specifications
DC.BarkerCode      = [+1 +1 +1 +1 +1 -1 -1 +1 +1 -1 +1 -1 +1];     				% Bipolar Barker Code
DC.BarkerLength    = length(DC.BarkerCode);
DC.HeaderLength    = DC.BarkerLength * 2;                   					% Duplicate 2 Barker codes to be as a header
DC.Message         = 'ATC Group3-I: Sushma Sneha Alireza Saptarshi Manzoor';
DC.MessageLength   = length(DC.Message) + 5;                					% '000\n'...
DC.NumberOfMessage = 50;                                          				% Number of messages in a frame
DC.PayloadLength   = DC.NumberOfMessage * DC.MessageLength * 7; 				% 7 bits per characters
DC.FrameSize       = (DC.HeaderLength + DC.PayloadLength) ...
    / log2(DC.ModulationOrder);                                   	 			% Frame size in symbols
DC.FrameTime       = DC.Tsym*DC.FrameSize;

%% Tx parameters
DC.RolloffFactor     = 0.5;                                        				% Rolloff Factor of Raised Cosine Filter
DC.ScramblerBase     = 2;
DC.ScramblerPolynomial           = [1 1 1 0 1];
DC.ScramblerInitialConditions    = [0 0 0 0];
DC.RaisedCosineFilterSpan = 10; 												% Filter span of Raised Cosine Tx Rx filters (in symbols)

%% Pluto transmitter parameters
DC.PlutoCenterFrequency      = 1200e6;
DC.PlutoGain                 = -4;
DC.PlutoFrontEndSampleRate   = DC.Fs;
DC.PlutoFrameLength          = DC.Interpolation * DC.FrameSize;
DC.Freqoffset                = -0.2152;

%% Specify Radio ID
DC.Address = 'usb:0';

%% Simulation Parameters
DC.FrameTime = DC.PlutoFrameLength/DC.PlutoFrontEndSampleRate;
DC.StopTime  = 500;
end
