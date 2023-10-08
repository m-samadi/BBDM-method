% Behavior-Based Decision Making (BBDM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [NumberOfSuccessfulJobs,NumberOfNonSuccessfulJobs] = BBDM(SimulationTime,ServiceProviders_Number,ServiceProviders_MaximumBufferSize,ServiceProviders_NumberOfCores,Customers_Number,MaximumNumberOfRequests,Requests_MaximumRequestedTime,RequestsGenerationRate)

addpath(genpath('BBDM_Functions'));

TotalInformation=zeros(SimulationTime,4); % Time | Number of requests | Number of successful jobs | Number of non successful jobs

ServiceProviders_Buffer=zeros(ServiceProviders_Number,ServiceProviders_MaximumBufferSize); % Request_ID
ServiceProviders_Buffer_Index=zeros(1,ServiceProviders_Number);
ServiceProviders=zeros(ServiceProviders_Number,3); % ServiceProvider_ID | Number of requests | Number of completed requests

Requests=zeros(MaximumNumberOfRequests,5); % Request_ID | Generation time | Requested time | Customer_ID | Is successful or unsuccessful (1=successful, 0=unsuccessful)

NumberOfRequests=0;
NumberOfSuccessfulJobs=0;
NumberOfNonSuccessfulJobs=0;

Phi_=2;
Alpha=0.05;
Beta=0.1;
Sigma=0.2;
Phi=0.8;
Omega=1-Phi;

D=[0.4 0.2 0.4]; % The desired set for determining the desired behavioral style

Decomposition_Importance_Method='Identical';
Decomposition_Belongingness_Method='Relativism';
BehavioralAggregation_Method='Fair';
Inference_Method='Impartial';
Composition_Method='Weighted';





%%%%% Construct behavioral matrixes of the service providers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Service Provider 1
% Style 1
BehavioralMatrix_SP1_B1(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.33;
v_s=0.2;
BehavioralMatrix_SP1_B1(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP1_B1(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.8;
BehavioralMatrix_SP1_B1(:,3)=BehavioralMatrix_SP1_B1(:,2)*Gamma;
% Style 2
BehavioralMatrix_SP1_B2(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.33;
v_s=0.3;
BehavioralMatrix_SP1_B2(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP1_B2(:,1),d_s,v_s,Alpha,Beta);
Gamma=1;
BehavioralMatrix_SP1_B2(:,3)=BehavioralMatrix_SP1_B2(:,2)*Gamma;
% Style 3
BehavioralMatrix_SP1_B3(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.34;
v_s=0.1;
BehavioralMatrix_SP1_B3(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP1_B3(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.2;
BehavioralMatrix_SP1_B3(:,3)=BehavioralMatrix_SP1_B3(:,2)*Gamma;

%%% Service Provider 2
% Style 1
BehavioralMatrix_SP2_B1(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.33;
v_s=1;
BehavioralMatrix_SP2_B1(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP2_B1(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.5;
BehavioralMatrix_SP2_B1(:,3)=BehavioralMatrix_SP2_B1(:,2)*Gamma;
% Style 2
BehavioralMatrix_SP2_B2(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.34;
v_s=0.9;
BehavioralMatrix_SP2_B2(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP2_B2(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.7;
BehavioralMatrix_SP2_B2(:,3)=BehavioralMatrix_SP2_B2(:,2)*Gamma;
% Style 3
BehavioralMatrix_SP2_B3(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.33;
v_s=0.2;
BehavioralMatrix_SP2_B3(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP2_B3(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.1;
BehavioralMatrix_SP2_B3(:,3)=BehavioralMatrix_SP2_B3(:,2)*Gamma;
% Style 4
BehavioralMatrix_SP2_B4(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.34;
v_s=0.9;
BehavioralMatrix_SP2_B4(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP2_B4(:,1),d_s,v_s,Alpha,Beta);
Gamma=1;
BehavioralMatrix_SP2_B4(:,3)=BehavioralMatrix_SP2_B4(:,2)*Gamma;
% Style 5
BehavioralMatrix_SP2_B5(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.33;
v_s=1;
BehavioralMatrix_SP2_B5(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP2_B5(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.9;
BehavioralMatrix_SP2_B5(:,3)=BehavioralMatrix_SP2_B5(:,2)*Gamma;

%%% Service Provider 3
% Style 1
BehavioralMatrix_SP3_B1(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.34;
v_s=0.1;
BehavioralMatrix_SP3_B1(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP3_B1(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.75;
BehavioralMatrix_SP3_B1(:,3)=BehavioralMatrix_SP3_B1(:,2)*Gamma;
% Style 2
BehavioralMatrix_SP3_B2(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.33;
v_s=1;
BehavioralMatrix_SP3_B2(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP3_B2(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.95;
BehavioralMatrix_SP3_B2(:,3)=BehavioralMatrix_SP3_B2(:,2)*Gamma;
% Style 3
BehavioralMatrix_SP3_B3(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.34;
v_s=0.9;
BehavioralMatrix_SP3_B3(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP3_B3(:,1),d_s,v_s,Alpha,Beta);
Gamma=1;
BehavioralMatrix_SP3_B3(:,3)=BehavioralMatrix_SP3_B3(:,2)*Gamma;
% Style 4
BehavioralMatrix_SP3_B4(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.33;
v_s=1;
BehavioralMatrix_SP3_B4(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP3_B4(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.5;
BehavioralMatrix_SP3_B4(:,3)=BehavioralMatrix_SP3_B4(:,2)*Gamma;

%%% Service Provider 4
% Style 1
BehavioralMatrix_SP4_B1(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.34;
v_s=0.9;
BehavioralMatrix_SP4_B1(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP4_B1(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.8;
BehavioralMatrix_SP4_B1(:,3)=BehavioralMatrix_SP4_B1(:,2)*Gamma;
% Style 2
BehavioralMatrix_SP4_B2(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.33;
v_s=1;
BehavioralMatrix_SP4_B2(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP4_B2(:,1),d_s,v_s,Alpha,Beta);
Gamma=0.7;
BehavioralMatrix_SP4_B2(:,3)=BehavioralMatrix_SP4_B2(:,2)*Gamma;

%%% Service Provider 5
% Style 1
BehavioralMatrix_SP5_B1(:,1)=Decomposition_Importance(Decomposition_Importance_Method,3,Phi_);
d_s=0.33;
v_s=0.3;
BehavioralMatrix_SP5_B1(:,2)=Decomposition_Belongingness(Decomposition_Belongingness_Method,3,BehavioralMatrix_SP5_B1(:,1),d_s,v_s,Alpha,Beta);
Gamma=1;
BehavioralMatrix_SP5_B1(:,3)=BehavioralMatrix_SP5_B1(:,2)*Gamma;





%%%%% Construct and update total matrixes of the service providers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Service Provider 1
TotalMatrix_SP1=[0 0 0;0 0 0;0 0 0];
TotalMatrix_SP1=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP1_B1,TotalMatrix_SP1,'Yes');
TotalMatrix_SP1=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP1_B2,TotalMatrix_SP1,'No');
TotalMatrix_SP1=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP1_B3,TotalMatrix_SP1,'No');

%%% Service Provider 2
TotalMatrix_SP2=[0 0 0;0 0 0;0 0 0];
TotalMatrix_SP2=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP2_B1,TotalMatrix_SP2,'Yes');
TotalMatrix_SP2=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP2_B2,TotalMatrix_SP2,'No');
TotalMatrix_SP2=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP2_B3,TotalMatrix_SP2,'No');
TotalMatrix_SP2=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP2_B4,TotalMatrix_SP2,'No');
TotalMatrix_SP2=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP2_B5,TotalMatrix_SP2,'No');

%%% Service Provider 3
TotalMatrix_SP3=[0 0 0;0 0 0;0 0 0];
TotalMatrix_SP3=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP3_B1,TotalMatrix_SP3,'Yes');
TotalMatrix_SP3=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP3_B2,TotalMatrix_SP3,'No');
TotalMatrix_SP3=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP3_B3,TotalMatrix_SP3,'No');
TotalMatrix_SP3=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP3_B4,TotalMatrix_SP3,'No');

%%% Service Provider 4
TotalMatrix_SP4=[0 0 0;0 0 0;0 0 0];
TotalMatrix_SP4=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP4_B1,TotalMatrix_SP4,'Yes');
TotalMatrix_SP4=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP4_B2,TotalMatrix_SP4,'No');

%%% Service Provider 5
TotalMatrix_SP5=[0 0 0;0 0 0;0 0 0];
TotalMatrix_SP5=BehavioralAggregation(BehavioralAggregation_Method,3,BehavioralMatrix_SP5_B1,TotalMatrix_SP5,'Yes');





%%%%% Print total matrixes of the service providers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TotalMatrix_SP1
TotalMatrix_SP2
TotalMatrix_SP3
TotalMatrix_SP4
TotalMatrix_SP5





%%%%% Cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Behavior-Based Decision Making (BBDM)');

Time=1;
while Time<=SimulationTime
    %%% Generate requests  
    if (length(strfind(RequestsGenerationRate,Time))>0)&&(NumberOfRequests<MaximumNumberOfRequests)
        % Select a customer
        Customer_ID=round(rand(1)*Customers_Number);
        if Customer_ID==0
            Customer_ID=1;
        end;
        
        NumberOfRequests=NumberOfRequests+1;
        Requests(NumberOfRequests,1)=NumberOfRequests;
        Requests(NumberOfRequests,2)=Time;
        Requests(NumberOfRequests,3)=round(rand(1)*Requests_MaximumRequestedTime);
        Requests(NumberOfRequests,4)=Customer_ID;
        
        % Select an appropriate service provider
        ServiceProvider=zeros(ServiceProviders_Number,2); % ServiceProvider_ID | Success probability 
        ServiceProvider_Index=0;
        for i=1:ServiceProviders_Number 
            if ServiceProviders_MaximumBufferSize>0
                Percent=ServiceProviders_Buffer_Index(1,i)/ServiceProviders_MaximumBufferSize*100;
            else
                Percent=0;
            end; 
            
            if Percent<50
                ServiceProvider_Index=ServiceProvider_Index+1;
                
                if (i==1)                
                    SuccessSet=Inference(Inference_Method,3,TotalMatrix_SP1,D,Sigma,Phi,Omega);
                    ServiceProvider(ServiceProvider_Index,1)=1;
                elseif (i==2)
                    SuccessSet=Inference(Inference_Method,3,TotalMatrix_SP2,D,Sigma,Phi,Omega);
                    ServiceProvider(ServiceProvider_Index,1)=2;
                elseif (i==3)
                    SuccessSet=Inference(Inference_Method,3,TotalMatrix_SP3,D,Sigma,Phi,Omega);
                    ServiceProvider(ServiceProvider_Index,1)=3;
                elseif (i==4)
                    SuccessSet=Inference(Inference_Method,3,TotalMatrix_SP4,D,Sigma,Phi,Omega);
                    ServiceProvider(ServiceProvider_Index,1)=4;
                else
                    SuccessSet=Inference(Inference_Method,3,TotalMatrix_SP5,D,Sigma,Phi,Omega);
                    ServiceProvider(ServiceProvider_Index,1)=5;
                end;

                ServiceProvider(ServiceProvider_Index,2)=Composition(Composition_Method,3,SuccessSet);                
            end;
        end;
        
        % Sort ServiceProvider
        ServiceProvider=ServiceProvider(1:ServiceProvider_Index,:);
        ServiceProvider=sortrows(ServiceProvider,2);
        
        if ServiceProvider_Index>0
            SelectedServiceProvider_ID=ServiceProvider(ServiceProvider_Index,1);

            % To service the request by the selected service provider
            if ServiceProviders_Buffer_Index(1,SelectedServiceProvider_ID)<ServiceProviders_MaximumBufferSize
                ServiceProviders_Buffer_Index(1,SelectedServiceProvider_ID)=ServiceProviders_Buffer_Index(1,SelectedServiceProvider_ID)+1;            
                ServiceProviders_Buffer(SelectedServiceProvider_ID,ServiceProviders_Buffer_Index(1,SelectedServiceProvider_ID))=NumberOfRequests;

                Requests(NumberOfRequests,5)=1;

                ServiceProviders(SelectedServiceProvider_ID,2)=ServiceProviders(SelectedServiceProvider_ID,2)+1;

                NumberOfSuccessfulJobs=NumberOfSuccessfulJobs+1;
            else
                Requests(NumberOfRequests,5)=0;

                NumberOfNonSuccessfulJobs=NumberOfNonSuccessfulJobs+1;
            end;
        else
            Requests(NumberOfRequests,5)=0;

            NumberOfNonSuccessfulJobs=NumberOfNonSuccessfulJobs+1;            
        end;
        
        % Update the total matrix of the selected service provider
        if (SelectedServiceProvider_ID==1)
            SuccessSet=Inference(Inference_Method,3,TotalMatrix_SP1,D,Sigma,Phi,Omega);
            
            SuccessSet(1,3)=SuccessSet(1,2);
            SuccessSet(2,3)=SuccessSet(2,2);
            SuccessSet(3,3)=SuccessSet(3,2); 
            
            TotalMatrix_SP1=BehavioralAggregation(BehavioralAggregation_Method,3,SuccessSet,TotalMatrix_SP1,'No');
        elseif (SelectedServiceProvider_ID==2)
            SuccessSet=Inference(Inference_Method,3,TotalMatrix_SP2,D,Sigma,Phi,Omega);
            
            SuccessSet(1,3)=SuccessSet(1,2);
            SuccessSet(2,3)=SuccessSet(2,2);
            SuccessSet(3,3)=SuccessSet(3,2);
            
            TotalMatrix_SP2=BehavioralAggregation(BehavioralAggregation_Method,3,SuccessSet,TotalMatrix_SP2,'No');
        elseif (SelectedServiceProvider_ID==3)
            SuccessSet=Inference(Inference_Method,3,TotalMatrix_SP3,D,Sigma,Phi,Omega);
            
            SuccessSet(1,3)=SuccessSet(1,2);
            SuccessSet(2,3)=SuccessSet(2,2);
            SuccessSet(3,3)=SuccessSet(3,2);  
            
            TotalMatrix_SP3=BehavioralAggregation(BehavioralAggregation_Method,3,SuccessSet,TotalMatrix_SP3,'No');
        elseif (SelectedServiceProvider_ID==4)
            SuccessSet=Inference(Inference_Method,3,TotalMatrix_SP4,D,Sigma,Phi,Omega);
            
            SuccessSet(1,3)=SuccessSet(1,2);
            SuccessSet(2,3)=SuccessSet(2,2);
            SuccessSet(3,3)=SuccessSet(3,2);  
            
            TotalMatrix_SP4=BehavioralAggregation(BehavioralAggregation_Method,3,SuccessSet,TotalMatrix_SP4,'No');
        else
            SuccessSet=Inference(Inference_Method,3,TotalMatrix_SP5,D,Sigma,Phi,Omega);
            
            SuccessSet(1,3)=SuccessSet(1,2);
            SuccessSet(2,3)=SuccessSet(2,2);
            SuccessSet(3,3)=SuccessSet(3,2); 
            
            TotalMatrix_SP5=BehavioralAggregation(BehavioralAggregation_Method,3,SuccessSet,TotalMatrix_SP5,'No');
        end;          
    end;
    
    %%% Finish services
    for i=1:ServiceProviders_Number
        for j=1:ServiceProviders_Buffer_Index(1,i)
            Request_ID=ServiceProviders_Buffer(i,j);
            
            if ((Time-Requests(Request_ID,2))*ServiceProviders_NumberOfCores(i,2))>=Requests(Request_ID,3)
                for k=j:(ServiceProviders_Buffer_Index(1,i)-1)
                    ServiceProviders_Buffer(i,k)=ServiceProviders_Buffer(i,k+1);
                end;
                ServiceProviders_Buffer_Index(1,i)=ServiceProviders_Buffer_Index(1,i)-1;
                
                ServiceProviders(i,3)=ServiceProviders(i,3)+1;
            end;
        end;
    end;
    
    %%% Update TotalInformation
    TotalInformation(Time,1)=Time;
    TotalInformation(Time,2)=NumberOfRequests;
    TotalInformation(Time,3)=NumberOfSuccessfulJobs;
    TotalInformation(Time,4)=NumberOfNonSuccessfulJobs;
    
    %%% Display and increase Time
    Time
    Time=Time+1;      
end;

NumberOfSuccessfulJobs=TotalInformation(:,3);
NumberOfNonSuccessfulJobs=TotalInformation(:,4);
