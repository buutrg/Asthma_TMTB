% THIS CODE IS TO CREATE THE ANNOTATION OF ASTHMATIC PERIOD FROM MIMICII
% PATIENT RECORS
% FROM MIMICII DATABSE - PHYSIONET ATM

% WRITTEN BY ENLIN NGO - BME DEPARMENT - INTERNATIONAL UNIVERSITY HO CHI MINH CITY (VNU-HCMIU)

%% READ RECORD

% cd('D:\thesis\MIMIC II DATABASE');
cd(D_MIMIC_II)
asth_duration_thresh = 60*2 ;  % (sec) asthma attack duration threshold = 2 min.
% Document said few mins to hours or days


%% find points that meet asthma features
%CLASSIFICATION
%MILD/ MODERATE: 92 <= SpO2 <= 95, 20 < RESP =< 25, PULSE < 110
%ACUTE SEVERE:   92 <= SpO2 <= 95, RESP > 25, PULSE >=110
%LIFE THREATENING: SpO2 < 92
disp('Input 1 for MILD/ MODERATE attack detection');
disp('Input 2 for ACUTE SEVERE attack detection');
disp('Input 3 for LIFE THREATENING attack detection');
disp('Input 4 for GENERAL ASTHMA attack detection');

%MILD/ MODERATE
asth_locMM = find((n_SpO2 >=92 & n_SpO2 <=95 & n_RESP > 20 & n_RESP <=25 & n_PULSE <110));
%ACUTE SEVERE
asth_locAS = find((n_SpO2 >=92 & n_SpO2 <=95 & n_RESP > 25 & n_PULSE >= 110));
%LIFE THREATENING
asth_locLT = find(n_SpO2 <92);
%GENERAL CASE
asth_locGE = find((n_SpO2 >=92 & n_SpO2 <=95 & n_RESP > 20 & n_RESP <=25 & n_PULSE <110)| n_SpO2 < 92 |(n_SpO2 >=92 & n_SpO2 <=95 & n_RESP > 25 & n_PULSE >= 110));

fprintf('Asthma duration threshold: %d\n', asth_duration_thresh);
asth_ann = zeros(1,length(n_t0)); %has to be 1 and 0 for the following lines
asth_ann(asth_locGE) = 1;
normal_ann = ~asth_ann;

%Detect asthma period
ann1 = diff([0 ~asth_ann==0 0]);
pE = find(ann1==-1) - 1; %end of ones sequence
pS = find(ann1==1);       %start of ones sequence
asth_duration = pE-pS+1;    % refer to point, not seconds

%Filter asthma period that less than thresh. Document said few mins to hours or days
res = find((asth_duration)*n_interval >= asth_duration_thresh);
n_asth_duration = asth_duration(res);
n_attackPoint = [pS(res);pE(res)] ;                         % refer to point
m_asth_duration = n_asth_duration * n_interval/m_interval;
m_attackPoint = n_attackPoint* n_interval/m_interval;       % refer to point of WHOLE M RECORD

asth_ann(asth_ann==0) = NaN;      %change back to NaN
asth_severity = zeros(3,length(n_attackPoint));
for n = 1:size(n_attackPoint,2)
    if length(find(asth_locMM == n_attackPoint(1,n)))==1
        asth_severity(1,n) = 1;
    elseif length(find(asth_locAS == n_attackPoint(1,n)))==1
        asth_severity(2,n) = 1;
    elseif length(find(asth_locLT == n_attackPoint(1,n)))==1
        asth_severity(3,n) = 1;
    end
end

% Detect 3 normal period
ann2 = diff([0 ~normal_ann==0 0]);
pE1 = find(ann2==-1) - 1; %end of ones sequence
pS1 = find(ann2==1);       %start of ones sequence
normal_duration = pE1-pS1+1;    % refer to point, not seconds
%take 5mins of normal
nor_duration_thresh = 60*5; %5mins ?
res1 = find((normal_duration*n_interval >= nor_duration_thresh) & (normal_duration*n_interval < nor_duration_thresh*2));
n_normal_duration = normal_duration(res1);
n_normalPoint = [pS1(res1);pE1(res1)] ;                         % refer to point
m_normal_duration = n_normal_duration * n_interval/m_interval;
m_normalPoint = n_normalPoint* n_interval/m_interval;       % refer to point of WHOLE M RECORD

%random 3 period


% plot
% title_str=strcat('Record..',n_Name,'>>>','Start:..',n_startTime,'>>>','Duration:..',datestr(n_recordDurationDAY,'DD:HH:MM:SS'));
figure('name','ASTHMA ATTACK TIME');
str=strcat('Patient ID : ', num2str(patientID))
str2=strcat('Record number : ', num2str(recordName))
n_ax1 = subplot(4,1,1);
plot(n_t0,n_RESP,'r');title({str;str2})
% title(title_str);
refline(0,20);
xlabel('Time (sec)');ylabel('RESP(pm)');

n_ax2 = subplot(4,1,2);
plot(n_t0,n_SpO2,'r');
refline(0,95);
xlabel('Time (sec)');ylabel('SpO2(%)');

n_ax3 = subplot(4,1,3);
plot(n_t0,n_PULSE,'r');
refline(0,110);
xlabel('Time (sec)');ylabel('PULSE(per min)');

n_ax4 = subplot(4,1,4);
plot(n_t0,asth_ann);
xlabel('Time (sec)');ylabel('Pre-thresh (sec)');

figure(2)
m_ax1 = subplot(3,1,1);
stem(n_t0,n_PULSE);title('Sampling PULSE')
m_ax2 = subplot(3,1,2);
stem(n_t0,n_SpO2);title('Sampling SpO2')
m_ax3 = subplot(3,1,3);
stem(n_t0,n_PLETH);title('Sampling PLETH')
%m_ax2 = subplot(2,1,2);
%plot(m_t0,m_mask);

