function ByteConvertRxBuffer=ByteConvertRxBuffer(rx, Length)           % Converting binary array to Byte array- each 8bit to unsigned int value. 
    rx=num2str(rx);
    rx=rx(rx~=' ');
    rx=bin2dec(reshape(rx,8,[])')';
    ByteConvertRxBuffer=uint8([rx,zeros(1,(Length/8)-length(rx))]);    % Length divided by 8 because each value represents 8bit uint , so we need to divide the length of (payload+crc) binary stream by 8;
    disp(ByteConvertRxBuffer);                                         % Displaying the converted array type Byte (if needed) - i.e diplaying transmitted payload+CRC in terms of Byte's data type.
end



