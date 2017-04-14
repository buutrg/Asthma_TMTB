%%%%%%%%%%%%%%%%%%%%Configuring%%%%%%%%%%%%%%
clc;
clear all; close all;
addpath('g:\matlab project\Asthma_Detection-master');
run('Config.m');
cd(D_Asthma_Detection);

addpath(D_generateData); load('Patient_Record_ICD9.mat');
cd(D_patientFolder);

%%%%%%%%%%%%%%%%%%%%Start%%%%%%%%%%%%%%
startindex=1;endindex=179;
PatientList = dir('s*');
PatientList = {PatientList.name}';

for t = startindex : endindex %length(PatientList)
    cd(strcat(D_patientFolder,slash,PatientList{t}));
    D_foldertest = strcat(D_patientFolder,slash,PatientList{t});
    RecordsListX = dir('s*.hea');
    RecordsListX = {RecordsListX.name}';
    tempRX = cell2mat(cellfun(@(s) strcmp(s(24),'.'),RecordsListX, 'UniformOutput', false));
    fileNameLIST = RecordsListX(tempRX);
    
    % [fileNameLIST, ~,~] = uigetfile('s*.hea', 'Pick a record file','MultiSelect', 'on'); %open dialog to choose file
    % fileName = input('Open file: ', 's'); %returned entered text as string
    % fileName = 's00033-2559-01-25-12-35'; %indentify record name
    if iscell(fileNameLIST)==0
        fileNameLIST = {fileNameLIST};
    end
    for fileIndex = 1 : length(fileNameLIST)
        fileName = fileNameLIST{fileIndex}; %get filename of the [fileIndex]-th patient. Eg. 's00033-2559-01-25-12-35.hea'
        %[~,~,recordList] = xlsread('RAW Matched Subset SubjectID.xlsx',2); recordList = recordList(2:end,3);
        %[~,~,ICD9_description]=xlsreadm_Name = strcat(recordName,'m');('Patients_CHECKLIST.xlsx',4);   %get patient list with IDC9 description
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
        D_asthDataP = strcat(D_asthDATA,slash,patientID);                                   %dir to ptn's overall data (level 1). Eg. 'g:\matlab project\Asthma_Detection-master\Asthma Data\s00033'
        D_asthDataR = strcat(D_asthDataP,slash,recordName);                                 %dir to ptn's data (level 2). Eg. 'g:\matlab project\Asthma_Detection-master\Asthma Data\s00033\s00033-2559-01-25-12-35'
        D_recordFolder = strcat(D_patientFolder,slash,patientID);                           %dir to ptn's RAW MIMIC Data folder. Eg. 'g:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\s00033'
        mkdir(D_asthDATA,patientID);                                                        %create DATA Patient folder
        mkdir(D_asthDataP,recordName);                                                      %create DATA Patient folder
        patientNo = find(cell2mat(ICD9_description(2:end,2)) == str2double(patientID(2:end))); %No of patient in 182 total
        patientDescription = ICD9_description(patientNo+1,4:5); %ASTH & OSA status
        
        %display
        disp(['Record: ',recordName,'               PatientID: ',patientID]);
        %disp(['M & N record availability:           ', num2str(mn_ava)]);
        disp(['ICD9 Description:      ' , patientDescription ]);
        
        %save patient info
        cd(D_asthDataP); %load overall data's direction -> load INFO file which contains the below line
        try load(strcat('INFO_',patientID,'.mat'))
        catch
            save(strcat('INFO_',patientID,'.mat'),'patientNo','patientID','patientDescription');
        end
        
        %% READ header & info file of M RECORD
        %open the header file in text mode ('rt')
        cd(D_recordFolder); %load RAW MIMIC II's ptn direction
        m_heaFid = fopen(m_headerName, 'rt'); %open head file which contains: <age> <sex>
        if m_heaFid < 1
            error('Cant find header file');
        end
        m_header = textscan(fgetl(m_heaFid), '%s %f %f %d %s %s','Delimiter',' ');    %get first line from header which contains: %1. name
        m_noSig = m_header{2};                                                          %2. number of signals
        m_fs = m_header{3}; m_interval = 1/m_fs;                                        %3. sampling f & interval: time for each interval
        m_totalSample = m_header{4};                                                    %4. total sample for this record
        m_totalSample = double(m_totalSample);
        [m_recordStartTime] = sscanf(char(m_header{5}),'%f:%f:%f');                     %5. record Start time
        m_recordDuration = m_totalSample/m_fs;       %duration in seconds
        m_recordDurationDAY = m_recordDuration/(24*3600);
        fclose(m_heaFid);
        
        %open the info file in text mode ('rt')
        cd(D_info);
        m_infoFid = fopen(m_infoName, 'rt');
        if m_infoFid < 1
            error('Cant find info file');
        end
        
        %Read lines from info file
        [m_startTime] = textscan(fgetl(m_infoFid), '%s %s','Delimiter','[');        %get first line from info file which contains: name and start time
        m_startTime = textscan(char(m_startTime{2}),'%s %s','Delimiter',' ');       %get the start time
        m_startTime = m_startTime{1};    %array, if text put "char(..."
        fgetl(m_infoFid); fgetl(m_infoFid); %skip 3 line of info file
        fgetl(m_infoFid);
        fgetl(m_infoFid); %skip signal header string
        %read signal list into workspace
        for i = 1:m_noSig
            [m_row(i), m_signal(i), m_gain(i), m_base(i), m_units(i)]=strread(fgetl(m_infoFid),'%d%s%f%f%s','delimiter','\t');
        end
        fclose(m_infoFid);                           %close .info file
        % create choosen sig vector
        m_PLETH_loc = [];
        m_II_loc = [];
        for pz = 1:length(m_signal)
            m_sigCheck = m_signal{pz};
            switch m_sigCheck
                case 'II'
                    m_II_loc = pz;
                case 'PLETH'
                    m_PLETH_loc = pz;
                otherwise
            end
        end
        sig_choose = [m_II_loc, m_PLETH_loc];
        %END create choosen sig vector
        
        %display
        disp(['Sampling Freq: ',num2str(m_fs),'    Total samples: ',num2str(m_totalSample),'   Number of signals: ',num2str(m_noSig)]);
        disp(['Signal list: ', m_signal]);
        disp(['Record start at: ', m_startTime]);
        disp(['Record duration (DD:HH:MM:SS:) :  ',datestr(m_recordDurationDAY,'DD:HH:MM:SS')]);
        
        %%
        %%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        %%
        
        %% DIVIDE M FILE INTO SECTION
        m_sampSegMin = 60 ;                             %duration per sample-segment
        m_sampSeg = m_sampSegMin * m_fs * 60;           %duration (in minute) of sample
        if m_sampSeg >= m_totalSample
            m_sampSeg = m_totalSample;
        end
        m_noSeg = ceil(m_totalSample/m_sampSeg);    %number of Segment
        
        %% READ N RECORD from old .mat file (no header)
        cd(D_nRecords); %cd to g:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\PRE_GENERATED RECORD
        try
            load(n_matName);                    %load data in .nm file into workspace: s00033-2559-01-25-12-35nm.mat
        catch
            disp('No N file in database');
        end
        n_val = val;
        n_fid = fopen(n_infoName, 'rt');    %open the info file in text mode ('rt')
        %Read lines from info file
        [n_startTime] = textscan(fgetl(n_fid), '%s %s %s %s','Delimiter','[');
        n_startTime = strcat('[',n_startTime{2});
        fgetl(n_fid); %skip 2nd line of info file
        [n_recordTime] = sscanf(fgetl(n_fid),'Duration: %f:%f:%f '); %get total time of record, hrs:min:sec
        n_recordDuration = 0;
        for i=1 : length(n_recordTime)
            n_recordDuration = n_recordDuration + n_recordTime(length(n_recordTime)+1 - i)*60^(i-1);
        end
        [freqint] = sscanf(fgetl(n_fid),'Sampling frequency: %f Hz  Sampling interval: %f sec'); %scan string to find sampling freq
        n_interval = freqint(2); n_fs = freqint(1);
        fgetl(n_fid); %skip signal header string
        %read signal into workspace
        for i = 1:size(n_val, 1)
            [n_row(i), n_signal(i), n_gain(i), n_base(i), n_units(i)]=strread(fgetl(n_fid),'%d%s%f%f%s','delimiter','\t');
        end
        fclose(n_fid);                           %close .info file
        n_val(n_val==-32768) = NaN;              %change into NaN
        n_t0 = (0:size(n_val, 2)-1) * n_interval;   %creat time axis according to sampling freq
        %change to physical unit
        for i = 1:size(n_val, 1)
            n_val(i, :) = (n_val(i, :) - n_base(i)) / n_gain(i);
        end
        
        %% SAVE RECORDS INFO
        cd(D_asthDataR);    %Eg. g:\matlab project\Asthma_Detection-master\Asthma Data\s00033\s00033-2559-01-25-12-35
        try load(strcat('INFO_',recordName,'.mat'))
        catch
            save(strcat('INFO_',recordName,'.mat'),'sig_choose','m_noSeg','m_sampSeg','m_totalSample','m_fs','n_fs','m_startTime','n_startTime','m_units','n_units','recordName','n_signal','m_signal','n_gain','m_gain','m_base','n_base','m_noSig','n_recordDuration','m_recordDuration','m_recordDurationDAY','n_recordTime');
        end
        
        %% CHECK SIGNAL N OF INTEREST
        %create emty sig with NaN
        n_PULSE = NaN(1,length(n_t0));
        n_SpO2 = NaN(1,length(n_t0));
        n_RESP = NaN(1,length(n_t0));
        n_PLETH = NaN(1,length(n_t0));
        
        for i = 1:size(n_val,1)
            n_sigCheck = n_signal{i};
            
            switch n_sigCheck
                case 'SpO2'
                    n_SpO2 = n_val(i,:);
                case 'PULSE'
                    n_PULSE = n_val(i,:);
                case 'RESP'
                    n_RESP = n_val(i,:);
                case 'PLETH'
                    n_PLETH = n_val(i,:);
                otherwise
            end
        end
        % PREPROCESSING N SIGNAL:
        % sync NaN & filter SpO2 < 50 and RESP < 5 per min
        for ii = 1 : length(n_t0)
            if (n_RESP(ii) < 5 || n_SpO2(ii) < 50)
                n_RESP(ii) = NaN;
                n_SpO2(ii) = NaN;
                n_PULSE(ii) = NaN;
                n_PLETH(ii) = NaN;
            end
        end
        % SAVE N RECORD
        cd(D_asthDataR);    %Eg. g:\matlab project\Asthma_Detection-master\Asthma Data\s00033\s00033-2559-01-25-12-35
        %         try load(strcat(recordName,'n','.mat'))
        %         catch
        save(strcat(recordName,'n','.mat'),'n_t0','n_RESP','n_SpO2','n_PULSE','n_PLETH','n_fs','n_interval');
        fprintf('N file saved \n');
        %         end
        %         %% GENERATE ASTHMA ATTACK TIME
        %         addpath(D_AsthmaEXA);
        %         run('AsthmaEXA2.m');
        %         %         cd(D_asthDataR);
        %         try load(strcat('AIF_',recordName,'.mat'));
        %         catch
        %             save(strcat('AIF_',recordName,'.mat'),'n_attackPoint','m_attackPoint','asth_severity','asth_duration','m_asth_duration','n_asth_duration','asth_duration_thresh','asth_locAS', 'asth_locGE', 'asth_locLT', 'asth_locMM');
        %             fprintf('Asthma info generated\n');
        %         end
        %
        %         % READ M RECORD / GENERATE
        %         m_t0 = []; m_val = [];
        %         ErrorDATA = cell(m_noSeg,1);
        %         cd(D_asthDataR);
        %         createR_time = tic;
        %         for m_section = 1: m_noSeg
        %
        %             N0 = 1+ (m_section-1)*m_sampSeg; %Section start point
        %             N = m_section*m_sampSeg;  %Section end point
        %
        %             mSecStart = datestr((datenum(m_startTime) + N0*m_interval/(24*3600)),'DD:HH:MM:SS');
        %             mSecEnd = datestr((datenum(m_startTime) +N*m_interval/(24*3600)),'DD:HH:MM:SS');
        %             mSecDuration = datestr((N-N0)*m_interval/(24*3600),'DD:HH:MM:SS');
        %
        %             if N > m_totalSample
        %                 N = m_totalSample;
        %             end
        %
        %             m_t0 = [];
        %             m_val = [];
        %             tempDATAname = strcat(recordName,'_A',sprintf('%04d',m_section),'.mat');
        %             cd(D_asthDataR);
        %
        %             %Delete ADATA file if < 2kb (for error file)
        %             ADATA_info = dir(tempDATAname);
        %             if isempty(ADATA_info) == 0
        %                 DATKbytes = ADATA_info.bytes/1024;
        %                 if DATKbytes <= 1
        %                     delete(tempDATAname);
        %                 end
        %             end
        %             %%%%%C?t th�nh 2min .m file
        %             addpath(D_generateData)
        %             run('GenerateDATAfile.m');
        %             %save
        %             cd(D_asthDataR);
        %             save(tempDATAname,'m_t0','m_II','m_PLETH','m_fs','mSecStart','mSecEnd','mSecDuration','N','N0');
        %             fprintf('Section %d/%d | %s generated, start: %d >>> end %d \n',m_section,m_noSeg,recordName,N0,N);
        %
        %             toc(createR_time);
        %
        %
        %             % fprintf('Section start: %s\n',mSecStart);
        %             % fprintf('Section end: %s\n',mSecEnd);
        %             % fprintf('Section duration: %s\n',mSecDuration);
        %         end
        
        %% SAVE ERROR FILE
        %         cd(D_asthDataR);
        %         try load(strcat('ERROR_',recordName,'.mat'))
        %         catch
        %             save(strcat('ERROR_',recordName,'.mat'),'ErrorDATA');
        %         end
        %         fprintf('ERROR file generated\n');
        %% END BASIC INFO
    end
    fprintf('RECORD GENERATED: %s\n',recordName);
    disp('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&END&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
end