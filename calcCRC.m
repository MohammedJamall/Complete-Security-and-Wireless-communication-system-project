function crcReg = calcCRC(crcData, crcReg) % CRC Calculation
    CRC16_POLY = 0x8005;
    for i = 0 : 7
        if bitxor( bitshift( bitand(crcReg, 0x8000), -8), ...
                bitand( uint16(crcData), 0x0080 ) )
            crcReg = bitxor( bitshift(crcReg, 1), CRC16_POLY );
        else
            crcReg = bitshift(crcReg, 1);
        end
        crcData = uint16(bitshift(uint16(crcData), 1));
    end