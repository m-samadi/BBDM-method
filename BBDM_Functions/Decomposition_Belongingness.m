% Decomposition_Belongingness
%///// Create belongingness factors using a belongingness function
%// If Type=='Inverse' then decomposition unit uses inverse belongingness function
%// If Type=='Relativism' then decomposition unit uses relativism belongingness function
%// n is the number of features
%// d is the degrees of the features
%// d_s is the degree of the sensible feature
%// v_s is the value of the sensible feature
%// Alpha is the relative effectiveness factor that takes a value in the range of [0, 0.1]
%// Beta is the relative effectiveness factor that takes a value in the range of [0, 0.2]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [F] = Decomposition_Belongingness(Type,n,d,d_s,v_s,Alpha,Beta)
if strcmp(Type,'Inverse')==1 
    for x=1:n
        if ((v_s*d(x)/d_s)>1)            
            F(x)=abs(1-(abs(d_s-d(x))/(v_s*d(x))));
        elseif ((v_s*d(x)/d_s)>0.1)&&((v_s*d(x)/d_s)<=1)
            F(x)=abs(((v_s*d(x))/d_s)-(Alpha*abs(d_s-d(x))));
        elseif ((v_s*d(x)/d_s)<=0.1)
            F(x)=1-((v_s*d(x))/d_s);
        end;
        %
        if (F(x)>1)
            F(x)=1;
        end;
    end;    
elseif strcmp(Type,'Relativism')==1
    for x=1:n
        if (v_s>0.8)&&(d(x)>d_s)
            F(x)=1;
        else
            F(x)=abs(v_s-Beta*(d_s-d(x)));
        end;
    end;    
else
    for x=1:n
        F(x)=0;
    end;
end;