function[]= SSM(A,x)
%A is the cost matrix
%x is the initial basic feasible solution
Matrix_for_Next_Iteration = x
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
zeroposition=[];
for i=1:m
    for j=1:n
        if b(i,j)==0
            xpos=i;
            ypos=j;
            zeroposition=[xpos ypos;zeroposition];
        end
    end
end
%a_loop = loop( [1:length(loop)-1] , : );% loop without the [0 0] values
%a_loop contains all the matrix position which are to be set to equal to +1
a_loop=zeroposition;
[m1,n1]=size(zeroposition);
NDIC_loop=[];
for i=1:m1
    row=zeroposition(i,1);
    col=zeroposition(i,2);
    x1=SSM_CYCLE(x,row,col,b);
    NDIC=sum(sum(A.*x1))-sum(sum(A.*x));
    NDIC_loop=[row col NDIC;NDIC_loop];    
end

[m2,n2]=size(NDIC_loop);
NDIC_mim=min(NDIC_loop(:,3));
j=0;
for i=1:m2
    if (NDIC_loop(i,3)<0 && NDIC_loop(i,3)==NDIC_mim)
        xpos=NDIC_loop(i,1);
        ypos=NDIC_loop(i,2);
        fprintf('Optimum Solution : ');
        x2=cycle(x,xpos,ypos,b)
        Optimal_Cost_matrix = A.*x2;
        Optimal_Cost_value = sum(sum( A.*x2))
        fprintf('Cost Reduced By : %d',sum(sum(A.*x))-sum(sum(A.*x2)));
        fprintf('\n');
        SSM(A,x2);
    elseif (NDIC_loop(i,3)==0 && NDIC_mim==0)
        fprintf('Optimum Solution : ');
        fprintf('\n');
        disp(x);
        Optimal_Cost_matrix = x.*A;
        Optimal_Cost_value = sum(sum( x.*A))
        fprintf('Cost Reduced By : %d',sum(sum(x.*A))-sum(sum( x.*A)));
        fprintf('\n');
        
        xpos=NDIC_loop(i,1);
        ypos=NDIC_loop(i,2);
        fprintf('Alternate Optimum Solution :');
        x2=cycle(x,xpos,ypos,b)
        Optimal_Cost_matrix = A.*x2;
        Optimal_Cost_value = sum(sum( A.*x2))
        fprintf('Cost Reduced By : %d',sum(sum(A.*x))-sum(sum(A.*x2)));
        fprintf('\n');    
    end
end
