close all;

if (size(data, 2) == 1)
    data = transpose(data);
end

SD = std(data);
mean1 = mean(data);
etp_pos = find( (data > mean1 + 3 * SD) | (data < mean1 - 3 * SD) );

data_tmp = data;
data(etp_pos) = NaN;
data_tmp(etp_pos) = mean1;
data = [data; data_tmp];
data = knnimpute(data);
data = data(1,:);
% plot(data);
saveplot = strcat(D_asthDATA, slash, 'HRV_Figure', slash, patient_name, slash, record_name, sprintf('_W%d', wderr-1), '.jpg');
saveas(gcf, saveplot);
addpath(CRP_tools);


kk = data;

% NN = size(kk,1);
% dmsn_tmp = fnn(kk,30);
%
% t=1:30;
% y=dmsn_tmp;
% dy=gradient(y,t);
% % subplot(2,1,1);
% % plot(t,y);
% % subplot(2,1,2);
% % plot(t,dy);

% dmsn = find(abs(dy) < 1e-3, 1, 'first')-1;

kk = data;
midelay = mi(kk, 20, length(kk));
for ii = 1:200-1
    if ((midelay(1, 1, ii) < midelay(1, 1,ii+1)) && (midelay(1, 1, ii) > midelay(1, 1, ii-1)))
        checkt = ii;
        break;
    end;
end;
%
tdelay = checkt;

% [maxd, tmp] = pss(kk, dmsn, 5);
% eps = 0.1 * maxd;
dmsn = 5;
tt = crqa(kk, 5, tdelay, 0.1, length(kk), 1, 'fan', 'nogui');

%         -----------------------------------
FILE = fopen(output, 'a');
fprintf(FILE, '%s \t', record_name);
fprintf(FILE, '%d \t %d \t %d \t %d \t %3.2f \t', length(kk), wderr, dmsn, tdelay, 0.1 * length(kk));
fprintf(FILE, '%d \t', tt);
fprintf(FILE, '\n');
fclose(FILE);
%         -----------------------------------
