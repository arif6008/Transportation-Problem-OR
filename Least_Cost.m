function[]= Least_Cost(A,ODVec,OSVec)
A1=A;

if sum(ODVec)==sum(OSVec)
    DVec=ODVec;
    SVec=OSVec;
    [row1,col1]=size(A);
    fprintf('Balanced Case:\n');
else sum(ODVec)~=sum(OSVec)
    fprintf('Unbalanced Case:\n');
    diff=sum(OSVec)-sum(ODVec);
    DVec=ODVec;
    DVec(length(ODVec)+1)=diff;
    SVec=OSVec;
    [row1,col1]=size(A);
    for i=1:row1
        A(i,col1+1)=0;  %%%
    end
end
[row, col] = size(A);
x = zeros(row,col);
B = A;
SumSVec = (sum(SVec));
SumDVec = (sum(DVec));
m=0;
while(SumSVec >0 && SumDVec >0 )
    least_val = min(min(B));
    [i,j]=find(B==least_val);
    if length(i)>1 && length(j)>1
        i=i(1);
        j=j(1);
    end
    if(SVec(i)<DVec(j))%% Check supply less than demand
        x(i,j)= SVec(i); %%Keep the value stored to that location
        DVec(j)= DVec(j)-SVec(i) ; %% Calculate demand - supply
        SVec(i)= SVec(i)-SVec(i);
        B(i,:)=1e5; %% Assign a new huge value
    elseif(SVec(i)>DVec(j)) %%Check the supply greater than equal to demand
        x(i,j)= DVec(j); %% Calculate amount * demand
        SVec(i)=SVec(i)-DVec(j); %%Calculate supply - demand
        DVec(j)= DVec(j)-DVec(j);
        B(:,j)=1e5 ;
    elseif(SVec(i)== DVec(j))
        x(i,j)= DVec(j);
        SVec(i)= SVec(i)-DVec(j);
        DVec(j)= DVec(j)-DVec(j);
        B(i,:)=1e5;
        B(:,j)=1e5;
    end
    i=[];
    j=[];
    SumSVec = (sum(SVec));
    SumDVec = (sum(DVec));
    m=m+1;
    fprintf('The intermediate cost matrix in step: %d', m);
    fprintf('\n');
    disp(x);
    
    %Assigned_Units_Matrix = x;
    %Allocated_Cost_Matrix_LCM = (A1.*x);
    %Total_Cost_LCM = sum(sum(Allocated_Cost_Matrix_LCM))
end
if (col1==col)
    Assigned_Units_Matrix = x
    Allocated_Cost_Matrix_LCM = (A1.*x);
    Total_Cost_LCM = sum(sum(Allocated_Cost_Matrix_LCM))
    fprintf('Number of Allocation: %d', nnz(x));
    fprintf('\n');
    %disp(A);
    %disp(x);
end
if (col1~=col)
    x1=zeros(row1,col1);
    for i=1:row1
        for j=1:col1
            x1(i,j)=x(i,j);
        end
    end
    Assigned_Units_Matrix = x1
    Allocated_Cost_Matrix_LCM = (A1.*x1);
    Total_Cost_LCM = sum(sum(Allocated_Cost_Matrix_LCM))
    fprintf('Number of Allocation: %d', nnz(x1));
    fprintf('\n');
    %disp(A);
    %disp(x1);
end

end