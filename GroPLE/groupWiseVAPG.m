function [Vg,iter] = groupWiseVAPG(U,Y,par)
%% optimization parameters
lambda1          = par.lambda1;
lambda2          = par.lambda2;
gamma            = par.gamma;
maxIter          = par.gpMaxiter;
miniLossMargin   = par.minimumLossMargin;
proxNormFun      = par.prox_l21;
normFun          = par.norm_l21;
%% initializtion
num_dim = size(U,2);
UFroNorm = lambda1.*sum(U(:).^2);
UTU = U'*U;
UTY = U'*Y;
V_s   = (UTU + gamma*eye(num_dim)) \ (UTY);
%V_s   = (UTU) \ (UTY);
V_s_1 = V_s;

iter    = 1;
oldloss = 0;

Lip = sqrt(2*(norm(full(UTU))^2));

bk = 1;
bk_1 = 1;

%% proximal gradient
while iter <= maxIter
    
    V_s_k  = V_s + (bk_1 - 1)/bk * (V_s - V_s_1);
    Gv_s_k = V_s_k - 1/Lip * (UTU*V_s_k - UTY) ;
    bk_1   = bk;
    bk     = (1 + sqrt(4*bk^2 + 1))/2;
    V_s_1  = V_s;
    V_s    = proxNormFun(Gv_s_k,lambda2/Lip);
    
    predictionLoss = trace((U*V_s - Y)'*(U*V_s - Y));
    
    sparsity       = normFun(V_s);
    totalloss = predictionLoss + UFroNorm + lambda2*sparsity;
    
    if abs(oldloss - totalloss) <= miniLossMargin
        break;
    elseif totalloss <=0
        break;
    else
        oldloss = totalloss;
    end
    
    iter=iter+1;
end
Vg = V_s;
%iter

end



