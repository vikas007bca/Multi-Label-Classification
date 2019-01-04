function [F1micro] = F1micro(TP,FP,TN,FN)

ttlTP = sum(TP);
ttlFP = sum(FP);
ttlFN = sum(FN);

F1micro = 2*ttlTP / (2*ttlTP + ttlFN + ttlFP);
end