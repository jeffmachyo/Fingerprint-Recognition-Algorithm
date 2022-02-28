function s=pearsonweight(a)
%Defining the object type of the matrix A%
if(~isa(a,'double'))
    a=double(a);
end
%s is the central point of the 3*3 matrix%
%Applying the rules of cellular automata to the 3*3 matrix%
%Finding the number of non-zero elements in the 3*3 matrix
ind=find(a);
%Obtaining the length of the linear matrix index
number=length(ind);
 
if number==9
    a(2,2)=[0];
elseif number;
end
s=a(2,2);
