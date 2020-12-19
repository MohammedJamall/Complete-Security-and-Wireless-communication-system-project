function CrcOK=CrcValidationCheck(RxBuffer)               % Checking and Verifying if crc is Ok or not Ok according to each Syncword's occurance.
    CheckSum = uint16(0); 
    CRC_INIT=0xFFFF;                                      % Hexa Value according to CRC scheme of cc1350 Texas Instrument handbook
    CheckSum = CRC_INIT;
    i=1;
    while i <= numel(RxBuffer)
        CheckSum = calcCRC(RxBuffer(i), CheckSum);        % Calculating CRC for each packet.
        i = i + 1;
    end
    disp(CheckSum);
    if (CheckSum == 0)
        CrcOK = true;                                     % your packet is Valid.
    else
        CrcOK = false;                                    % your packet is inValid.
    end    
end
