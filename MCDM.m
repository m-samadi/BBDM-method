% Multi-Criteria Decision Making (MCDM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [NumberOfSuccessfulJobs,NumberOfNonSuccessfulJobs] = MCDM(SimulationTime,ServiceProviders_Number,ServiceProviders_MaximumBufferSize,ServiceProviders_NumberOfCores,Customers_Number,MaximumNumberOfRequests,Requests_MaximumRequestedTime,RequestsGenerationRate)

TotalInformation=zeros(SimulationTime,4); % Time | Number of requests | Number of successful jobs | Number of non successful jobs

ServiceProviders_Buffer=zeros(ServiceProviders_Number,ServiceProviders_MaximumBufferSize); % Request_ID
ServiceProviders_Buffer_Index=zeros(1,ServiceProviders_Number);
ServiceProviders=zeros(ServiceProviders_Number,3); % ServiceProvider_ID | Number of requests | Number of completed requests

Requests=zeros(MaximumNumberOfRequests,5); % Request_ID | Generation time | Requested time | Customer_ID | Is successful or unsuccessful (1=successful, 0=unsuccessful)

NumberOfRequests=0;
NumberOfSuccessfulJobs=0;
NumberOfNonSuccessfulJobs=0;





%%%%% Cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Multi-Criteria Decision Making (MCDM)');

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
            if (ServiceProviders_NumberOfCores(i,2)>=1)&&(ServiceProviders_NumberOfCores(i,2)<2)
                NumberOfCores='Few';
            elseif (ServiceProviders_NumberOfCores(i,2)>=2)&&(ServiceProviders_NumberOfCores(i,2)<4)
                NumberOfCores='Mediocre';
            else
                NumberOfCores='Many';
            end;
            
            % Occupied buffer
            if ServiceProviders_MaximumBufferSize>0
                OccupiedBufferRate=ServiceProviders_Buffer_Index(1,i)/ServiceProviders_MaximumBufferSize*100;
            else
                OccupiedBufferRate=0;
            end;
                
            if (OccupiedBufferRate>=0)&&(OccupiedBufferRate<33)
                OccupiedBuffer='Empty';
            elseif (OccupiedBufferRate>=33)&&(OccupiedBufferRate<66)
                OccupiedBuffer='Partial';
            else
                OccupiedBuffer='Full';
            end;
            
            % Service rate
            ServiceRate_Amount=ServiceProviders(i,3)/ServiceProviders(i,2);
            if (ServiceRate_Amount>=0)&&(ServiceRate_Amount<0.3)
                ServiceRate='Low';
            elseif (ServiceRate_Amount>=0.3)&&(ServiceRate_Amount<0.6)
                ServiceRate='Medium';
            else
                ServiceRate='High';
            end;
            
            % Success probability
            if (strcmp(NumberOfCores,'Few')==1)&&(strcmp(OccupiedBuffer,'Empty')==1)&&(strcmp(ServiceRate,'Low')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Few')==1)&&(strcmp(OccupiedBuffer,'Empty')==1)&&(strcmp(ServiceRate,'Medium')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Few')==1)&&(strcmp(OccupiedBuffer,'Empty')==1)&&(strcmp(ServiceRate,'High')==1)
                SuccessProbability='Successful';
            elseif (strcmp(NumberOfCores,'Few')==1)&&(strcmp(OccupiedBuffer,'Partial')==1)&&(strcmp(ServiceRate,'Low')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Few')==1)&&(strcmp(OccupiedBuffer,'Partial')==1)&&(strcmp(ServiceRate,'Medium')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Few')==1)&&(strcmp(OccupiedBuffer,'Partial')==1)&&(strcmp(ServiceRate,'High')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Few')==1)&&(strcmp(OccupiedBuffer,'Full')==1)&&(strcmp(ServiceRate,'Low')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Few')==1)&&(strcmp(OccupiedBuffer,'Full')==1)&&(strcmp(ServiceRate,'Medium')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Few')==1)&&(strcmp(OccupiedBuffer,'Full')==1)&&(strcmp(ServiceRate,'High')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Mediocre')==1)&&(strcmp(OccupiedBuffer,'Empty')==1)&&(strcmp(ServiceRate,'Low')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Mediocre')==1)&&(strcmp(OccupiedBuffer,'Empty')==1)&&(strcmp(ServiceRate,'Medium')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Mediocre')==1)&&(strcmp(OccupiedBuffer,'Empty')==1)&&(strcmp(ServiceRate,'High')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Mediocre')==1)&&(strcmp(OccupiedBuffer,'Partial')==1)&&(strcmp(ServiceRate,'Low')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Mediocre')==1)&&(strcmp(OccupiedBuffer,'Partial')==1)&&(strcmp(ServiceRate,'Medium')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Mediocre')==1)&&(strcmp(OccupiedBuffer,'Partial')==1)&&(strcmp(ServiceRate,'High')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Mediocre')==1)&&(strcmp(OccupiedBuffer,'Full')==1)&&(strcmp(ServiceRate,'Low')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Mediocre')==1)&&(strcmp(OccupiedBuffer,'Full')==1)&&(strcmp(ServiceRate,'Medium')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Mediocre')==1)&&(strcmp(OccupiedBuffer,'Full')==1)&&(strcmp(ServiceRate,'High')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Many')==1)&&(strcmp(OccupiedBuffer,'Empty')==1)&&(strcmp(ServiceRate,'Low')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Many')==1)&&(strcmp(OccupiedBuffer,'Empty')==1)&&(strcmp(ServiceRate,'Medium')==1)
                SuccessProbability='Successful';
            elseif (strcmp(NumberOfCores,'Many')==1)&&(strcmp(OccupiedBuffer,'Empty')==1)&&(strcmp(ServiceRate,'High')==1)
                SuccessProbability='Successful';
            elseif (strcmp(NumberOfCores,'Many')==1)&&(strcmp(OccupiedBuffer,'Partial')==1)&&(strcmp(ServiceRate,'Low')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Many')==1)&&(strcmp(OccupiedBuffer,'Partial')==1)&&(strcmp(ServiceRate,'Medium')==1)
                SuccessProbability='Moderate';
            elseif (strcmp(NumberOfCores,'Many')==1)&&(strcmp(OccupiedBuffer,'Partial')==1)&&(strcmp(ServiceRate,'High')==1)
                SuccessProbability='Successful';
            elseif (strcmp(NumberOfCores,'Many')==1)&&(strcmp(OccupiedBuffer,'Full')==1)&&(strcmp(ServiceRate,'Low')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Many')==1)&&(strcmp(OccupiedBuffer,'Full')==1)&&(strcmp(ServiceRate,'Medium')==1)
                SuccessProbability='Unsuccessful';
            elseif (strcmp(NumberOfCores,'Many')==1)&&(strcmp(OccupiedBuffer,'Full')==1)&&(strcmp(ServiceRate,'High')==1)
                SuccessProbability='Moderate';
            end;
            
            if strcmp(SuccessProbability,'Unsuccessful')==1
                ServiceProvider(i,2)=1;
            elseif strcmp(SuccessProbability,'Moderate')==1
                ServiceProvider(i,2)=2;
            elseif strcmp(SuccessProbability,'Successful')==1
                ServiceProvider(i,2)=3;
            end;
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
