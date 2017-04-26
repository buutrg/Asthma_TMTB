addpath('/media/tmtb/LinuxDrive/matlab project');
addpath('/media/tmtb/LinuxDrive/matlab project/Pre-Epi-Post data');
addpath('/media/tmtb/LinuxDrive/matlab project/EEG');
addpath('/media/tmtb/LinuxDrive/matlab project/CRP toolbox/crptool');

close all;

src_mat = '/media/tmtb/LinuxDrive/matlab project/Pre-Epi-Post data/';
data_tmp = load(strcat(src_mat, 'chb01_03.edf(1).mat'), 'whole_file1');
data = data_tmp.whole_file1;
data = transpose(data);

Ts=1/256;% sampling period
Fs=256;%sampling frequency
[N,nu]=size(data);%obtain size of data
t=(1:N)*Ts;%generates time vector

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

tmser = 76801+1:163843-76801-1;

h4=figure;
plot(t(tmser),x1(tmser,1),'r')
title('waveform for DELTA band')


% [maxd, avrgd] = pss(tmser, 'euc');
eps = 2; %54; %floor(0.1 * maxy);
dmsn = 1; %fnn(tmser);
tdelay = 2;

aa = crqa(x1(tmser,1), dmsn, tdelay, eps, 'euc', 'nogui');
tt = 3;

% a=randn(300,1);
% crqa(a,1,1,.2,40,2,'euc');
% N=300; w=40; ws=2;
% a=3.4:.6/(N-1):4;
% b=.5; for i=2:N, b(i)=a(i)*b(i-1)*(1-b(i-1));end
% y=crqa(b,3,2,.1,w,ws);
% tt = 3;

% %frequency spectrum of DELTA
% L=10;
% Fs=256;
% NFFT = 2^nextpow2(L); % Next power of 2 from length of x1
% Y1 = fft(x1,NFFT)/L;
% f = Fs/2*linspace(0,1,NFFT/2);
% % Plot single-sided amplitude spectrum
% h8=figure;
% plot(f,2*abs(Y1(1:NFFT/2))) 
% title('Single-Sided Amplitude Spectrum of DELTA x1(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y1(f)|')