% Comparison analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%% Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SimulationTime=3600; % Simulation time (Second)

ServiceProviders_MaximumBufferSize=5;
ServiceProviders_Number=5; % Number of service providers
ServiceProviders_MinimumCore=1;
ServiceProviders_MaximumCore=6;
ServiceProviders_NumberOfCores=zeros(ServiceProviders_Number,2); % ServiceProvider_ID | Number of cores

Customers_Number=10; % Number of customers

Requests_MaximumRequestedTime=100; % Maximum requested time for requests of customers (Second)





%%%%% Initialize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% ServiceProviders_CoreCount
for i=1:ServiceProviders_Number
    ServiceProviders_NumberOfCores(i,1)=i;
    ServiceProviders_NumberOfCores(i,2)=ServiceProviders_MinimumCore+round(rand(1)*(ServiceProviders_MaximumCore-ServiceProviders_MinimumCore));
end;

%%% Exponential distribution to generate requests
Mu=0.3;
MaximumNumberOfRequests=10000; % Maximum number of requests
RequestsGenerationRate=round(random('Exponential',Mu,1,MaximumNumberOfRequests)*SimulationTime);





%%%%% Simulation process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call Multi-Criteria Decision Making (MCDM)
[MCDM_NumberOfSuccessfulJobs MCDM_NumberOfNonSuccessfulJobs]=MCDM(SimulationTime,ServiceProviders_Number,ServiceProviders_MaximumBufferSize,ServiceProviders_NumberOfCores,Customers_Number,MaximumNumberOfRequests,Requests_MaximumRequestedTime,RequestsGenerationRate);
% Call Fuzzy Logic
[FuzzyLogic_NumberOfSuccessfulJobs FuzzyLogic_NumberOfNonSuccessfulJobs]=FuzzyLogic(SimulationTime,ServiceProviders_Number,ServiceProviders_MaximumBufferSize,ServiceProviders_MinimumCore,ServiceProviders_MaximumCore,ServiceProviders_NumberOfCores,Customers_Number,MaximumNumberOfRequests,Requests_MaximumRequestedTime,RequestsGenerationRate);
% Call Behavior-Based Decision Making (BBDM)
[BBDM_NumberOfSuccessfulJobs BBDM_NumberOfNonSuccessfulJobs]=BBDM(SimulationTime,ServiceProviders_Number,ServiceProviders_MaximumBufferSize,ServiceProviders_NumberOfCores,Customers_Number,MaximumNumberOfRequests,Requests_MaximumRequestedTime,RequestsGenerationRate);





%%%%% Comparison outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of Successful Jobs
figure(1);
hold on;
plot(1:SimulationTime,MCDM_NumberOfSuccessfulJobs,':r','LineWidth',1.5);
plot(1:SimulationTime,FuzzyLogic_NumberOfSuccessfulJobs,'-.b','LineWidth',1.5);
plot(1:SimulationTime,BBDM_NumberOfSuccessfulJobs,'k','LineWidth',1.5);
xlabel('Simulation Time (Second)');
xlim([1 3600]);
set(gca,'XTick',[1 600 1200 1800 2400 3000 3600]);
ylabel('Number of Successful Jobs');
legend('MCDM','Fuzzy Logic','BBDM',2);
hold off;

% Number of Non Successful Jobs
figure(2);
hold on;
plot(1:SimulationTime,MCDM_NumberOfNonSuccessfulJobs,':r','LineWidth',1.5);
plot(1:SimulationTime,FuzzyLogic_NumberOfNonSuccessfulJobs,'-.b','LineWidth',1.5);
plot(1:SimulationTime,BBDM_NumberOfNonSuccessfulJobs,'k','LineWidth',1.5);
xlabel('Simulation Time (Second)');
xlim([1 3600]);
set(gca,'XTick',[1 600 1200 1800 2400 3000 3600]);
ylabel('Number of Non Successful Jobs');
legend('MCDM','Fuzzy Logic','BBDM',2);
hold off;
