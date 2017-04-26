function calc = mtbi_extraction(filename, start, endfile)

addpath('/media/tmtb/LinuxDrive/matlab project');
addpath('/media/tmtb/LinuxDrive/matlab project/Pre-Epi-Post data');
addpath('/media/tmtb/LinuxDrive/matlab project/EEG');
addpath('/media/tmtb/LinuxDrive/matlab project/CRP toolbox/crptool');

close all;

src_mat = 'media/tmtb/LinuxDrive/matlab project/Pre-Epi-Post data/';
data_tmp = load(strcat(src_mat, filename), 'whole_file1');
data = data_tmp.whole_file1;
data = transpose(data);

Ts=1/256;% sampling period
Fs=256;%sampling frequency
[NN,nu]=size(data);%obtain size of data
t=(1:NN)*Ts;%generates time vector

% y=fft(data);% fft of data
% plot(y(:,1));
% ps1=abs(y).^2;% power spectrum using fft
% freq=(1:N)*Fs/N;%frequency vector
% h2=figure;
% plot(freq,20*log(ps1),'b')
% title('POWER SPECTRUM USING FFT METHOD')

% NOTE: filters designed using FDA tool box
%DELTA
 
Fs = 256;  % Sampling Frequency
Fpass = 0;               % Passband Frequency
Fstop = 4;               % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
dens  = 20;              % Density Factor
% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);
% Calculate the coefficients using the FIRPM function.
b1 = firpm(N, Fo, Ao, W, {dens});
Hd1 = dfilt.dffir(b1);
x1=filter(Hd1,data);

% tmser = start:NN-endfile;
tmser = 1:NN;

h4=figure;
plot(t(tmser),x1(tmser,:),'r')
title('waveform for DELTA band')
calc0 = [];

% x=(-1:.002:1)+.3*rand(1,1001);
% y=(-1:.002:1).^2+.3*rand(1,1001);
% corrcoef(x,y)

for ch = 1:nu
%     dmsn = 2; %fnn(x1(tmser));
%     tdelay = 1;
%     kk = x1(1:100, ch);
%     [maxd, tmp] = pss(kk, dmsn, tdelay);
%     eps = floor(0.1 * maxd);
    
    calc1 = [];    
    tmser1 = (1:10*256);
    
    % calculate time delay
%     for td = 1:4
%         aa = x1(tmser1, ch);
%         bb = x1(tmser1+td, ch);
%         ace(aa, bb)
%     end
    %----------------------
    
    for part = (1: floor(NN/2560))
        if tmser1(2560) > NN 
           tmser1 = tmser1(1): tmser1(NN - (part-1)*2560);
        end
        dmsn = 2; %fnn(x1(tmser));
        tdelay = 1;
        kk = x1(tmser1, ch);
        [maxd, tmp] = pss(kk, dmsn, tdelay);
        eps = floor(0.1 * maxd);
        
        tt = crqa(x1(tmser(tmser1),ch), dmsn, tdelay, eps, 'euc', 'nogui');
        calc1 = [calc1; tt];
        tmser1 = tmser1 + 10*256;
    end
    calc0 = [calc0, calc1];
%end

% xlswrite(strcat('g:\matlab project\result\', filename, '.xls'), calc1);

calc = calc0;

end