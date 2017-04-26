%This code is used for location configuring between GitHub and local
%respirotary. Change addresses in this file before running codes

% GitHub sync
% D_generateData = 'D:\Project\Asthma Detection\GENERATE DATA CODE'
% D_AsthmaEXA = 'D:\Project\Asthma Detection\Asthma Exacerbation Extraction';

% 1: windows cua Ngan
% 2: windows cua Buu
% 3: ubuntu cua Buu
choose_tmp = 3;

if choose_tmp == 1;
    D_Asthma_Detection = 'D:\Buu';
    D_generateData = 'D:\Buu\GENERATE DATA CODE';
    D_AsthmaEXA = 'D:\Buu\Asthma Exacerbation Extraction';
    m_files = 'D:\Buu\m files'
    % Create new folder
    D_asthDATA = 'D:\Buu\Asthma Data'; %save 2min files

    
    % In database folder
    % D_patientFolder = 'D:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE';
    % D_info='D:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\INFO';
    % D_nRecords = 'D:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\PRE_GENERATED RECORD';
    
    D_MIMIC_II = 'D:\MIMIC II WAVEFORM DATABASE';
    D_patientFolder = 'D:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE';
    D_info='D:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\INFO';
    D_nRecords = 'D:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\PRE_GENERATED RECORD';
    D_asthmaData = 'D:\MIMIC II WAVEFORM DATABASE\ASTHMA DATA';
    slash = '\';

    wfdb_toolbox = 'D:\Buu\wfdb-app-toolbox-0-9-9\mcode';
    addpath(wfdb_toolbox);
    
end
if choose_tmp == 2
    D_Asthma_Detection = 'g:\matlab project\Asthma_TMTB';
    D_generateData = 'g:\matlab project\Asthma_TMTB\GENERATE DATA CODE';
    D_AsthmaEXA = 'g:\matlab project\Asthma_TMTB\Asthma Exacerbation Extraction';
    m_files = 'g:\matlab project\Asthma_TMTB\m files';
    
    % Create new folder
    % D_asthDATA = 'D:\Project\Asthma Detection\Asthma Data'; %save 2min files
    D_asthDATA = 'g:\matlab project\Asthma_TMTB\Asthma Data'; %save 2min files
    
    % In database folder
    % D_patientFolder = 'D:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE';
    % D_info='D:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\INFO';
    % D_nRecords = 'D:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\PRE_GENERATED RECORD';
    
    D_MIMIC_II = 'g:\MIMIC II WAVEFORM DATABASE';
    D_patientFolder = 'g:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE';
    D_info='g:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\INFO';
    D_nRecords = 'g:\MIMIC II WAVEFORM DATABASE\RAW MIMIC II DATABASE\PRE_GENERATED RECORD';
    
    D_asthmaData = 'g:\MIMIC II WAVEFORM DATABASE\ASTHMA DATA';
    
    slash = '\';
    wfdb_toolbox = 'g:\matlab project\m files\wfdb-app-toolbox-0-9-9\mcode\';
    addpath(wfdb_toolbox);
    
    CRP_tools = 'g:\matlab project\CRP toolbox\crptool';
    
end;

if choose_tmp == 3
    D_Asthma_Detection = '/mnt/LinuxDrive/matlab project/Asthma_TMTB';
    D_generateData = '/mnt/LinuxDrive/matlab project/Asthma_TMTB/GENERATE DATA CODE';
    D_AsthmaEXA = '/mnt/LinuxDrive/matlab project/Asthma_TMTB/Asthma Exacerbation Extraction';
    D_asthDATA = '/mnt/LinuxDrive/matlab project/Asthma_TMTB/Asthma Data'; %save 2min files
    m_files = '/mnt/LinuxDrive/matlab project/Asthma_TMTB/m files';
  
    
    D_MIMIC_II = '/mnt/LinuxDrive/MIMIC II WAVEFORM DATABASE';
    D_patientFolder = '/mnt/LinuxDrive/MIMIC II WAVEFORM DATABASE/RAW MIMIC II DATABASE';
    D_info='/mnt/LinuxDrive/MIMIC II WAVEFORM DATABASE/RAW MIMIC II DATABASE/INFO';
    D_nRecords = '/mnt/LinuxDrive/MIMIC II WAVEFORM DATABASE/RAW MIMIC II DATABASE/PRE_GENERATED RECORD';

%     D_2min = '/mnt/LinuxDrive/MIMIC II WAVEFORM DATABASE/2 MINUTES WINDOW DATA/2MW HRV MAT DATA';    
    D_2min = '/home/thanhbuu/2MW ORIGINAL HRV TXT/ECG HRV Text';
    
    D_asthmaData = '/mnt/LinuxDrive/MIMIC II WAVEFORM DATABASE/ASTHMA DATA';
    
    slash = '/';
    wfdb_toolbox = '/mnt/LinuxDrive/matlab project/Asthma_TMTB/wfdb-app-toolbox-0-9-9/mcode/';
    addpath(wfdb_toolbox);
    
    CRP_tools = '/mnt/LinuxDrive/matlab project/CRP toolbox/crptool';
end;