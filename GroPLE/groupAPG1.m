function [bestW,bestH, tmpLabelIdx] = groupAPG1(X,Y,Wini, Hini, par)
% This function is designed to learn the group sparsity preserving label embedding

%    Input
%       X           - a N by D data matrix,  N is the number of  instances and D is the number of features
%       Y           - a N by L label matrix, N is the number of  instances and L is the number of labels
%       Wini        - a N by k initialization of W (in paper U)
%       Hini        - a L by k initialization of H (in paper V)
%       par         - A struct variable with eight fields, the optimization parameters for LLSF

%                   1) maxIter          - number of maximum iterations
%                   2) nGroups          - number of groups
%                   3) k                - latent dimension
%                   4) lambda1          - regularization paramenter
%                   5) lambda2          - regularization paramenter
%                   6) tol              - tolerance
%                   7) norm_l21         - function handle
%                   8) prox_l21         - function handle


maxiter = par.maxiter;
nGroups = par.nGroups;
k       = par.k;
lambda1 = par.lambda1;
lambda2 = par.lambda2;
tol   = par.tol;
norm_l21 = par.norm_l21;


W = Wini;
tmpLabelIdx = par.tmpLabelIdx;

ttlInsInGroup = zeros(1,nGroups);
groupWiseH = cell(1,nGroups);
newY = cell(1,par.nGroups);
for groupNo = 1:nGroups
    newY{1,groupNo} = Y(:,tmpLabelIdx == groupNo);
    ttlInsInGroup(groupNo) = sum(tmpLabelIdx== groupNo);
    groupWiseH{1,groupNo} = Hini(:,tmpLabelIdx == groupNo);
end
%ttlInsInGroup
H12Norm = zeros(1,nGroups);
oldloss = 0;
for iter=1:maxiter
    for groupNo = 1:nGroups
        [groupWiseH{groupNo}, vIter]  = groupWiseVAPG(W,newY{1,groupNo},par);
    end
    for groupNo = 1:nGroups
        H(:,tmpLabelIdx==groupNo) = groupWiseH{groupNo};
    end
    W = (Y*H')/(H*H' + lambda1.* eye(k,k));
    if isnan(W)
        break;
    end
    W2norm = lambda1.*sum(W(:).^2);
    WH = W*H;
    fprintf('\n Iteration %d\n', iter);
    for groupNo = 1:nGroups
        H12Norm(groupNo) = lambda2.*norm_l21(groupWiseH{groupNo});
    end
    totalloss = sum(sum( (WH - Y).^2)) + W2norm + sum(H12Norm) ;
    %fprintf(strcat('\n Overall newObj %.4f  W_norm %.4f',repmat('\t%.4f \t',1,nGroups)),totalloss, W2norm, H12Norm);
    fprintf('\n Overall newObj %.4f' ,totalloss);
    
    if abs(oldloss - totalloss) <= tol
        break;
    elseif totalloss <=0
        break;
    else
        oldloss = totalloss;
    end
end
bestH = H;
bestW = W;
end