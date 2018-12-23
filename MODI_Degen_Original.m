function[]= MODI_Degen_Original(A,x)
% x: Initial Basic Feasible Solution (m*n)
% b: 1 for each basic variables 0 for nonbasic (m*n)
% A: costs (m*n)
% u: multipliers for rows (m*1)
% v: multipliers for columns (n*1)
Matrix_for_Next_Iteration = x;
[m,n]=size(x);
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
u=Inf*ones(m,1);
v=Inf*ones(n,1);
u(1)=0; % choose an arbitrary multiplier = 0
nr=1;
while nr<m+n-1 % until all multipliers are assigned
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
                elseif (u(row)==Inf) && (v(col)==Inf)
                    u(row)=u(row);
                    v(col)=v(col);
                    nr=nr+1;
                end
            end
        end
    end
end
%end of multiplier

%%%Identifying the postion to place the Epsilon
b_mod=b;

loop=[];
for row=1:m
    for col=1:n
        if b(row,col)==0
            b_mod(row,col)=0.0001;
            if ((u(row)==Inf) && (v(col)~=Inf))||((u(row)~=Inf) && (v(col)==Inf))||((u(row)==Inf) && (v(col==Inf)))
                xpos=row;
                ypos=col;
                loop=[xpos ypos;loop];
                b_mod(row,col)=0;
            end
        end
    end
end
%%%Identifying the postion to place the Epsilon ends; loop is the position
%%%of epsilon

[m1,n1]=size(loop);
b2=b;


for i=1:m1
    b2=b;
    b2(loop(i,1),loop(i,2))=0.0001;
    u=Inf*ones(m,1);
    v=Inf*ones(n,1);
    u(1)=0; % choose an arbitrary multiplier = 0
    nr=1;
    while nr<m+n % until all multipliers are assigned
        for row=1:m
            for col=1:n
                if b2(row,col)>0
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

    for row=1:m
        for col=1:n
            if b2(row,col)==0
                if (u(row)~=Inf)&&(v(col)~=Inf)
                    e(row,col)=A(row,col)-u(row)-v(col); %% computing opportunity cost for the unoccupied cells
                end
            end
        end
    end

    opportunity_cost_matrix = e;
    minval = min(min(e));

    for k=1:m
        for j=1:n
            if e(k,j)==minval
                xpos=k;
                ypos=j;
            end
        end
    end
    x2=x;
    x2(loop(i,1),loop(i,2))=0.0001;
    fprintf('Epsilon Position: %d, %d', loop(i,1), loop(i,2));
    fprintf('\n');
    if minval<0
        fprintf('Optimum Solution At this iteration: ');
        x1=cycle(x2,xpos,ypos,b2);
        x3=int64(x1)
        A=int64(A);
        x=int64(x);
        if (sum(sum(x.*A))-sum(sum( x3.*A)))>0
            Optimal_Cost_matrix = x3.*A;
            Optimal_Cost_value = sum(sum(x3.*A))
            fprintf('Cost Reduced By : %d',sum(sum(x.*A))-sum(sum( x3.*A)));
            fprintf('\n Next Iteration:');
            fprintf('\n');
            MODI_2(A,x3); 
        end

    %end

    elseif minval==0
        fprintf('Alternate Optimum Solution :');
        x1=cycle(x2,xpos,ypos,b2);
        x3=int64(x1)
        A=int64(A);
        x=int64(x);
        Optimal_Cost_matrix = x3.*A;
        Optimal_Cost_value = sum(sum( x3.*A))
        fprintf('Cost Reduced By : %d',sum(sum(x.*A))-sum(sum( x3.*A)));
        fprintf('No Change in Cost');
        fprintf('\n');
    end
end
