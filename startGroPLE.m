clear
addpath(genpath('.'));
datasets = [{'datasets/medicalPartition'};       {'datasets/genbasePartition'};     {'datasets/CAL500Partition'};...
            {'datasets/bibtexPartition'};        {'datasets/rcv1-sample1Partition'};{'datasets/rcv1-sample2Partition'};...
            {'datasets/rcv1-sample3Partition'};  {'datasets/corel5kPartition'};     {'datasets/corel16k-sample1Partition'};...
            {'datasets/deliciousPartition'};     {'datasets/mediamillPartition'};   {'datasets/bookmarksPartition'}];
%% Data set Selection
datasetNo = 1;                  filename1 = datasets{datasetNo};
load(filename1);                ttlRun = size(partitionFiveFold,2);

%% %%%%%%%%%%%%%%%%%%% FIXED PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
candidateAlpha = 10.^(-4:4);        candidateBeta = 10.^(-4:4);    %%
candidateGamma = 10.^(-2:2);        candidateLambda1 = 10.^(-3:2); %%
candidateLambda2 = 10.^(-3:2);      k           = 100; %D in paper %%        
tol = 0.5;                          nGroups     = 10;  %K in paper %%
maxiter = 500;                      gpMaxiter   = 100;             %%
closedFormFun = @groupAPG1;                                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%% DATASET DEPENDENT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%
lambda1No = 1; lambda2No = 4;                                      %%
alphaBetaGammaGroPLE = [1,5,1; 4,1,1; 9,9,1;                       %%
                        8,1,1; 7,1,1; 7,1,1;                       %%
                        7,4,1; 8,1,1; 9,6,1;                       %%
                        7,3,1; 9,4,1; 9,1,1];                      %%
alphaNo = alphaBetaGammaGroPLE(datasetNo,1);                       %%
betaNo  = alphaBetaGammaGroPLE(datasetNo,2);                       %%
gammaNo = alphaBetaGammaGroPLE(datasetNo,3);                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% results
ResultApproxYGroPLE     =  zeros(15,ttlRun);
ResultGroPLE            =  zeros(15,ttlRun);
AvgResultApproxYGroPLE  =  zeros(15,2);
AvgResultGroPLE         = zeros(15,2);
%%
for runNo=1:ttlRun
    data = partitionFiveFold{runNo};
    X = data.X; Y = data.Y; Xt = data.Xt; Yt = data.Yt;
    Y(Y==0) = -1;    Yt(Yt==0) = -1;
    idx = sum(Y==1,1)<1;
    Y(:,idx) = [];    Yt(:,idx) = [];
    
    
    par           = struct;                         par.maxiter = maxiter;
    par.gpMaxiter = gpMaxiter;                      par.nGroups = nGroups;
    par.tol       = tol;                            par.minimumLossMargin = 0.001;
    par.k         = k;                              par.bQuiet = 1;
    par.prox_l21  = @prox_l21;                      par.norm_l21  = @norm_l21;
    
    par.lambda1   = candidateLambda1(lambda1No);    
    par.lambda2   = candidateLambda2(lambda2No);
    par.gamma     = candidateGamma(gammaNo);        
    

    [n,L] = size(Y);
    Wini = rand(n,k);       Hini = rand(par.k,L);
    Wini = bsxfun(@rdivide, Wini, sqrt(sum(Wini.^2, 2)));
    
    if nGroups > 1
        [tmpLabelIdx,~] = spectralClustering(X, Y',1,0,nGroups);
    else
        tmpLabelIdx = ones(1,L);
    end
    
    par.tmpLabelIdx = tmpLabelIdx;
    
    [W,H, ~] = closedFormFun(X,Y,Wini, Hini, par);
     
    optmParameter                   = struct;   optmParameter.maxiter = maxiter;
    optmParameter.minimumLossMargin = 0.0001;   optmParameter.bQuiet  = 1;
    
    optmParameter.alpha             = candidateAlpha(alphaNo);
    optmParameter.beta              = candidateBeta(betaNo);
    optmParameter.gamma             = candidateGamma(gammaNo);
    
    Z = LLSF( full(X), W, optmParameter);
    prdtnYt = (Xt*Z*H)';
    ResultGroPLE(:,runNo) = EvaluationAll(sign(prdtnYt),Yt',prdtnYt)';    
    ResultApproxYGroPLE(:,runNo)  =  EvaluationAll(sign((W*H)'),Y',(W*H)');
end

AvgResultGroPLE(:,1)    =  mean(ResultGroPLE,2);
AvgResultGroPLE(:,2)    =  std(ResultGroPLE,1,2);

AvgResultApproxYGroPLE(:,1) = mean(ResultApproxYGroPLE,2);
AvgResultApproxYGroPLE(:,2) = std(ResultApproxYGroPLE,1,2);


%% Print Result to the File
filename = strcat( pwd(),'/Result/resultFinal_R3.txt');
fs = fopen(filename,'a');
fprintf(fs,'\n\n\n%s\n\n',filename1);
fprintf(fs,'\n\t\t\t\t\t\tHammingLoss\t\t ExampleBasedAccuracy\t ExampleBasedPrecision\t ExampleBasedRecall\t ExampleBasedFmeasure\t');
fprintf(fs,'\tSubsetAccuracy\t\t\t  LabelBasedAccuracy\t\t LabelBasedPrecision\t\t LabelBasedRecall\t LabelBasedFmeasure\t\t    MicroF1Measure\n\n');
%%
fprintf(fs,'\nGroPLE\t\t\t\t');
PrintResults(AvgResultGroPLE,fs);

fprintf(fs,'\n\nApproximation Error\n\n');
fprintf(fs,'\nGroPLE\t\t\t\t');
PrintResults(AvgResultApproxYGroPLE,fs);

