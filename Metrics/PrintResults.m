
function PrintResults(Result,fs)
   % fprintf(fs,'\n\tHammingLoss\t\t ExampleBasedAccuracy\t ExampleBasedPrecision\t ExampleBasedRecall\t ExampleBasedFmeasure\t');
   % fprintf(fs,'SubsetAccuracy\t  LabelBasedAccuracy\t LabelBasedPrecision\t LabelBasedRecall\t LabelBasedFmeasure\t    MicroF1Measure\n\n');

    [~,n] = size(Result);
    if n == 2
        fprintf(fs,'%.3f \\pm %.3f\t\t',Result(1,1),Result(1,2));
        fprintf(fs,'%.3f \\pm %.3f\t\t',Result(2,1),Result(2,2));
        fprintf(fs,'\t%.3f \\pm %.3f\t\t',Result(3,1),Result(3,2));
        fprintf(fs,'  %.3f \\pm %.3f\t',Result(4,1),Result(4,2));
        fprintf(fs,'\t%.3f \\pm %.3f\t\t',Result(5,1),Result(5,2));

        fprintf(fs,'\t%.3f \\pm %.3f\t\t',Result(6,1),Result(6,2));
        fprintf(fs,'\t%.3f \\pm %.3f\t',Result(7,1),Result(7,2));
        fprintf(fs,'\t\t%.3f \\pm %.3f\t\t',Result(8,1),Result(8,2));
        fprintf(fs,'\t\t%.3f \\pm %.3f\t',Result(9,1),Result(9,2));
        fprintf(fs,'\t %.3f \\pm %.3f\t',Result(10,1),Result(10,2));

        fprintf(fs,'\t%.3f \\pm %.3f\t',Result(11,1),Result(11,2));
        %fprintf(fs,'Average_Precision     %.4f  %.4f\r',Result(12,1),Result(12,2));
        %fprintf(fs,'OneError              %.4f  %.4f\r',Result(13,1),Result(13,2));
        %fprintf(fs,'RankingLoss           %.4f  %.4f\r',Result(14,1),Result(14,2));
        %fprintf(fs,'Coverage              %.4f  %.4f\r',Result(15,1),Result(15,2));
        %fprintf(fs,'\n\n------------------------------------\n');
    else
        fprintf(fs,'   %.4f  %.4f\t',Result(1,1));
        fprintf(fs,'\t%.4f  %.4f\t',Result(2,1));
        fprintf(fs,'\t%.4f  %.4f\t',Result(3,1));
        fprintf(fs,'\t%.4f  %.4f\t',Result(4,1));
        fprintf(fs,'\t%.4f  %.4f\t',Result(5,1));

        fprintf(fs,'\t%.4f  %.4f\t',Result(6,1));
        fprintf(fs,'\t%.4f  %.4f\t',Result(7,1));
        fprintf(fs,'\t%.4f  %.4f\t',Result(8,1));
        fprintf(fs,'\t%.4f  %.4f\t',Result(9,1));
        fprintf(fs,'\t%.4f  %.4f\t',Result(10,1));

        fprintf(fs,'\t%.4f  %.4f\t',Result(11,1));
        %fprintf(fs,'Average_Precision     %.4f  %.4f\r',Result(12,1),Result(12,2));
        %fprintf(fs,'OneError              %.4f  %.4f\r',Result(13,1),Result(13,2));
        %fprintf(fs,'RankingLoss           %.4f  %.4f\r',Result(14,1),Result(14,2));
        %fprintf(fs,'Coverage              %.4f  %.4f\r',Result(15,1),Result(15,2));
        fprintf(fs,'\n\n------------------------------------\n');
    end
end
