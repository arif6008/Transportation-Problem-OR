function[]= MODI_2(A,x,y)
% x: Initial Basic Feasible Solution (m*n)
% b: 1 for each basic variables 0 for nonbasic (m*n)
% A: costs (m*n)
% u: multipliers for rows (m*1)
% v: multipliers for columns (n*1)
Matrix_for_Next_Iteration = x;
[m,n]=size(x);
x_origin=y;
for i = 1:m
    for j=1:n
        if x(i,j)==0
            b(i,j)= 0;
        else
            b(i,j)=1;
        end
    end
end
%Multiplier function like action
if sum(sum(b))< m+n-1
    disp('Error in multipliers--Degenerate Case')
    return;
else
    u=Inf*ones(m,1);
    v=Inf*ones(n,1);
    u(1)=0; % choose an arbitrary multiplier = 0
    nr=1;
    while nr<m+n % until all multipliers are assigned
        for row=1:m
            for col=1:n
                if b(row,col)>0
                    if (u(row)~=Inf) && (v(col)==Inf)
                        v(col)=A(row,col)-u(row);
                        u(row)=u(row);
                        nr=nr+1;
                    elseif (u(row)==Inf) && (v(col)~=Inf)
                        u(row)=A(row,col)-v(col);
                        v(col)=v(col);
                        nr=nr+1;
                    end
                end
            end
        end
    end
end
%end of multiplier


for row=1:m
    for col=1:n
        if b(row,col)==0
            if (u(row)~=Inf)&&(v(col)~=Inf)
                e(row,col)=A(row,col)-u(row)-v(col); %% computing opportunity cost for the unoccupied cells
            else
                j=j+1;
            end
        end
    end
end

D=b; %New matrix that will contain all b elements plus cij-ui-vj values
for i=1:m
    for j=1:n
        if D(i,j)==0
            D(i,j)=e(i,j);
        end
    end
end
opportunity_cost_matrix = e;
minval = min(min(D));

for i=1:m
    for j=1:n
        if D(i,j)==minval
            xpos=i;
            ypos=j;
        end
    end
end


if minval<0
    fprintf('Optimum Solution : ');
    x1=cycle(x,xpos,ypos,b)
    Optimal_Cost_matrix = x1.*A;
    Optimal_Cost_value = sum(sum( x1.*A))
    fprintf('Cost Reduced By : %d',sum(sum(x_origin.*A))-sum(sum( x1.*A)));
    fprintf('\n');
    MODI_2(A,x1,x_origin);  
elseif (minval==0)
    fprintf('Alternate Optimum Solution :');
    x1=cycle(x,xpos,ypos,b)
    Optimal_Cost_matrix = x1.*A;
    Optimal_Cost_value = sum(sum( x1.*A))
    fprintf('Cost Reduced By : %d',sum(sum(x_origin.*A))-sum(sum( x1.*A)));
    fprintf('\n');
end
end