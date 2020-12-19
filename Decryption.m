%%%%%%%%%%%%%%%%%%%%%% Work done by Mohammed Jamal%%%%%%%%%

%{
    Note:
    to run correctly your program, just write in your Matlab's Command Window: Decryption(your sampled file's path).
%}

function DataOffsetFollowingSyncwordCrcCheckOutput= Decryption(filename) 

% INPUT: 
%   filename: Sampled data by rtl-sdr dongle.
% OUTPUT: 
%   DataOffsetFollowingSyncwordCrcCheckOutput: matrix of crc check for all sampled packets .

LoadedFileData=loadFile(filename);
t20 = [-10:9]/20;                                                                                                      % time scatter over 20 symbols, 2048Khz(symbol frequency)/100Khz(symbol rate) approximately 20 symbol.
mf100000 = exp(1i*2*pi*t20*1);                                                                                         % matched filter for 100Khz, for you boss you could use i=sqrt(-1) for your wish :)
mfnegative100000 = exp(1i*2*pi*t20*-1);                                                                                % matched filter for -100Khz
d12 = conv(LoadedFileData,mf100000,'same');                                                                            % Convolution for first Matched filter
d22 = conv(LoadedFileData,mfnegative100000,'same');                                                                    % Convolution for second Matched filter
ddif = (abs(d12)-abs(d22)); 
y=ddif;
lpFilt = designfilt('lowpassiir','FilterOrder',1, ...
    'PassbandFrequency',50e3,'PassbandRipple',0.09, ...
    'SampleRate',2048e3);                                                                                              % LPF designed filter , Cutoff frequency value is half of the symbol rate value.
y=filter(lpFilt,y);

    %@ Zero Crossing Stage %

x=1:length(y);
zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);
% Returns Approximate Zero-Crossing Indices Of Argument Vector
dy = zci(y);
% Indices of Approximate Zero-Crossings
for k1 = 1:size(dy,1)-1
    b = [[1;1] [x(dy(k1)); x(dy(k1)+1)]]\[y(dy(k1)); y(dy(k1)+1)];
    % Linear Fit Near Zero-Crossings
    x0(k1) = -b(1)/b(2);
    % Interpolate ‘Exact’ Zero Crossing
    mb(:,k1) = b;
    % Store Parameter Estimates (Optional)
end
freq = 1./(2*diff(x0));
for i=1:length(x0)-1
    bitPerioddifference(i)=((x0(i)+x0(i+1))/2);                                                                       % Sampling the middle of every two adjacent zero crossing points , implicitly having bit period difference sections of each adjacent zero crossing points
end
bitPerioddifferenceMiddle=ceil(bitPerioddifference);                                                                  % Upper bound approximation
for i=1:length(bitPerioddifferenceMiddle)
    AmplitudeMiddleEachDifference(i)=y(bitPerioddifferenceMiddle(i));                                                 % Storing the amplitude/voltage of every sampled middle in order to decide positive or negative over each bit period difference section
end


   %  Here taking into consideration the x axis as time consideration in compatible fs %
   %  Zero Crossing Stage in aspect of time %
   
fs=2048e3;                                                                                                            % Sampling Frequency
n=length(y);                                                                                                          % Length of my signal
t = (0:(n-1))*(1/fs);                                                                                                 % Time appointed for every sample, first sample at time t=0 , next tn=t0+n*(1/fs)
x=t;
zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);
                                                                                                                      % Returns Approximate Zero-Crossing Indices Of Argument Vector
dy = zci(y);
% Indices of Approximate Zero-Crossings
for k1 = 1:size(dy,1)-1
    b = [[1;1] [x(dy(k1)); x(dy(k1)+1)]]\[y(dy(k1)); y(dy(k1)+1)];
    % Linear Fit Near Zero-Crossings
    x0(k1) = -b(1)/b(2);
    % Interpolate ‘Exact’ Zero Crossing
    mb(:,k1) = b;
    % Store Parameter Estimates (Optional)
end
freq = 1./(2*diff(x0));
Periodbitdifferencetime=diff(x0);                                                                                     % Time difference between each two adjacent zero crossing points
Periodbitdifferencetime=Periodbitdifferencetime/0.00001;                                                              % Dividing by the symbol rate=bit rate=50Khz - 1/50K .
Occurances=round(Periodbitdifferencetime);                                                                            % each value of this array is a number of occurances for every bit
NegativePositiveValuesSearch = +(AmplitudeMiddleEachDifference > 0);                                                  % if AmplitudeMiddleEachDifference(i) is positive then the received value bit is 1, otherwise 0.
SimpleLinkWord=[0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 1 1 0 0 0 0 1 1 0 0 1 1 1 1 0 0 1 1 0 0 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 1 1 0 0 1 1 0 0]; % Syncword of simplelink mode(inverted Syncword) according to TI manual.
DecryptedBinarySignal = repelem(NegativePositiveValuesSearch, Occurances);                                            % DecryptedBinarySignal is a decrypted array of my signal.
DSSS=4;                                                                                                               % DSSS opitions {1,2,4,8} - the attached example/sampled datta of fm.dat DSSS =4 used.
DataOffsetFollowingSyncwordCrcCheck = TruncateSyncWordResultCheck(DecryptedBinarySignal, SimpleLinkWord , DSSS);      % Crc check respectively to each occurance of the given Syncword.
DataOffsetFollowingSyncwordCrcCheckOutput=array2table([DataOffsetFollowingSyncwordCrcCheck(:), (1:numel(DataOffsetFollowingSyncwordCrcCheck)).'], 'VariableNames', {'PacketCrcCheck Output', 'Packet Number'});  % Final result of CRCcheck upon transmitted packets.
end
