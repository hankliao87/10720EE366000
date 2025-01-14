function [DC,X,RLcode] = encode_Huffman(x)
% This version retrieve data fromw cell
% This function do two implement:
% 1.zigzag scan
% 2.RL encode
X = zeros(1,64);

% zigzag scan, X will be come 1*64 vector
count=1;
for k=2:16
    if mod(k,2)==1
        for i=1:8
            for j=1:8
                if (i+j) == k
                    X(1,count)=x(i,j);
                    count=count+1;
                end
            end
        end   
    else
        for j=1:8
            for i=1:8
                if (i+j) == k
                    X(1,count)=x(i,j);
                    count=count+1;
                end    
            end
        end   
    end
end
% DC term
DC = X(1,1);
RLcode={};

% Run length encode, This method encodes all AC term, 
% and each cell contain three information
% RLcode = [num,size,val]
% num = number of zeros before this element
% size = number of bits needed to represent element value (floor,log2)
% val = actual value of the element
% (0,0) represent the array contains 0 to the end of 8*8 -1 matrix (no DC)
num_zero=0;
for i=2:64
    if i==64 && X(1,i)==0
        RLcode = [RLcode,[0,0]];
    elseif X(1,i)==0
        num_zero=num_zero+1;
        if num_zero==16
            size = 0;
            RLcode =[RLcode,[num_zero,size,X(1,i)]];
            num_zero=0;
        end
    else
        size = floor(log2(abs(X(1,i))))+1;
        RLcode =[RLcode,[num_zero,size,X(1,i)]];
        num_zero=0;
    end    
end
RLcode = check_RLencode(RLcode);
X=reshape(X,[8,8]).';