% Decomposition_Importance
%///// Create importance factors using an importance function
%// If Type=='Identical' then decomposition unit uses identical importance function
%// If Type=='Incremental' then decomposition unit uses incremental importance function
%// If Type=='Decremental' then decomposition unit uses decremental importance function
%// n is the number of features
%// Phi is the number of decimal places
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [F] = Decomposition_Importance(Type,n,Phi)
if strcmp(Type,'Identical')==1
    for x=1:n
        if (x<n)
            F(x)=floor((10^Phi)/n)*(10^-Phi);
        else
            F(x)=1-((n-1)*(floor((10^Phi)/n)*(10^-Phi)));
        end;
    end;    
elseif strcmp(Type,'Incremental')==1
    for x=1:n    
        if (x<n)
            F(x)=(2*x)/(n*(n+1));
        else
            Sum=0;
            for y=1:(n-1)
                Sum=Sum+F(y);
            end;
            
            F(x)=1-Sum;
        end; 
    end;
elseif strcmp(Type,'Decremental')==1
    for x=1:n    
        if (x<n)
            F(x)=(2*(n-x+1))/(n*(n+1));
        else
            Sum=0;
            for y=1:(n-1)
                Sum=Sum+F(y);
            end;
            
            F(x)=1-Sum;
        end; 
    end;    
else
    for x=1:n
        F(x)=0;
    end;
end;