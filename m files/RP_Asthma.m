
tmser = 1:NN;

output = '123.csv';
FILE = fopen(output, 'w');
firstline = ['\t Part \t Dimension \t Time delay \t Epsilon \t',...
        'Recurrence rate \t Determinism \t  Averaged diagonal length \t', ...
        'Length of longest diagonal line \t Entropy of diagonal length \t',...
        'Laminarity \t Trapping time \t Length of longest vertical line \t',...
        'Recurrence time of 1st type \t Recurrence time of 2nd type \t',...
        'Recurrence period density entropy \t Clustering coefficient \t',...
        'Transitivity \n'];
fprintf(FILE,firstline,'\n');
fclose(FILE);

addpath(CRP_tools);

for ch = 1:nu
    tmser1 = (1:10*256);
    
    %----------------------
    
    for part = (1: floor(NN/2560))
        if tmser1(2560) > NN
            tmser1 = tmser1(1): tmser1(NN - (part-1)*2560);
        end
        
        kk = x1(tmser1, ch);
        
        dmsn_tmp = fnn(kk);
        for ii = 1:10
            if dmsn_tmp(ii) == 0 
                dmsn = ii-1;
                break;
            end;
        end;
        midelay = mi(kk, 20, 200);
        for ii = 1:200-1
            if ((midelay(1, 1, ii) < midelay(1, 1,ii+1)) && (midelay(1, 1, ii) > midelay(1, 1, ii-1)))
                checkt = ii;
                break;
            end;
        end;
        
        tdelay = checkt;
        [maxd, tmp] = pss(kk, dmsn, tdelay);
        eps = floor(0.1 * maxd);
        
        tt = crqa(x1(tmser1,ch), dmsn, tdelay, eps, 'euc', 'nogui');
        tmser1 = tmser1 + 10*256;
        %         -----------------------------------
        FILE = fopen(output, 'a');
        fprintf(FILE, '%s\t', filename);
%         fprintf(FILE, '%d\t', part);
        fprintf(FILE, '%d \t %d \t %d \t %3.2f \t', part, dmsn, tdelay, eps);
        fprintf(FILE, '%d \t', tt);
        fprintf(FILE, '\n');
        fclose(FILE);
        %         -----------------------------------
        fprintf('%d %d\n', ch, part);
    end
    
end