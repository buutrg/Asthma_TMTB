function calc = mtbi_extraction(filename, start, endfile)

addpath('/media/tmtb/LinuxDrive/matlab project');
addpath('/media/tmtb/LinuxDrive/matlab project/Pre-Epi-Post data');
addpath('/media/tmtb/LinuxDrive/matlab project/EEG');
addpath('/media/tmtb/LinuxDrive/matlab project/CRP toolbox/crptool');

output = strcat('/media/tmtb/LinuxDrive/matlab project/result/', filename,'.csv');

close all;

src_mat = 'media/tmtb/LinuxDrive/matlab project/Pre-Epi-Post data/';
data_tmp = load(strcat(src_mat, filename), 'whole_file1');
data = data_tmp.whole_file1;
data = transpose(data);

Ts=1/256;% sampling period
Fs=256;%sampling frequency
[NN,nu]=size(data);%obtain size of data
t=(1:NN)*Ts;%generates time vector

% NOTE: filters designed using FDA tool box
%DELTA
%% Filtering
%BETA BANDPASS FILTER (12-30)

Fs = 256; % Sampling Frequency

Fstop1 = 11.5;            % First Stopband Frequency
Fpass1 = 12;              % First Passband Frequency
Fpass2 = 30;              % Second Passband Frequency
Fstop2 = 30.5;            % Second Stopband Frequency
Dstop1 = 0.0001;          % First Stopband Attenuation
Dpass = 0.057501127785; % Passband Ripple
Dstop2 = 0.0001;          % Second Stopband Attenuation
dens   = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 ...
    0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIRPM function
b4   = firpm(N, Fo, Ao, W, {dens});
Hd4 = dfilt.dffir(b4);
x1=filter(Hd4,data);
h7=figure
plot(t,x1,'r')
title('waveform for BETA band')

tmser = 1:NN;

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
end