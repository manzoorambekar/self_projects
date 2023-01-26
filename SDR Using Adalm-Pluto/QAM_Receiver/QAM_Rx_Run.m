

classdef QAM_Rx_Run < handle
    properties (SetAccess=private)
        DC
    end

    methods
        function obj = QAM_Rx_Run(DataCollector)
            obj.DC = DataCollector;
            disp(obj.DC)
        end
        
        function obj = PlutoRx(obj)
            Freqoffset = 2.492;
            % Create and configure the Pluto System object.
            obj.DC.rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', obj.DC.PlutoCenterFrequency, ...
                       'BasebandSampleRate', obj.DC.PlutoFrontEndSampleRate, 'SamplesPerFrame', 1024*1024, ...
                       'FrequencyCorrection',Freqoffset,...
                       'OutputDataType', 'double', 'ShowAdvancedProperties', true);

            currentTime = 0;
            while currentTime < obj.DC.StopTime
                disp(['Capture signal and observe the frequency offset' newline])

                % Receive and visualize the signal
                obj.DC.ReceivedSignal = obj.DC.rx();
                
                % Post processing for every recieved frame
                obj.RxFilter();
                obj.QAM_Demodulation();
                obj.GetPayload();
                obj.Descramble();
                
                currentTime=currentTime+(obj.DC.rx.SamplesPerFrame / obj.DC.rx.BasebandSampleRate);
            end
        end
        
        function obj = RxFilter(obj)
            
            figure
            scatterplot(obj.DC.ReceivedSignal)
            title('Recieved: Raw received data')
            
            % Raised cosine FIR pulse-shaping filter design
            obj.DC.rrcFilter = rcosdesign(obj.DC.RolloffFactor,...
                obj.DC.RaisedCosineFilterSpan,obj.DC.Interpolation);

            obj.DC.rxFiltSignal = upfirdn(obj.DC.ReceivedSignal, ...
                obj.DC.rrcFilter, 1, obj.DC.Interpolation);
            
            figure
            scatterplot(obj.DC.rxFiltSignal)
            title('Rx: Filtered Data Scatter Plot')
            
            figure
            eyediagram(obj.DC.rxFiltSignal, obj.DC.Interpolation)
            title('Rx: Filtered Data eyediagram')
        end
        
        function obj = QAM_Demodulation(obj)
            % Demodulate the filtered data
            obj.DC.DemodulatedData = qamdemod(obj.DC.rxFiltSignal, obj.DC.ModulationOrder,...
                'OutputType','bit','PlotConstellation',true);  
            
            figure
            stem(obj.DC.DemodulatedData)
            title('Demodulated data stem diagram')
        end
        
        function GetPayload(obj)
            % Recreate the header
            ubc = ((obj.DC.BarkerCode + 1) / 2)';
            temp = (repmat(ubc,1,2))';
            obj.DC.Header = temp(:);
            
            % Cross corelation between the received frame and the header
            obj.DC.PosFrame = xcorr(obj.DC.DemodulatedData, obj.DC.Header);
            [val maxPeak] = max(obj.DC.PosFrame);
            
            figure
            plot(obj.DC.PosFrame)
            title('Recieved: cross correlation of Demodulated data and Header')
            
            Header_End = maxPeak  - (length(obj.DC.DemodulatedData) - obj.DC.HeaderLength)
            Frame_End = Header_End + obj.DC.PayloadLength
            
            % Retrive the payload from the frame
            obj.DC.rxPayload= obj.DC.DemodulatedData(Header_End+1:Frame_End);
        end
        
        function Descramble(obj)
            pDescrambler = comm.Descrambler('CalculationBase',obj.DC.ScramblerBase,...
                'Polynomial',obj.DC.ScramblerPolynomial,...
                'InitialConditions',obj.DC.ScramblerInitialConditions);
            obj.DC.DescrambledBits = pDescrambler(obj.DC.rxPayload);

            figure
            stem(obj.DC.DescrambledBits);
            title('Message Bits Vector')
            
            % Recovering the message from the data
            charSet = int8(bi2de(reshape(obj.DC.DescrambledBits, 7, [])', 'left-msb'));
            
            fprintf('%s', char(charSet));

        end
        
    end
end
