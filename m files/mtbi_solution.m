% % addpath('g:\matlab project\m files');
% addpath('/media/tmtb/LinuxDrive/matlab project/m files');
% 
% % tt = mtbi_extraction('chb02_16.edf(1).mat', 33280+1, 76801);
% % tt = mtbi_extraction('chb01_03.edf(1).mat', 76801+1, 76801);
tt = mtbi_extraction('chb18_29.edf(1).mat', 76801+1, 18689);
% 
% tt = [1,2,3,4];
% filename = 'aaa';
%         FILE = fopen(strcat('/media/tmtb/LinuxDrive/matlab project/result/', 'test','.csv'), 'w');
%         fprintf(FILE, filename);
%         fprintf(FILE, '%d\t', tt);
%         fprintf('\n');
%         fclose(FILE);
        
% dlmwrite(strcat('/media/tmtb/LinuxDrive/matlab project/result/', 'test','.csv'), ['aaaa', 121], 'delimiter', '%s\t', '-append');
% % a = dir('G:\matlab project\Pre-Epi-Post data');
% % xlswrite('G:\matlab project\Pre-Epi-Post data\names', a);
% x=(-1:.002:1)+.3*rand(1,1001);
% y=(-1:.002:1).^2+.3*rand(1,1001);
% corrcoef(x,y)
% ace(y,x)