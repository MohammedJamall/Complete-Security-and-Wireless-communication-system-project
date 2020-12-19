function decoded = viterbi_decoder(G, received)
% INPUT: 
%   G: generator matrix
%   received: received bit streams to be decoded
% OUTPUT: 
%   decoded: decoded bit stream

K=7;                                                                       % k: entry size or shift length
k=1;
extra_bits=0;
states=0:63;                                                               % 2^(K-1) , for our case 2^6.
states=de2bi(states,6, 'left-msb');                                        % states used for possibilities of the cases.
parity_length=size(G,1);
x_n=0:1;
x_n= de2bi(x_n, 1,'left-msb');                                             % Left msb first.
previous_state=zeros(2,4,size(states,1));                                  % previous_state for history's storing.
array=[];
G=G';

    % @ viterbi Implementation %
for i=1:length(states)                                                     % viterbi Implementation, covering all the states. 
    for j=1:size(x_n,1)
        temp = [fliplr(x_n(j,:)) states(i,:)];
        index = find(ismember(states,temp(1:end-k), 'rows'), 1);
        parity = mod(temp*G,2);                                            % parity for viterbi 
        new_entry_row=find(previous_state(:,1,index)==0);
        array=[i x_n(j,1) parity];                                       
        for m=1:4
            previous_state(new_entry_row(1),m,index)=array(m);
        end
    end
end
arc_bits=zeros(size(states,1),k,length(received)/parity_length);
path=zeros(size(states,1),length(received)/parity_length+1);               % updating the optimal path of the viterbi based on Maximizing Likelihood Estimation.
coming_from_state=zeros(size(path)-[0,1]);                                 % state that you came from (storing the history for the previous cycle)
path(:,1)=path(:,1)./path(:,1);
path(1,1)=0;
step=2;
for i=1:parity_length:length(received)
    rcvd_parity=received(i:i+parity_length-1);
    for j=1:2^(K-k)
        temp_path=zeros(1,2^k);
        for l=1:2^k
            temp_path(l)=path(previous_state(l,1,j),step-1)+sum(abs(previous_state(l,(2+k):end,j)-rcvd_parity));
        end
        [path(j,step),index]=min(temp_path);
        coming_from_state(j,step-1)=previous_state(index,1,j);
        arc_bits(j,:,step-1)= previous_state(index,2:2+(k-1),j);   
    end
    step=step+1;
end
decoded=[];
[~,index]=min(path(:,end));
for i=size(coming_from_state,2):-1:1
      decoded=[decoded fliplr(arc_bits(index,:,i))];     
      index=coming_from_state(index,i);                                    
end
decoded(1:extra_bits)=[];
decoded=fliplr(decoded);
end