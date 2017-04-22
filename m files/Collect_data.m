%%%%%%%%%%%%%%%%%%%%Configuring%%%%%%%%%%%%%%
clc;
clear all; close all;
addpath('D:\Buu\m files');
run('Config.m');
cd(D_Asthma_Detection);

addpath(D_generateData); load('Patient_Record_ICD9.mat');
cd(D_patientFolder);

%%%%%%%%%%%%%%%%%%%%Start%%%%%%%%%%%%%%
startindex=1;endindex=179;
PatientList = dir('s*');
PatientList = {PatientList.name}';

for t = startindex : endindex %length(PatientList)
    cd(strcat(D_patientFolder,slash,PatientList{t})); %-------------------------------------------------------------------------------------------
    D_foldertest = strcat(D_patientFolder,slash,PatientList{t});
    RecordsListX = dir('s*.hea');
    RecordsListX = {RecordsListX.name}';
    tempRX = cell2mat(cellfun(@(s) strcmp(s(24),'.'),RecordsListX, 'UniformOutput', false));
    fileNameLIST = RecordsListX(tempRX);
    
    if iscell(fileNameLIST)==0
        fileNameLIST = {fileNameLIST};
    end
    for fileIndex = 1 : length(fileNameLIST)
        fileName = fileNameLIST{fileIndex}; %get filename of the [fileIndex]-th patient. Eg. 's00033-2559-01-25-12-35.hea'
        %record info
        recordName = fileName(1:23);
        m_Name = strcat(recordName,'m');            n_Name = strcat(recordName,'nm');
        m_infoName = strcat(m_Name,'.info');        n_infoName = strcat(n_Name,'.info');
        m_headerName = strcat(recordName,'.hea');   n_headerName = strcat(recordName,'n.hea');
        m_matName = strcat(m_Name, '.mat');         n_matName = strcat(n_Name, '.mat');
        %mn_ava=[cell2mat(strfind(recordList,m_Name)), cell2mat(strfind(recordList,n_Name))];
        close all;
        %patient info
        patientID = fileName(1:6); %get name of the [fileIndex]-th patient Eg. S00033
        L_alternateDownload = strcat('mimic2wdb/matched/',patientID,'/',recordName);
        D_asthDataP = strcat(D_asthDATA,slash,patientID); %dir to ptn's overall data (level 1). Eg. 'g:\matlab project\Asthma_Detection-master\Asthma Data\s00033'
        D_asthDataR = strcat(D_asthDataP,slash,recordName); %dir to ptn's data (level 2). Eg. 'g:\matlab project\Asthma_Detection-master\Asthma Data\s00033\s00033-2559-01-25-12-35'
        D_recordFolder = strcat(D_patientFolder,slash,patientID); %dir to ptn's RAW MIMIC Data folder. Eg. 'g:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\s00033'
        
        patientNo = find(cell2mat(ICD9_description(2:end,2)) == str2double(patientID(2:end))); %No of patient in 182 total
        patientDescription = ICD9_description(patientNo+1,4:5); %ASTH & OSA status
        
        %display
        disp(['Record: ',recordName,'               PatientID: ',patientID]);
        %disp(['M & N record availability:           ', num2str(mn_ava)]);
        disp(['ICD9 Description:      ' , patientDescription ]);
        
        %save patient info %-------------------------------------------------------------------------------------------
        cd(D_asthDataP); %load overall data's direction -> load INFO file which contains the below line
        load(strcat('INFO_',patientID,'.mat')) %contains 'patientNo','patientID','patientDescription'
        
        %% READ RECORDS INFO
        cd(D_asthDataR);    
        %Eg. g:\matlab project\Asthma_TMTB\Asthma Data\s00033\s00033-2559-01-26-13-11\INFO_s00033-2559-01-26-13-11.mat
        load(strcat('INFO_',recordName,'.mat'))
        %%%%%contains
        %%%%%%%%'sig_choose','m_noSeg','m_sampSeg','m_totalSample',
        %%%%%%%%'m_fs','n_fs','m_startTime','n_startTime','m_units','n_units','recordName',
        %%%%%%%%'n_signal','m_signal','n_gain','m_gain','m_base','n_base','m_noSig',
        %%%%%%%%'n_recordDuration','m_recordDuration','m_recordDurationDAY','n_recordTime'
        
%       Eg. g:\matlab project\Asthma_TMTB\Asthma Data\s00033\s00033-2559-01-26-13-11\s00033-2559-01-26-13-11n.mat
        load(strcat(recordName,'n','.mat')) %contains 'n_t0','n_RESP','n_SpO2','n_PULSE','n_PLETH','n_fs','n_interval'
%         
%         %% GENERATE ASTHMA ATTACK TIME
%         addpath(D_AsthmaEXA);
%         load(strcat('AIF_',recordName,'.mat'));
%         %%%%%contains
%         %%%%%%%%'n_attackPoint','m_attackPoint','asth_severity','asth_duration','m_asth_duration','n_asth_duration','asth_duration_thresh',
%         %%%%%%%%'asth_locAS', 'asth_locGE', 'asth_locLT', 'asth_locMM'
%         
        %% READ M RECORD / GENERATE
        
        cd(m_files)
        run('RP_Asthma.m');
        
        
        
        
        
        %% END BASIC INFO
    end
    fprintf('RECORD IS PROCESSED: %s\n',recordName);
    disp('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&END&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
end