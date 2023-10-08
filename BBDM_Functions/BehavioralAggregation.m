% BehavioralAggregation
%///// Construct and update total matrixes using aggregation methods
%// If Type=='Pessimistic' then behavioral aggregation unit uses pessimistic behavioral aggregation
%// If Type=='Optimistic' then behavioral aggregation unit uses optimistic behavioral aggregation
%// If Type=='Fair' then behavioral aggregation unit uses fair behavioral aggregation
%// n is the number of features
%// B is the behavioral matrix
%// T is the current total matrix
%// If Flag=='Yes' then the behavioral style is the first instance; otherwise, if Flag=='No' then the behavioral style is not the first instance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [F] = BehavioralAggregation(Type,n,B,T,Flag)
if strcmp(Flag,'Yes')==1
    for x=1:n
        F(x,1)=B(x,1);
        F(x,2)=B(x,3);
        F(x,3)=B(x,3);
    end; 
elseif strcmp(Flag,'No')==1
    if strcmp(Type,'Pessimistic')==1 
        for x=1:n        
            F(x,1)=(B(x,1)+T(x,1))/2;
            F(x,2)=min(B(x,3),T(x,2));
            F(x,3)=min(B(x,3),min(T(x,2),T(x,3)));  
        end;
    elseif strcmp(Type,'Optimistic')==1
        for x=1:n          
            F(x,1)=(B(x,1)+T(x,1))/2;
            F(x,2)=max(B(x,3),T(x,2));
            F(x,3)=max(B(x,3),max(T(x,2),T(x,3)));
        end;
    elseif strcmp(Type,'Fair')==1
        for x=1:n          
            F(x,1)=(B(x,1)+T(x,1))/2;
            F(x,2)=(B(x,3)+T(x,2))/2;
            F(x,3)=(((min(B(x,3),min(T(x,2),T(x,3)))+max(B(x,3),max(T(x,2),T(x,3))))/2)+T(x,3))/2;   
        end;
    else
        for x=1:n
            F(x,1)=T(x,1);
            F(x,2)=T(x,2);
            F(x,3)=T(x,3);
        end;  
    end;    
else
    for x=1:n
        F(x,1)=T(x,1);
        F(x,2)=T(x,2);
        F(x,3)=T(x,3);
    end;    
end;