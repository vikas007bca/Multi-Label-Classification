function [clus, nGroups] = spectralClustering(X,Y,alpha,epsilon,nGroups)
noNbr = 7;
n = size(Y,1);
if n < noNbr
    noNbr = 2;
end

if n < 10
    nGroups = 2;
end

D = pdist2(Y,Y);

[~,W, ~] = scale_dist(D,noNbr);

W(isnan(W)) = 0; 
W(isinf(W)) = 0;

[V,evals] = evecs(W,max(nGroups));
for i=1:size(V,1); 
        V(i,:)=V(i,:)/(norm(V(i,:))+eps);  
end
clus = kmeans(V,nGroups,'MaxIter',100,'OnlinePhase','off');
%}
end