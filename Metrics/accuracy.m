function [accuracy] = accuracy(prdtn,Y)

[n,~] = size(Y);

intYPrdtn = sum( Y==1 & prdtn==1, 2);

uniYPrdtn = sum(Y == 1 | prdtn == 1,2);
uniYPrdtn(uniYPrdtn==0) = 1;

intDivUni = intYPrdtn ./ uniYPrdtn;

accuracy = full( sum(intDivUni)./n);

clear uniYPrdtn intYPrdtn intDivUni
end