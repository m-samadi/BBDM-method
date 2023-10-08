% Fuzzy Logic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [NumberOfSuccessfulJobs,NumberOfNonSuccessfulJobs] = FuzzyLogic(SimulationTime,ServiceProviders_Number,ServiceProviders_MaximumBufferSize,ServiceProviders_MinimumCore,ServiceProviders_MaximumCore,ServiceProviders_NumberOfCores,Customers_Number,MaximumNumberOfRequests,Requests_MaximumRequestedTime,RequestsGenerationRate)

addpath(genpath('FuzzyLogic_Functions'));

TotalInformation=zeros(SimulationTime,4); % Time | Number of requests | Number of successful jobs | Number of non successful jobs

ServiceProviders_Buffer=zeros(ServiceProviders_Number,ServiceProviders_MaximumBufferSize); % Request_ID
ServiceProviders_Buffer_Index=zeros(1,ServiceProviders_Number);
ServiceProviders=zeros(ServiceProviders_Number,3); % ServiceProvider_ID | Number of requests | Number of completed requests

Requests=zeros(MaximumNumberOfRequests,5); % Request_ID | Generation time | Requested time | Customer_ID | Is successful or unsuccessful (1=successful, 0=unsuccessful)

NumberOfRequests=0;
NumberOfSuccessfulJobs=0;
NumberOfNonSuccessfulJobs=0;

NumberOfCores_ShapeFactor=5;
OccupiedBuffer_ShapeFactor=100;
ServiceRate_ShapeFactor=1;
SuccessProbability_ShapeFactor=100;

NumberOfCores_Type='i';
OccupiedBuffer_Type='b';
ServiceRate_Type='b';
SuccessProbability_Type='b';





%%%%% Membership functions of the fuzzy controller
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Number of cores
NumberOfCores_UniversalSet=[1 2 3 5 6];
% Few
Crisp=1;
NumberOfCores_Few=fuzzifysn(NumberOfCores_UniversalSet,Crisp,NumberOfCores_Type,NumberOfCores_ShapeFactor);
% Mediocre
Crisp=3;
NumberOfCores_Mediocre=fuzzifysn(NumberOfCores_UniversalSet,Crisp,NumberOfCores_Type,NumberOfCores_ShapeFactor);
% Many
Crisp=6;
NumberOfCores_Many=fuzzifysn(NumberOfCores_UniversalSet,Crisp,NumberOfCores_Type,NumberOfCores_ShapeFactor);

%%% Occupied buffer
OccupiedBuffer_UniversalSet=[0 25 50 75 100];
% Empty
Crisp=0;
OccupiedBuffer_Empty=fuzzifysn(OccupiedBuffer_UniversalSet,Crisp,OccupiedBuffer_Type,OccupiedBuffer_ShapeFactor);
% Partial
Crisp=50;
OccupiedBuffer_Partial=fuzzifysn(OccupiedBuffer_UniversalSet,Crisp,OccupiedBuffer_Type,OccupiedBuffer_ShapeFactor);
% Full
Crisp=100;
OccupiedBuffer_Full=fuzzifysn(OccupiedBuffer_UniversalSet,Crisp,OccupiedBuffer_Type,OccupiedBuffer_ShapeFactor);

%%% Service rate
ServiceRate_UniversalSet=[0 0.25 0.5 0.75 1];
% Low
Crisp=0;
ServiceRate_Low=fuzzifysn(ServiceRate_UniversalSet,Crisp,ServiceRate_Type,ServiceRate_ShapeFactor);
% Medium
Crisp=0.5;
ServiceRate_Medium=fuzzifysn(ServiceRate_UniversalSet,Crisp,ServiceRate_Type,ServiceRate_ShapeFactor);
% High
Crisp=1;
ServiceRate_High=fuzzifysn(ServiceRate_UniversalSet,Crisp,ServiceRate_Type,ServiceRate_ShapeFactor);

%%% Success probability
SuccessProbability_UniversalSet=[0 25 50 75 100];
% Unsuccessful
Crisp=0;
SuccessProbability_Unsuccessful=fuzzifysn(SuccessProbability_UniversalSet,Crisp,SuccessProbability_Type,SuccessProbability_ShapeFactor);
% Moderate
Crisp=50;
SuccessProbability_Moderate=fuzzifysn(SuccessProbability_UniversalSet,Crisp,SuccessProbability_Type,SuccessProbability_ShapeFactor);
% Successful
Crisp=100;
SuccessProbability_Successful=fuzzifysn(SuccessProbability_UniversalSet,Crisp,SuccessProbability_Type,SuccessProbability_ShapeFactor);





%%%%% Fuzzy rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rule 1
mu_ABC=fuzzyand(NumberOfCores_Few,OccupiedBuffer_Empty,ServiceRate_Low);
R1=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 2
mu_ABC=fuzzyand(NumberOfCores_Few,OccupiedBuffer_Empty,ServiceRate_Medium);
R2=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 3
mu_ABC=fuzzyand(NumberOfCores_Few,OccupiedBuffer_Empty,ServiceRate_High);
R3=rulemakem(mu_ABC,SuccessProbability_Successful);
% Rule 4
mu_ABC=fuzzyand(NumberOfCores_Few,OccupiedBuffer_Partial,ServiceRate_Low);
R4=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 5
mu_ABC=fuzzyand(NumberOfCores_Few,OccupiedBuffer_Partial,ServiceRate_Medium);
R5=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 6
mu_ABC=fuzzyand(NumberOfCores_Few,OccupiedBuffer_Partial,ServiceRate_High);
R6=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 7
mu_ABC=fuzzyand(NumberOfCores_Few,OccupiedBuffer_Full,ServiceRate_Low);
R7=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 8
mu_ABC=fuzzyand(NumberOfCores_Few,OccupiedBuffer_Full,ServiceRate_Medium);
R8=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 9
mu_ABC=fuzzyand(NumberOfCores_Few,OccupiedBuffer_Full,ServiceRate_High);
R9=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 10
mu_ABC=fuzzyand(NumberOfCores_Mediocre,OccupiedBuffer_Empty,ServiceRate_Low);
R10=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 11
mu_ABC=fuzzyand(NumberOfCores_Mediocre,OccupiedBuffer_Empty,ServiceRate_Medium);
R11=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 12
mu_ABC=fuzzyand(NumberOfCores_Mediocre,OccupiedBuffer_Empty,ServiceRate_High);
R12=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 13
mu_ABC=fuzzyand(NumberOfCores_Mediocre,OccupiedBuffer_Partial,ServiceRate_Low);
R13=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 14
mu_ABC=fuzzyand(NumberOfCores_Mediocre,OccupiedBuffer_Partial,ServiceRate_Medium);
R14=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 15
mu_ABC=fuzzyand(NumberOfCores_Mediocre,OccupiedBuffer_Partial,ServiceRate_High);
R15=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 16
mu_ABC=fuzzyand(NumberOfCores_Mediocre,OccupiedBuffer_Full,ServiceRate_Low);
R16=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 17
mu_ABC=fuzzyand(NumberOfCores_Mediocre,OccupiedBuffer_Full,ServiceRate_Medium);
R17=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 18
mu_ABC=fuzzyand(NumberOfCores_Mediocre,OccupiedBuffer_Full,ServiceRate_High);
R18=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 19
mu_ABC=fuzzyand(NumberOfCores_Many,OccupiedBuffer_Empty,ServiceRate_Low);
R19=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 20
mu_ABC=fuzzyand(NumberOfCores_Many,OccupiedBuffer_Empty,ServiceRate_Medium);
R20=rulemakem(mu_ABC,SuccessProbability_Successful);
% Rule 21
mu_ABC=fuzzyand(NumberOfCores_Many,OccupiedBuffer_Empty,ServiceRate_High);
R21=rulemakem(mu_ABC,SuccessProbability_Successful);
% Rule 22
mu_ABC=fuzzyand(NumberOfCores_Many,OccupiedBuffer_Partial,ServiceRate_Low);
R22=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 23
mu_ABC=fuzzyand(NumberOfCores_Many,OccupiedBuffer_Partial,ServiceRate_Medium);
R23=rulemakem(mu_ABC,SuccessProbability_Moderate);
% Rule 24
mu_ABC=fuzzyand(NumberOfCores_Many,OccupiedBuffer_Partial,ServiceRate_High);
R24=rulemakem(mu_ABC,SuccessProbability_Successful);
% Rule 25
mu_ABC=fuzzyand(NumberOfCores_Many,OccupiedBuffer_Full,ServiceRate_Low);
R25=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 26
mu_ABC=fuzzyand(NumberOfCores_Many,OccupiedBuffer_Full,ServiceRate_Medium);
R26=rulemakem(mu_ABC,SuccessProbability_Unsuccessful);
% Rule 27
mu_ABC=fuzzyand(NumberOfCores_Many,OccupiedBuffer_Full,ServiceRate_High);
R27=rulemakem(mu_ABC,SuccessProbability_Moderate);

%%% Aggregation of rules 
R=totalrule(R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15,R16,R17,R18,R19,R20,R21,R22,R23,R24,R25,R26,R27);





%%%%% Cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Fuzzy Logic');

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
        for i=1:ServiceProviders_Number
            ServiceProvider(i,1)=i;
            
            % Number of cores
            if (ServiceProviders_NumberOfCores(i,2)<=6)                
                Crisp=ServiceProviders_NumberOfCores(i,2);
            else
                Crisp=6;
            end;
            NumberOfCores=fuzzifysn(NumberOfCores_UniversalSet,Crisp,NumberOfCores_Type,NumberOfCores_ShapeFactor);
            
            % Occupied buffer
            if ServiceProviders_MaximumBufferSize>0
                Crisp=ServiceProviders_Buffer_Index(1,i)/ServiceProviders_MaximumBufferSize*100;
            else
                Crisp=0;
            end;                
            OccupiedBuffer=fuzzifysn(OccupiedBuffer_UniversalSet,Crisp,OccupiedBuffer_Type,OccupiedBuffer_ShapeFactor);
            
            % Service rate
            Crisp=ServiceProviders(i,3)/ServiceProviders(i,2);
            ServiceRate=fuzzifysn(ServiceRate_UniversalSet,Crisp,ServiceRate_Type,ServiceRate_ShapeFactor);
            
            % Success probability
            SuccessProbability_Fuzzy=ruleresp(R,fuzzyand(NumberOfCores,OccupiedBuffer,ServiceRate));
            SuccessProbability=defuzzyg(SuccessProbability_UniversalSet,SuccessProbability_Fuzzy);

            ServiceProvider(i,2)=SuccessProbability;
        end;
        
        % Sort ServiceProvider
        ServiceProvider=sortrows(ServiceProvider,2);
        SelectedServiceProvider_ID=ServiceProvider(ServiceProviders_Number,1);
        
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
