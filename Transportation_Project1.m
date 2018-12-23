function[Final_Cost_Matrix,Total_Cost]= Transportation_Project1(CMat,SVec,DVec)
% =============== Introduction====================%%
fprintf('%% =============== Project Information====================%%\n')
fprintf('Course: MSIM 722: Cluster Parallel Computing Project\n')
fprintf('Student: Md Ariful Haque\n')
fprintf('UIN: 01061816, Old Dominion University\n')
fprintf('%% =============== Input Description====================%%\n')
fprintf('CMat == cost matrix\n')
fprintf('SVec == Supply Vector \n')
fprintf('DVec == cost Demand Vector \n')
fprintf('option == method of input. 1=user input manually, 2=inputs generate randomly\n')
option=input('Select method of input, option=' )
if (option==1)
    CMat=input('CMat ='); % request user to input the cost matrix A
    SVec=input('SVec ='); % request user to input the Supply Vector
    DVec=input('DVec ='); % request user to input the Demand Vector
    A = CMat;
end
if (option==2)
    fprintf('Input Number of Rows\n')
    M=input('M=');
    fprintf('Input Number of Columns\n')
    N=input('N=');
    fprintf('Input Upper Limit of Cost Vector\n')
    Cost_Upper=input('Cost_Upper=');
    Cost_Lower=input('Cost_Lower=');
    
    CMat =randi([Cost_Lower Cost_Upper],M,N);  % 4x4 matrix within value range from 4 to 9
    X1=randi([20 60],1,M); % For generating SVec
    X2=randi([20 60],1,N);   % For generating DVec
    m=0;
    A=CMat;
    while (1)
        if sum(X1)>sum(X2)
            SVec=X1;
            DVec=X2;
            break;
        elseif sum(X1)<sum(X2)
            X1=randi([20 60],1,M);
            X2=randi([20 60],1,N);
            if sum(X1)>sum(X2)
                SVec=X1;
                DVec=X2;
                break;
            end
            m=m+1;
        elseif sum(X1)==sum(X2)
            SVec=X1;
            DVec=X2;
            break;
        end
    end
end
% % checking if proble m is balanced
[row, col] = size(A);
Total_Supply = 0;
Total_Demand = 0;
for i= 0:1:row-1
Total_Supply = sum(SVec);
end
for i= 0:1:col-1
Total_Demand = sum(DVec);
end
% % ====== balancing the problem ==========%%
% if (Total_Demand > Total_Supply)
% shortage = Total_Demand - Total_Supply;
% B= zeros(1,col);
% A = [A(1:row,:); B];
% SVec = [SVec(1,:) shortage] ;
% end
% if (Total_Supply > Total_Demand)
% surplus = Total_Supply-Total_Demand;
% B= zeros(1,row)';
% A = [A(:,1:col), B];
% DVec = [DVec(1,:) surplus];
% end
%======== Formation of the transportation table ==== %%
if (Total_Demand > Total_Supply)
B= [DVec, Total_Demand];
C = [A, SVec'];
Transportation_Table = [C;B]
display('Last column represents Sink/Demands')
display('Last row represents Source/Supplies')
end
if (Total_Supply >= Total_Demand)
B= [SVec,Total_Supply];
C = [A;DVec];
Transportation_Table = [C,B']
display('Last column represents Sink/Demands')
display('Last row represents Source/Supplies')
end
% SVec = SVec';
fprintf('method == method of solution.\n')
fprintf('===================================\n')
fprintf('Method of solution.\n')
fprintf(' 1 = North-West Corner Method\n')
fprintf(' 2 = Least Cost Method\n')
fprintf(' 3 = Vogel Approximation Method (VAM)\n')
fprintf('===================================\n')
method=input('Select method of solution, method=' ); % request user to select solution method
% checking if method exists
if (method == 1)
    display('North-West Corner Method')
elseif (method == 2)
    display('Least Cost Method')
elseif (method == 3)
    display('Vogel Approximation Method (VAM)')
else
    error('Mehtod does not exist, please choose from the above methods')
return;
end
exiting = 0;
if exiting == 1
return;
end
% ============Calling Phase-I Functions ============== %%%
if (method == 1)
    North_West_Corner(A,DVec,SVec)
elseif (method == 2)
    Least_Cost(A,DVec,SVec)
elseif (method == 3)
    VAM(A,DVec,SVec)
else
return;
end
% ============Calling Phase-II OPTIMAL Functions ============== %%%
fprintf('optimum == optimum method of solution.\n')
fprintf('===================================\n')
fprintf('Phase-II Optimum Method of solution.\n')
fprintf(' 1 = MODI\n')
fprintf(' 2 = Stepping Stone\n')
fprintf(' 3 = Degenerate Solution using MODI\n')
fprintf(' 4 = Exit\n')
fprintf('===================================\n')
optimum=input('Select method of solution, optimum=' ); % request user to select solution method
% checking if method exists
if (optimum == 1)
    display('MODI Method')
elseif (optimum == 2)
    display('Stepping Stone Method')
elseif (optimum == 3)
    display('Degenerate Solution using MODI')
elseif (optimum == 4)
    display('Exiting..')
    return;
else
    error('Mehtod does not exist, please choose from the above methods')
return;
end
exiting = 0;
if exiting == 1
return;
end
% ============Calling Functions ============== %%%
if (optimum == 1)
    display('MODI Method')
    display('Input the Initial Basic Feasible Solution')
    x=input('x ='); % request user to input the cost matrix x
    MODI(A,x) %%%Take input matrix of IBFS; Need to modify
elseif (optimum == 2)
    display('Stepping Stone Method')
    display('Input the Initial Basic Feasible Solution')
    x=input('x ='); % request user to input the cost matrix x
    SSM(A,x)
elseif (optimum == 3)
    display('Degenerate Method')
    display('Input the Initial Basic Feasible Solution')
    x=input('x ='); % request user to input the cost matrix x
    MODI_Degen(A,x)
else
return;
end
end