function[]= VAM(A,ODVec,OSVec)
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
m = size(A,1);
n = size(A,2);
x = zeros(m,n);

stop = 0;
step=1;
while stop == 0
    for i = 1:m
        for j = 1:n
            if SVec(1,i) == 0 % previously SVec(i,1) == 0
                A(i,j) = max(A(:,j));
            end
            if DVec(1,j) == 0
                A(i,j) = max(A(i,:));
            end
        end
    end
    Col_Min = sort(A,1);
    Row_Min = sort(A,2);
    Diff_Demand = abs(Col_Min(1,:) - Col_Min(2,:));
    Diff_supply = abs(Row_Min(:,1) - Row_Min(:,2));
    for i = 1:m
        if SVec(1,i) == 0 %previously SVec(i,1) == 0
            Diff_supply(i,1) = 0;
        end
    end
    for j = 1:n
        if DVec(1,j) == 0
            Diff_Demand(1,j) = 0;
        end
    end 
    Col_Diff = max(Diff_Demand);
    Row_Diff = max(Diff_supply);
    
    New_Demand_Vec = find(Diff_Demand==max(Col_Diff,Row_Diff));
    New_Supply_Vec = find(Diff_supply==max(Col_Diff,Row_Diff));
    
    if ((isempty(New_Demand_Vec) == 0)&& (isempty(New_Supply_Vec) == 1))
        New_Supply_Vec_ = find(A(:,New_Demand_Vec(1)) == min(A(:,New_Demand_Vec(1))));
        x(New_Supply_Vec_(1),New_Demand_Vec(1)) = min(SVec(1,New_Supply_Vec_(1)),DVec(1,New_Demand_Vec(1)));
        SVec(1,New_Supply_Vec_(1)) = SVec(1,New_Supply_Vec_(1)) - x(New_Supply_Vec_(1),New_Demand_Vec(1));
        DVec(1,New_Demand_Vec(1)) = DVec(1,New_Demand_Vec(1)) - x(New_Supply_Vec_(1),New_Demand_Vec(1));
        New_Supply_Vec = [];
    end
    if ((isempty(New_Supply_Vec) == 0) && (isempty(New_Demand_Vec) == 1)) 
        New_Demand_Vec_ = find(A(New_Supply_Vec(1),:) == min(A(New_Supply_Vec(1),:)));
        x(New_Supply_Vec(1),New_Demand_Vec_(1)) = min(SVec(1,New_Supply_Vec(1)),DVec(1,New_Demand_Vec_(1)));
        SVec(1,New_Supply_Vec(1)) = SVec(1,New_Supply_Vec(1)) - x(New_Supply_Vec(1),New_Demand_Vec_(1));
        DVec(1,New_Demand_Vec_(1)) = DVec(1,New_Demand_Vec_(1)) - x(New_Supply_Vec(1),New_Demand_Vec_(1));
    end
    if ((isempty(New_Supply_Vec) == 0) && (isempty(New_Demand_Vec) == 0))
        New_Demand_Vec_ = find(A(New_Supply_Vec(1),:) == min(A(New_Supply_Vec(1),:)));
        x(New_Supply_Vec(1),New_Demand_Vec_(1)) = min(SVec(1,New_Supply_Vec(1)),DVec(1,New_Demand_Vec_(1)));
        SVec(1,New_Supply_Vec(1)) = SVec(1,New_Supply_Vec(1)) - x(New_Supply_Vec(1),New_Demand_Vec_(1));
        DVec(1,New_Demand_Vec_(1)) = DVec(1,New_Demand_Vec_(1)) - x(New_Supply_Vec(1),New_Demand_Vec_(1));
    end
    fprintf('Intermediate Allocation Matrix in step: %d', step);
    fprintf('\n');
    disp(x);
    step=step+1;
    %disp(SVec);
    %disp(DVec);
    %%$$
%Stop condition:
    a1 = SVec > 0;
    b1 = DVec > 0;
    if sum(a1) == 1
        stop = 1;
        for j = 1:n
            if DVec(j) > 0
                x(a1 == 1,j) = DVec(j);
                fprintf('Intermediate Allocation Matrix in step: %d', step);
                step=step+1;
                fprintf('\n');
                disp(x);
                %disp(SVec);
                %disp(DVec);
            end
        end
    end
    if sum(b1) == 1
        stop = 1;
        for i = 1:m
            if SVec(i) > 0
                x(i,b1 == 1) = SVec(i);
                fprintf('Intermediate Allocation Matrix in step: %d', step);
                fprintf('\n');
                disp(x);
                %disp(SVec);
                %disp(DVec);
            end
        end
    end

end%%end of while

if (col1==col)
    Allocated_Unit_Cost_Matrix = x
    Allocated_Cost_Matrix_VAM = (A1.*x);
    Total_cost_VAM = sum(sum(Allocated_Cost_Matrix_VAM))
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
    Allocated_Unit_Cost_Matrix = x1
    Allocated_Cost_Matrix_VAM = (A1.*x1);
    Total_cost_VAM = sum(sum(Allocated_Cost_Matrix_VAM))
    fprintf('Number of Allocation: %d', nnz(x1));
    fprintf('\n');
    %disp(A);
    %disp(x1);
end
% Assigned_Units_Matrix = x
% Allocated_Cost_Matrix_VAM = (A1.* x)
% Total_cost_VAM = sum(sum(Allocated_Cost_Matrix_VAM))
%modi(A,x)
end