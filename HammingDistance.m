function HammingDistance=HammingDistance(arr)
tuple = cell2mat({ 1 0 0 0 ; 1 1 1 1 ; 0 0 0 0});
n = sum(xor(tuple,arr),2); %calculates hamming distance differences
[minn, ~]=min(n);
HammingDistance=tuple(n==minn,:);
%LegacySyncWord=[1 1 1 1 1 1 0 1 1 1 1 0 1 0 1 1 0 0 1 0 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 1 0 0 1 1 0 1 0 1 1 0 0 1 1 1 1 1 1 1];
%hamming distance between array a and b is
%sum(abs(a-b))
%for a b binary, abs(a-b) is xor(a,b). Just write down the 2 x 2 table to see
%xor | 0 1
%----+-----
 % 0 | 0 1
 % 1 | 1 0
end


%{
for i=1:RowsNumber
    PayLoadPacketLength(i,32)=ReverseDirectSequenceSpreadSpectrum(DSSS,PayLoadPacketLength(i,:));
    PayLoadPacketLength(i,16)=viterbi_decoder_generalized([1 0 0 1 1 1 1 ; 1 1 0 1 1 0 1] ,PayLoadPacketLength(i,:));
    PayLoadPacketDecimalLength(i)= bin2dec(num2str(PayLoadPacketLength(i,:)));                                                                                                                                   % Converting 8-bit of payload length identifying from binary to decimal value at each occurance.
    TruncatedSubstring= cell2mat(arrayfun(@(idx) input1(idx+length(substring):idx+length(substring)+((PayLoadPacketDecimalLength(i))*8*2*DSSS)-1), positions, 'uniform', 0 ).');                                          % this matrix of all following dataoffset of syncWord occurances aside to the 8bit of payload length identifying- i.e all data offset of payload + CRC(16 bit- two bytes). At each row of this matrix represents Payload+CRC data of each occurance respectively.
end
[NumberOfRows,~]=size(TruncatedSubstring);                                                                                                                                                                       % number of rows of the (payload+crc) matrix.
for i=1:NumberOfRows
   TruncatedSubstring(i,:)=ReverseDirectSequenceSpreadSpectrum(DSSS,TruncatedSubstring(i,:));
   TruncatedSubstring(i,:)=viterbi_decoder_generalized([1 0 0 1 1 1 1 ; 1 1 0 1 1 0 1] , TruncatedSubstring(i,:));
   SubString = TruncatedSubstring(i,:);                                                                                                                                                                          % Sniffing and extracting all following dataoffset at each row of TruncatedSubstring's matrix.
   ResultByteConversion(i,:)=ByteConvertRxBuffer(SubString,(PayLoadPacketDecimalLength(i)*8));                                                                                                              % Converting each dataoffset((payload)+crc data=(32*8)+16) from binary to Byte array values. 
   TruncateSyncWordResultCheck(i,:)=CrcValidationCheck(ResultByteConversion(i,:));                                                                                                                               % TruncateSyncwordResult is a matrix of all crcCheck for each packet's occurance.
end
}%