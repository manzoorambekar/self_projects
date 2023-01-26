

classdef QAM_Tx_Run < handle
    properties (SetAccess=private)
        DC
    end

    methods
        function obj = QAM_Tx_Run(DataCollector)
            obj.DC = DataCollector;
            disp(obj.DC)
        end
        
        function obj = MessageGeneration(obj)
            % Message generation
            disp(obj.DC.Message)
            msgSet = zeros(obj.DC.NumberOfMessage * obj.DC.MessageLength, 1);
            msgstring = [];
            for msgCnt = 0 : obj.DC.NumberOfMessage-1
                msgstring = [msgstring; sprintf('%s %03d\n', obj.DC.Message, msgCnt)];
                    
                msgSet(msgCnt * obj.DC.MessageLength + (1 : obj.DC.MessageLength)) = ...
                    sprintf('%s %03d\n', obj.DC.Message, msgCnt);
            end
            disp(num2str(msgstring))
            
            bits = de2bi(msgSet, 7, 'left-msb')';
            obj.DC.MessageBits = bits(:);
            
            figure
            stem(bits');
            title('Message Bits Array')
            
            figure
            stem(obj.DC.MessageBits);
            title('Message Bits Vector')
        end
        
        function obj = ScramblePayload(obj)
            % Initialize scrambler system object
            Scrambler = comm.Scrambler( ...
                            obj.DC.ScramblerBase, ...
                            obj.DC.ScramblerPolynomial, ...
                            obj.DC.ScramblerInitialConditions);
    
            obj.DC.ScrambledMessageBits = Scrambler(obj.DC.MessageBits);
            figure
            stem(obj.DC.ScrambledMessageBits);
            title('Scrambled message')
        end
        
        function obj = CreateFrame(obj)
            % Create the Frame from the header and scrambled message bits 
            ubc = ((obj.DC.BarkerCode + 1) / 2)';
            temp = (repmat(ubc,1,2))';
            obj.DC.Header = temp(:);
            obj.DC.Frame = [obj.DC.Header ; obj.DC.ScrambledMessageBits];
            
            figure
            stem(obj.DC.BarkerCode);
            title('Barker code')
        end
        
        function obj = AddPaddingBits(obj)
            obj.DC.FrameSize = size(obj.DC.Frame);
            disp('Frame size before padding = ')
            disp(obj.DC.FrameSize)

            % Add the padding bits to the frame
            bitsPerSymbol = log2(obj.DC.ModulationOrder);
            remainder = mod(length(obj.DC.Frame), bitsPerSymbol);
            obj.DC.PaddingBits = 0;

            if remainder > 0
                PaddedBits = bitsPerSymbol - remainder
                obj.DC.PaddingBits = zeros(1, PaddedBits);
                obj.DC.Frame = [obj.DC.Frame' obj.DC.PaddingBits];
            end
            

            obj.DC.FrameSize = size(obj.DC.Frame');
            disp('Frame size after padding = ')
            disp(obj.DC.FrameSize)
        end
        
        function obj = QAM_Modulation(obj)
            % Modulate the data
            obj.DC.ModulatedData = qammod(obj.DC.Frame',...
                obj.DC.ModulationOrder,'gray','InputType','bit','PlotConstellation',true);
            
%             scatterplot(obj.DC.ModulatedData)
%             title('Modulated Data Scatter Plot')
%             
%             eyediagram(obj.DC.ModulatedData, obj.DC.Interpolation)
%             title('Modulated Data eyediagram')
        end
        
        function obj = TxFilter(obj)
            % Raised cosine FIR pulse-shaping filter design
            rrcFilter = rcosdesign(obj.DC.RolloffFactor,...
                obj.DC.RaisedCosineFilterSpan,obj.DC.Interpolation);
            
            obj.DC.txFiltSignal = upfirdn(obj.DC.ModulatedData, ...
                rrcFilter, obj.DC.Interpolation, 1);
            
%             scatterplot(obj.DC.txFiltSignal)
%             title('Tx Filtered Data Scatter Plot')
%             
%             eyediagram(obj.DC.txFiltSignal, obj.DC.Interpolation)
%             title('Modulated Data eyediagram')
        end
        
        function obj = PlutoTx(obj)
            persistent radio
            if isempty(radio)
                % Create and configure the Pluto System object.
                radio = sdrtx('Pluto');
                radio.RadioID               = obj.DC.Address;
                radio.CenterFrequency       = obj.DC.PlutoCenterFrequency;
                radio.BasebandSampleRate    = obj.DC.PlutoFrontEndSampleRate;
                radio.SamplesPerFrame       = obj.DC.PlutoFrameLength;
                radio.Gain                  = obj.DC.PlutoGain;
            end
            
            currentTime = 0;
            disp('Transmission has started')
            % Transmission Process
            while currentTime < obj.DC.StopTime
                % Data transmission
                step(radio, obj.DC.txFiltSignal);
                currentTime = currentTime + obj.DC.FrameTime;
            end
            display(currentTime)
            if currentTime ~= 0
                disp('Transmission has ended')
            end
            release(radio);
        end
    end
end
