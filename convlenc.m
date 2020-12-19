%Convolutional Encoder ; input=1 bit -> output=2 bits with 7 memory elements, Code Rate=1/2
function [encoded_sequence]=convlenc(message , enco_mem)
%TEST MESSAGES
% message=[1 0 1 0 1 1 1 0 0 0 1 1 0 1 1 0 0];%prb 0-1
% message=[0 0 1 0 1 0 1 0 1 0 0 1 1 0 1 0 0];
% message=[1 1 1 0 1 0 1 1 0 1 0 0 1 0 1 0 0];%prb 0-1

%enco_mem=[0 1 1 1 0 1 0]; %[0 0 0 0 0 0 0];   %# of memory elements=7

encoded_sequence=zeros(1,(length(message))*2);
       
       %enco_mem(1,7)=enco_mem(1,6);
       enco_mem(1,1)=enco_mem(1,2);
       enco_mem(1,2)=enco_mem(1,3);
       enco_mem(1,3)=enco_mem(1,4);
       enco_mem(1,4)=enco_mem(1,5);
       enco_mem(1,5)=enco_mem(1,6);
       enco_mem(1,6)=enco_mem(1,7);
       enco_mem(1,7)=message(1,1);
       temp76=xor(enco_mem(6),enco_mem(7));
       temp4=xor(enco_mem(4),temp76);
       temp3=xor(enco_mem(3),temp4);
       o2=xor(temp3,enco_mem(1));
       temp74=xor(enco_mem(4),enco_mem(7));
       temp34=xor(enco_mem(3),temp74);
       temp2=xor(enco_mem(2),temp34);
       o1=xor(temp2,enco_mem(1));             
       encoded_sequence(1,1)=o1;
       encoded_sequence(1,2)=o2;
msg_len=length(message);
c=3;
for i=2:msg_len
         
       enco_mem(1,1)=enco_mem(1,2);
       enco_mem(1,2)=enco_mem(1,3);
       enco_mem(1,3)=enco_mem(1,4);
       enco_mem(1,4)=enco_mem(1,5);
       enco_mem(1,5)=enco_mem(1,6);
       enco_mem(1,6)=enco_mem(1,7);
       if(i<=msg_len)
           enco_mem(1,7)=message(1,i);
       else
           enco_mem(1,7)=0;
       end
       temp76=xor(enco_mem(6),enco_mem(7));
       temp4=xor(enco_mem(4),temp76);
       temp3=xor(enco_mem(3),temp4);
       o2=xor(temp3,enco_mem(1));
       temp74=xor(enco_mem(4),enco_mem(7));
       temp34=xor(enco_mem(3),temp74);
       temp2=xor(enco_mem(2),temp34);
       o1=xor(temp2,enco_mem(1));
       encoded_sequence(1,c)=o1;    %o1 generating polynomial
       c=c+1;
       encoded_sequence(1,c)=o2;    %o2 generating polynomial
       c=c+1;
end
