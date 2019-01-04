function [F1macroTrn] = F1macro(TP,FP,TN,FN,L)

tmp = ( (2.*TP) + FN + FP );
tmp(tmp==0) = 1;

F1macroTrn = sum((2.*TP)./ tmp) ./(L);
end