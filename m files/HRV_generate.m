%% FOLDER & LINKS & FILELIST
D_PHRVText = 'D:\MIMC II WAVEFORMI DATABASE\2 MINUTES WINDOW DATA\2MW ORIGINAL HRV TXT\PPG HRV Text';
D_EHRVText = 'D:\MIMIC II WAVEFORM DATABASE\2 MINUTES WINDOW DATA\2MW ORIGINAL HRV TXT\ECG HRV Text';
D_HRVData = 'D:\Buu\2MW HRV MAT DATA';
%addpath(genpath('D:\MIMIC II WAVEFORM DATABASE')); % add code & subfolders

%Get folder link
cd(D_asthDATA);
PatientList = dir('s*');
PatientList = {PatientList.name}';

%% SET CURRENT HRV window (SAMP/SECTION)
%Choose max sample per seg
lowestHRthresh = 45;    %(BPM) lowest BPM to filter detected peaks afterward
m_sampSegMin = 2 ;              %HRV window default = 2 mins
m_sampSeg_check =0;
fprintf('Lowest BPM for filter default = %d BPM \n',lowestHRthresh);
fprintf('HRV window default = %d mins \n',m_sampSegMin);
while m_sampSeg_check ~= 6
    m_sampSeg_check = input('Press 6 to keep current value, 9 to change:  \n');
    if m_sampSeg_check ==9
        m_sampSegMin = input('HRV windows (minutes):  \n');
    end
end

%% LOOP1 PATIENT FOLDER
%Choose patient
startindex = input('START FROM PATIENT: '); %returned entered text as string
fprintf('MAX = %d \n',length(PatientList));
endindex = input('END AT PATIENT: '); %returned entered text as string
plotcheck = input('PLOT CHECK, == 1 if plot: ');

for patI = startindex : endindex %length(PatientList)
    patientID = PatientList{patI};
    fprintf('################ PATIENT: %s ############## \n',patientID);
    D_asthDataP = strcat(D_asthDATA,'\',patientID);
    cd(D_asthDataP)
    RecordsListX = dir('s*');
    fileNameLIST = {RecordsListX.name}';
    
    if iscell(fileNameLIST)==0
        fileNameLIST = {fileNameLIST};
    end
    % LOAD patient info
    load(strcat('INFO_',patientID,'.mat'));
    
    %% LOOP2 RECORD FOLDER
    for fileI = 1 : length(fileNameLIST)
        recordName = fileNameLIST{fileI};
        fprintf('################ RECORD: %s ############## \n',recordName);
        D_asthDataR = strcat(D_asthDataP,'\',recordName);
        % mkdir(D_asthDataR,strcat(recordName,'_HRV'));
        % D_ashtDataH = strcat(D_asthDataR,'/',recordName,'_HRV');
        cd(D_asthDataR);
        
        %load AIF, record INFO, ERROR list
        load(strcat('AIF_',recordName,'.mat'));
        load(strcat('INFO_',recordName,'.mat'));
        load(strcat('ERROR_',recordName,'.mat'));
        
        %filter duration (-1)
        n_asth_duration = n_asth_duration - 1;
        m_asth_duration = m_asth_duration - m_fs/n_fs;
        filterDURATION = n_asth_duration > 1;
        n_asth_duration = n_asth_duration(filterDURATION);
        m_asth_duration = m_asth_duration(filterDURATION);
        m_attackPoint = m_attackPoint(:,filterDURATION);
        n_attackPoint = n_attackPoint(:,filterDURATION);
        asth_severity = asth_severity(:,filterDURATION);
        
        % check II and PLETH
        Scheck = m_signal(sig_choose);
        ScheckE = 0; ScheckP = 0;
        for lame = 1 : length(Scheck)
            switch Scheck{lame}
                case 'II'
                    ScheckE = 1;
                case 'PLETH'
                    ScheckP = 1;
                otherwise
            end
        end
        
        %% LOOP3 LOAD A_ DATA
        ADATA_LIST = dir('*_A*.mat');
        ADATA_LIST = {ADATA_LIST.name}';
        
        %creat recHRV
        recHRV = cell(length(ADATA_LIST),2);
        rec_header = {'ADATA name','HRV DATA'};
        recHRV(1,:) = rec_header;
        
        for datI = 1 : length(ADATA_LIST)
            ADATA_filename = ADATA_LIST{datI};
            recHRV{datI+1,1} = ADATA_filename;
            fprintf('################ ADATA: %s ############## \n',ADATA_filename);
            cd(D_asthDataR);
            load(ADATA_filename);
            
            %% LOOP4 DEVIDE INTO SECTIONs
            LengthADAT = length(m_t0);
            sec_window = m_sampSegMin * 60 * m_fs ;             %window = 2mins
            noWin = ceil(LengthADAT/sec_window);
            
            %creat recHRV
            datHRV = cell(noWin+1,9);
            dat_header = {'WinNo','ERR','PRR','ASTH','ErrorEpeak','ErrorERR','ErrorPpeak','ErrorPRR','Winlength'};
            datHRV(1,:) = dat_header;
            
            delay = 0;
            for winI = 1 : noWin
                winTime = tic;
                S0 = 1 + (winI-1)*sec_window - delay;
                S = winI * sec_window;
                datHRV{winI+1,9} = S-S0;
                %ASTHMA SEVERITY CLASSIFICATION
                sClass = 0;
                M0 = S0 + N0;
                M = S + N0;
                
                if isempty(m_attackPoint)
                    sClass = 0;
                else
                    %diagram:  --(1)--M0----(2)----M--(3)--
                    Acheck = zeros(size(m_attackPoint));
                    for k = 1 : size(m_attackPoint,2)
                        % check M0 position check M position
                        for kj = 1:2
                            if (m_attackPoint(kj,k) >=M0 && m_attackPoint(kj,k) <= M)  % position (2)
                                Acheck(kj,k) = 2;
                            elseif m_attackPoint(kj,k) > M % position (3)
                                Acheck(kj,k) = 3;
                            else Acheck(kj,k) = 1;   % position (1)
                            end
                        end
                    end
                    preClass = zeros(1,size(Acheck,2));
                    for aIn = 1 : size(Acheck,2)
                        if  (Acheck(1,aIn) == 1 && Acheck(2,aIn) == 1) || (Acheck(1,aIn) == 3 && Acheck(2,aIn) == 3) %outside
                            preClass(aIn) = 0;
                            delay = 0;
                        elseif (Acheck(1,aIn) == 1 && Acheck(2,aIn) == 3) %asth duration cover segment
                            preClass(aIn) = find(asth_severity(:,aIn)==1);
                            delay = 0;
                        elseif (Acheck(1,aIn) == 2 && Acheck(2,aIn) == 2) %all asth duration stay inside segment
                            preClass(aIn) = find(asth_severity(:,aIn)==1);
                            delay = 0;
                        elseif (Acheck(1,aIn) == 1 && Acheck(2,aIn) == 2) %M0 stay between (1) & (2)
                            preClass(aIn) = find(asth_severity(:,aIn)==1);
                            delay = M - m_attackPoint(2,aIn);
                            S = S - delay;
                        elseif (Acheck(1,aIn) == 2 && Acheck(2,aIn) == 3) %M stay between (2) & (3)
                            preClass(aIn) = find(asth_severity(:,aIn)==1);
                            delay = M - m_attackPoint(1,aIn);
                            S = S - delay;
                        end
                    end
                    sClass = round(mean(preClass(preClass~=0)));
                    if isnan(sClass)
                        sClass = 0;
                    end
                end
                
                
                if S > LengthADAT
                    S = LengthADAT;
                end
                
                if S0 < 2
                    S0 = 1;
                end
                
                m_IIs = m_II(S0:S);
                m_PLETHs = m_PLETH(S0:S);
                m_t0s = m_t0(S0:S);
                
                if sum(~isnan(m_IIs)) == 0
                    GcheckE = 0;
                else GcheckE = 1;
                end
                if sum(~isnan(m_PLETHs)) == 0
                    GcheckP = 0;
                else GcheckP = 1;
                end
                
                datHRV{winI+1,1} = strcat('W',num2str(winI));
                datHRV{winI+1,4} = sClass;
                
                %% RR interval calculation
                %prelocating: 2 mins window =
                PRR = NaN(1,sec_window/(125*60) * 300); % 300 for each minutes
                ERR = NaN(1,sec_window/(125*60) * 300);
                
                if ScheckP ==1 && GcheckP == 1
                    try
                        [~,PPG_loc,Fm_t0s,Fm_PLETHs] = PPGpeak(m_t0s,m_PLETHs,m_fs,1,length(m_PLETHs));
                        m_t0s = Fm_t0s;
                        m_PLETHs = Fm_PLETHs; %filter PPG
                    catch
                        disp('Error in PPG peak detection');
                        PPG_pks = [];
                        PPG_loc = [];
                        datHRV{winI+1,7} = 'E';
                    end
                    
                    try
                        PpeakTime = [];
                        PpeakTime = m_t0s(PPG_loc);    %convert R location to actual time in seconds
                        PRR = diff(PpeakTime);
                        PRR = PRR(2:end); %delete first RRI to avoid noise
                    catch
                        disp('Error in PPG RR calculation');
                        datHRV{winI+1,8} = 'E';
                    end
                end
                
                if ScheckE == 1 && GcheckE == 1
                    try
                        [~,ECG_loc] = ECGpeak(m_t0s,m_IIs,m_fs,1,length(m_IIs));
                        datHRV{winI+1,2} = m_IIs;
                    catch
                        disp('Error in ECG peak detection');
                        ECG_pks = [];
                        ECG_loc = [];
                        datHRV{winI+1,5} = 'E';
                    end
                    try
                        EpeakTime = [];
                        EpeakTime = m_t0s(ECG_loc);    %convert R location to actual time in seconds
                        ERR = diff(EpeakTime);
                        ERR = ERR(2:end); %delete first RRI to avoid noise
                    catch
                        disp('Error in ECG RR calculation');
                        datHRV{winI+1,6} = 'E';
                    end
                end
                
                %Post process PRR & ERR
                PRR(isnan(PRR))=[];
                ERR(isnan(ERR))=[];
                PRR = PRR';
                ERR = ERR';
                winRatio = (S-S0)/sec_window;
                if (length(PRR) < lowestHRthresh*m_sampSegMin * winRatio)
                    PRR = [];
                end
                if (length(ERR) < lowestHRthresh*m_sampSegMin * winRatio)
                    ERR = [];
                end
                
                %% PLOT
                if plotcheck == 1
                    
                    Fig1 = figure(1);
                    ax1 = subplot(2,1,1);
                    plot(m_t0s,m_IIs,EpeakTime,m_IIs(ECG_loc),'ro');
                    ylabel('ECG II');
                    ax2 = subplot(2,1,2);
                    plot(m_t0s,m_PLETHs,PpeakTime,m_PLETHs(PPG_loc),'ro');
                    ylabel('PPG');
                    linkaxes([ax1 ,ax2],'x');
                    set(Fig1, 'Position', [120 200 560 420])
                    
                    Fig2 = figure(2);
                    bx1 = subplot(2,1,1);
                    plot(ERR);
                    legend('ECG II HRV');
                    ylabel('mV');
                    bx2 = subplot(2,1,2);
                    plot(PRR);
                    legend('PPG HRV');
                    ylabel('mV');
                    linkaxes([bx1 ,bx2],'xy');
                    set(Fig2, 'Position', [700 200 560 420])
                    
                end
                %% SAVE
                textNameP = strcat(patientID,sprintf('_R%02d_%s_W%02d_PPG_C%01d.txt',fileI,ADATA_filename(end-8:end-4),winI,sClass));
                textNameE = strcat(patientID,sprintf('_R%02d_%s_W%02d_ECG_C%01d.txt',fileI,ADATA_filename(end-8:end-4),winI,sClass));
                cd(D_PHRVText);
                if ScheckP == 1
                    datHRV{winI+1,3} = PRR;
                    if exist(textNameP,'file') == 2
                        fprintf('%s is already created \n',textNameP);
                    else
                        if isempty(PRR) == 0
                            save(textNameP,'PRR','-ascii');
                        end
                    end
                end
                
                cd(D_EHRVText);
                if ScheckE == 1
                    datHRV{winI+1,2} = ERR;
                    if exist(textNameE,'file') == 2
                        fprintf('%s is already created \n',textNameE);
                    else
                        if isempty(ERR) == 0
                            save(textNameE,'ERR','-ascii');
                        end
                    end
                end
                
                
                fprintf('Section %d/%d of %s generated \n',winI,noWin,ADATA_filename);
                fprintf('sClass: %d, delay %d, ERR: %d, PRR: %d \n',sClass,delay,length(ERR),length(PRR));
                toc(winTime);
            end
            recHRV{datI+1,2} = datHRV;
            fprintf('*** ADATA %s finished \n',ADATA_filename);
        end
        cd(D_HRVData);
        recHRV_filename = strcat('HRV_',recordName,'.mat');
        try
            load(recHRV_filename);
        catch
            disp('saving recHRV file');
            save(recHRV_filename,'recHRV');
        end
        fprintf('********* RECORD %s finished \n',recordName);
    end
    fprintf('*************** PATIENT %s finsished \n',patientID);
end



