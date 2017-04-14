close all;

% data = knnimpute(data);

plot(data);


addpath(CRP_tools);

kk = data;

dmsn_tmp = fnn(kk);

dmsn = 1;
for ii = 1:10
    if dmsn_tmp(ii) > 0
        dmsn = ii;
    else break;
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
eps = 0.1 * maxd;

tt = crqa(kk, dmsn, tdelay, eps, 'euc', 'nogui');
%         -----------------------------------
FILE = fopen(output, 'a');
% fprintf(FILE, '%s\t', sprintf('%04d',m_section));
fprintf(FILE, '%s \t', record_name);
fprintf(FILE, '%d \t %d \t %d \t %3.2f \t', wderr-1, dmsn, tdelay, eps);
fprintf(FILE, '%d \t', tt);
fprintf(FILE, '\n');
fclose(FILE);
%         -----------------------------------
