% Inference
%///// Determine attributes 'degree' and 'value' of the confidence matrix
%// If Type=='Straight' then inference unit uses straight inference
%// If Type=='Relative' then inference unit uses relative inference
%// If Type=='Impartial' then inference unit uses impartial inference
%// n is the number of features
%// T is the total matrix
%// D is the desired set
%// Sigma is a difference amount
%// Phi is the impact rate of attribute 'truth'
%// Omega is the impact rate of attribute 'growth'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [F] = Inference(Type,n,T,D,Sigma,Phi,Omega)
if strcmp(Type,'Straight')==1     
    for x=1:n
        F(x,1)=D(x);
        
        if (D(x)<=T(x,1))
            F(x,2)=Phi*abs(T(x,2)-Sigma)+(Omega*T(x,3));
        else
            F(x,2)=Phi*(T(x,2)+Sigma)+(Omega*T(x,3));
        end;
    end;      
elseif strcmp(Type,'Relative')==1
    for x=1:n    
        F(x,1)=D(x);
        
        if (D(x)<=T(x,1))
            F(x,2)=Phi*((D(x)*T(x,2))/T(x,1))+Omega*(T(x,3));
        elseif (D(x)>T(x,1))&&(T(x,2)<=0.5)
            F(x,2)=Phi*((D(x)*T(x,2))/T(x,1)+T(x,2))+Omega*(T(x,3));
        elseif (D(x)>T(x,1))&&(T(x,2)>0.5)
            F(x,2)=1;
        end; 
    end;         
elseif strcmp(Type,'Impartial')==1
    Sum1=0;
    for y=1:n 
        Sum1=Sum1+(T(y,1)*T(y,2));
    end;
    
    Sum2=0;
    for y=1:n 
        Sum2=Sum2+(T(y,1)*T(y,3));
    end;    
    
    for x=1:n    
        F(x,1)=D(x);
        
        if (D(x)<=T(x,1))
            F(x,2)=Phi*(D(x)*T(x,2)/Sum1)+Omega*(D(x)*T(x,3)/Sum2);
        else
            F(x,2)=min((Phi*(D(x)*T(x,2)/Sum1)+Omega*(D(x)*T(x,3)/Sum2)),1);
        end; 
    end;         
else
    for x=1:n
        F(x,1)=D(x);
        F(x,2)=0;
    end;     
end; 
