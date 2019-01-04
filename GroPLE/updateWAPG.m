function [Wf,iter] = updateWAPG(H,Y,par)
  %% optimization parameters
    lambda1          = par.lambda1;
    gamma            = par.gamma;
    maxIter          = par.gpMaxiter;
    miniLossMargin   = par.minimumLossMargin;
    proxNormFun = par.prox_l2;
    normFun = par.norm_l2;

   %% initializtion
    num_dim = size(H,1);
    HHT = H*H';
    YHT = Y*H';
    W_s   = (YHT)/(HHT + gamma*eye(num_dim)) ;
    %V_s   = (UTU) \ (UTY);
    W_s_1 = W_s;

    iter    = 1;
    oldloss = 0;
    
    Lip = sqrt(2*(norm(full(HHT))^2));

    bk = 1;
    bk_1 = 1; 
    
   %% proximal gradient
    while iter <= maxIter

       W_s_k  = W_s + (bk_1 - 1)/bk * (W_s - W_s_1);
       Gv_s_k = W_s_k - 1/Lip * (W_s_k*HHT - YHT) ;
       bk_1   = bk;
       bk     = (1 + sqrt(4*bk^2 + 1))/2;
       W_s_1  = W_s;
       W_s    = proxNormFun(Gv_s_k,lambda1/Lip); 
       
       predictionLoss = trace((W_s*H - Y)'*(W_s*H - Y));
       %sparsity       = sum(sqrt(sum(V_s.^2,2)));
       %sparsity       = sum(sum(W_s~=0));
       sparsity = sum(W_s(:).^2);
       totalloss = predictionLoss + lambda1.*sparsity;
      
       if abs(oldloss - totalloss) <= miniLossMargin
           break;
       elseif totalloss <=0
           break;
       else
           oldloss = totalloss;
       end
       
       iter=iter+1;
    end
    Wf = W_s;
    %iter

end



