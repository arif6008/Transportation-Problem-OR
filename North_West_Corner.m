function[]= North_West_Corner(A,ODVec,OSVec)
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
B = zeros(row,col);
i = 1;
j = 1;
m=0;
while(i<=row && j<= col)
    if(SVec(i)<DVec(j)) %% Check supply less than demand
        x(i,j)=SVec(i); %%Calculate amount * supply
        DVec(j)= DVec(j)-SVec(i); %% Calculate demand - supply
        SVec(i)= SVec(i)-SVec(i);
        i= i+1; %% Increment i for the deletion of the row or column
    elseif(SVec(i)>DVec(j))%%Check the supply greater than equal to demand
        x(i,j)=DVec(j); %% Calculate amount * demand
        SVec(i)=SVec(i)-DVec(j); %%Calculate supply - demand
        DVec(j)=DVec(j)-DVec(j);
        j= j+1; %% Increment j for the deletion of the row or column
    elseif(SVec(i)== DVec(j))
        x(i,j)=DVec(j);
        SVec(i)= SVec(i)-DVec(j);
        DVec(j)= DVec(j)-DVec(j);
        i=i+1;
        j = j+1;
    end
    m=m+1;
    fprintf('The intermediate cost matrix in step: %d', m);
    fprintf('\n');
    disp(x);
end

if (col1==col)
    Assigned_Units_Matrix = x
    Allocated_Cost_Matrix_NorthWest = (A1.*x);
    Total_Cost_NorthWest = sum(sum(Allocated_Cost_Matrix_NorthWest))
    fprintf('Number of Allocation: %d', nnz(x));
    fprintf('\n');
    if (nnz(x)<row+col-1)
        fprintf('This Solution is Degenerate Solution')
    elseif (nnz(x)==row+col-1)
        fprintf('This Solution is non-degenerate Solution')
    elseif (nnz(x)>row+col-1)
        fprintf('There may be loops in the IBFS')
    end
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
    Allocated_Cost_Matrix_NorthWest = (A1.*x1);
    Total_Cost_NorthWest = sum(sum(Allocated_Cost_Matrix_NorthWest))
    fprintf('Number of Allocation: %d', nnz(x1));
    fprintf('\n');
    if (nnz(x)<row+col-1)
        fprintf('This Solution is Degenerate Solution')
    elseif (nnz(x)==row+col-1)
        fprintf('This Solution is non-degenerate Solution')
    elseif (nnz(x)>row+col-1)
        fprintf('There may be loops in the IBFS')
    end

end
%modi(A,x)
end