function [X ,Y, Xt, Yt] = splitData(X ,Y, Xt, Yt,trnPer)
Xtmp = [X;Xt];
Ytmp = [Y;Yt];
ttlInstances = size(Xtmp,1);
noTrnInstance = floor((ttlInstances*trnPer)/100);
idx = randperm(ttlInstances);
X = Xtmp(idx(1:noTrnInstance),:);
Y = Ytmp(idx(1:noTrnInstance),:);
Xt = Xtmp(idx(noTrnInstance+1:end),:);
Yt = Ytmp(idx(noTrnInstance+1:end),:);
clear Xtmp Ytmp;
end
