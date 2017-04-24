close all;

<<<<<<< HEAD
if (size(data, 2) == 1)
    data = transpose(data);
end

SD = std(data);
mean1 = mean(data);
etp_pos = find( (data > mean1 + 3 * SD) | (data < mean1 - 3 * SD) );

% outliers = locateOutlers(data,'thresh','above', mean1 + 2.5 * SD);

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
dmsn = 5;
midelay = mi(kk, 10, size(kk,2));

for ii = 1: size(data,2)
    if ((midelay(1, 1, ii) < midelay(1, 1,ii+1)) && (midelay(1, 1, ii) < midelay(1, 1, ii-1)))
=======
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
>>>>>>> 0b3ea19ac3d94282e30f2fb9f4429a276a928103
        checkt = ii;
        break;
    end;
end;
<<<<<<< HEAD
%
tdelay = checkt;

% [maxd, tmp] = pss(kk, dmsn, 5);
% eps = 0.1 * maxd;

tt = crqa(kk, 5, tdelay, 0.1, length(kk), 1, 'fan', 'nogui');
=======

tdelay = checkt;
[maxd, tmp] = pss(kk, dmsn, tdelay);
eps = 0.1 * maxd;

tt = crqa(kk, dmsn, tdelay, eps, 'euc', 'nogui');
>>>>>>> 0b3ea19ac3d94282e30f2fb9f4429a276a928103
%         -----------------------------------
FILE = fopen(output, 'a');
% fprintf(FILE, '%s\t', sprintf('%04d',m_section));
fprintf(FILE, '%s \t', record_name);
fprintf(FILE, '%d \t %d \t %d \t %3.2f \t', wderr-1, dmsn, tdelay, eps);
fprintf(FILE, '%d \t', tt);
fprintf(FILE, '\n');
fclose(FILE);
%         -----------------------------------
