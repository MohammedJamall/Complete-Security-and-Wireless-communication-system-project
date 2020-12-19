
function TruncateSyncWordResultCheck= TruncateSyncWordResultCheck(input1,substring, DSSS) 
% INPUT: 
%   input1: Sampled data.
%   substring: Syncword sequence.
%   DSSS: Value of Direct Sequence Spreader.
% OUTPUT: 
%   TruncateSyncWordResultCheck: @TruncateSyncWordResultCheck is returned matrix of all crcCheck of all the packets, crcCheck is stored at each row of the matrix correspondingly to each packet.


FixedFollowed16bitPayLoadLength= 16*DSSS;                                                                                                                                                                                     % LengthByte Identifying of payload multiplied by DSSS , 16 is for 2bytes.                                                 
positions = strfind(input1, substring) ;                                                                                                                                                                                      % First position of each SyncWord's occurance in my input signal.
PayLoadPacketLength= cell2mat(arrayfun(@(idx) input1(idx+length(substring):idx+length(substring)+FixedFollowed16bitPayLoadLength-1), positions, 'uniform', 0 ).');                                                            % this matrix of all 16-bit following the dataoffset of syncWord occurances - i.e 16bit data offset is identifying the payload's Length. At each row of this matrix represents all following 16bit dataOffset of each syncword occurance respectively.
[RowsNumber,~]=size(PayLoadPacketLength);                                                                                                                                                                                     % number of the matrix's rows
PayLoadPacketDecimalLength=[];
for i=1:RowsNumber
    PayLoadPacketLengthDSSS(i,:)=ReverseDirectSequenceSpreadSpectrum(DSSS,PayLoadPacketLength(i,:));
    PayLoadPacketLengthViterbiUpdated(i,:)=viterbi_decoder([1 0 0 1 1 1 1 ; 1 1 0 1 1 0 1] ,PayLoadPacketLengthDSSS(i,:));
    PayLoadPacketDecimalLength(i)= bin2dec(num2str(PayLoadPacketLengthViterbiUpdated(i,:)));                                                                                                                                  % Converting 8-bit stream from binary to decimal value at each syncword occurance.
    disp(PayLoadPacketDecimalLength(i));
    TruncatedSubstring= cell2mat(arrayfun(@(idx) input1(idx+length(substring):idx+length(substring)+((PayLoadPacketDecimalLength(i)+3)*8*2*DSSS)-1), positions, 'uniform', 0 ).');                                            % this matrix of all following dataoffset of syncword occurances included to the 16bit of payload length identifying- i.e all the data offset of payload + CRC(16 bit- two bytes). At each row of this matrix represents Payload+CRC data for each packet respectively.
end
disp(TruncatedSubstring);
[NumberOfRows,~]=size(TruncatedSubstring);                                                                                                                                                                                    
for i=1:NumberOfRows
   TruncatedSubstringDSSS(i,:)=ReverseDirectSequenceSpreadSpectrum(DSSS,TruncatedSubstring(i,:));
   TruncatedSubstringViterbiUpdated(i,:)= viterbi_decoder([1 0 0 1 1 1 1 ; 1 1 0 1 1 0 1] , TruncatedSubstringDSSS(i,:));                                                                                                      % viterbi decoding on the all payload data offset.           
   SubString = TruncatedSubstringViterbiUpdated(i,:);                                                                                                                                                                          % Sniffing and extracting all following dataoffset of the payload for each packet.                                                                                                                                                                         
   ResultByteConversion(i,:)=ByteConvertRxBuffer(SubString,((PayLoadPacketDecimalLength(i))*8));                                                                                                                               % Converting each dataoffset from binary to Byte array values. 
   TruncateSyncWordResultCheck(i,:)=CrcValidationCheck(ResultByteConversion(i,:));                                                                                                                                             % TruncateSyncwordResult is a matrix that returns all crcCheck for each packet's occurance , each row is compatible for each packet's CRCcheck.
end
end
