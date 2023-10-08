% Composition
%///// Determine a confidence rate using composition methods
%// If Type=='Min_degree' then composition unit uses min-degree composition
%// If Type=='Max_degree' then composition unit uses max-degree composition
%// If Type=='Weighted' then composition unit uses weighted composition
%// n is the number of features
%// SM is the success matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [F] = Composition(Type,n,SM)
if strcmp(Type,'Min_degree')==1
    M=SM(1,1);
    for x=2:n
        if (SM(x,1)<M)
            M=SM(x,1);
        end;
    end;    
    
    S=0;
    Cnt=0;
    for x=1:n
        if (SM(x,1)==M)
            S=S+SM(x,2);
            Cnt=Cnt+1;
        end;
    end;    

    F=S/Cnt;
elseif strcmp(Type,'Max_degree')==1
    M=SM(1,1);
    for x=2:n
        if (SM(x,1)>M)
            M=SM(x,1);
        end;
    end;    
    
    S=0;
    Cnt=0;
    for x=1:n
        if (SM(x,1)==M)
            S=S+SM(x,2);
            Cnt=Cnt+1;
        end;
    end;    

    F=S/Cnt;    
elseif strcmp(Type,'Weighted')==1
    S=0;
    for x=1:n
        S=S+(SM(x,1)*SM(x,2));
    end;
    
    F=S/n;    
else
    F=0;
end;
