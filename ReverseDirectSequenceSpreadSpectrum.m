function ret=ReverseDirectSequenceSpreadSpectrum(DSSS,array)  
% INPUT: 
%   DSSS: Value of DSSS.
%   array: received bit streams to be De-DSSS.

% OUTPUT: 
%   ret: De-DSSS sequence output

%####Table of DSSS :  ####%

% multiple     Mapped Value = 0         Mapped Value= 1
%   1                     0                       1
%   2                    00                      11
%   4                  1100                    0011
%   8              11001100                00110011
  
  ret=[];                                                      % result's utput
  switch DSSS
      case 1
          l=[0;1];                                             % for DSSS first opition
          for k=1:length(array)
              ret=[ret,find(ismember(l,array(k)))-1];
          end
      case 2
          l=[0 0;1 1];                                         % for DSSS second opition
          array=reshape(array,2,[])';
          for k=1:size(array,1)
              ret=[ret,find(ismember(l,array(k,:),'rows'))-1];
          end
      case 4
          l=[0 0 1 1;1 1 0 0];                                 % for DSSS third opition
          array=reshape(array,4,[])';
          for k=1:size(array,1)
              ret=[ret,find(ismember(l,array(k,:),'rows'))-1];
          end
      case 8
          l=[0 0 1 1 0 0 1 1; 1 1 0 0 1 1 0 0];                % for DSSS fourth opition
          array=reshape(array,8,[])';
          for k=1:size(array,1)
              ret=[ret,find(ismember(l,array(k,:),'rows'))-1];
          end
  end
end