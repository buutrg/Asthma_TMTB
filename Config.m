%This code is used for location configuring between GitHub and local
%respirotary. Change addresses in this file before running codes

% GitHub sync
% D_generateData = 'D:\Project\Asthma Detection\GENERATE DATA CODE'
% D_AsthmaEXA = 'D:\Project\Asthma Detection\Asthma Exacerbation Extraction';

% 1: windows cua Ngan
% 2: windows cua Buu
% 3: ubuntu cua Buu
choose_tmp = 2;

if choose_tmp == 1
    D_Asthma_Detection = 'g:\matlab project\Asthma_Detection-master';
    D_generateData = 'g:\matlab project\Asthma_Detection-master\GENERATE DATA CODE';
    D_AsthmaEXA = 'g:\matlab project\Asthma_Detection-master\Asthma Exacerbation Extraction';
    
    % Create new folder
    % D_asthDATA = 'D:\Project\Asthma Detection\Asthma Data'; %save 2min files
    D_asthDATA = 'g:\matlab project\Asthma_Detection-master\Asthma Data'; %save 2min files
    
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
end
if choose_tmp == 2
    D_Asthma_Detection = 'g:\matlab project\Asthma_Detection-master';
    D_generateData = 'g:\matlab project\Asthma_Detection-master\GENERATE DATA CODE';
    D_AsthmaEXA = 'g:\matlab project\Asthma_Detection-master\Asthma Exacerbation Extraction';
    
    % Create new folder
    % D_asthDATA = 'D:\Project\Asthma Detection\Asthma Data'; %save 2min files
    D_asthDATA = 'g:\matlab project\Asthma_Detection-master\Asthma Data'; %save 2min files
    
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
end;

if choose_tmp == 3
    D_Asthma_Detection = '/media/tmtb/LinuxDrive/matlab project/Asthma_Detection-master';
    D_generateData = '/media/tmtb/LinuxDrive/matlab project/Asthma_Detection-master/GENERATE DATA CODE';
    D_AsthmaEXA = '/media/tmtb/LinuxDrive/matlab project/Asthma_Detection-master/Asthma Exacerbation Extraction';
    D_asthDATA = '/media/tmtb/LinuxDrive/matlab project/Asthma_Detection-master/Asthma Data'; %save 2min files
    
  
    
    D_MIMIC_II = '/media/tmtb/LinuxDrive/MIMIC II WAVEFORM DATABASE';
    D_patientFolder = '/media/tmtb/LinuxDrive/MIMIC II WAVEFORM DATABASE/RAW MIMIC II DATABASE';
    D_info='/media/tmtb/LinuxDrive/MIMIC II WAVEFORM DATABASE/RAW MIMIC II DATABASE/INFO';
    D_nRecords = '/media/tmtb/LinuxDrive/MIMIC II WAVEFORM DATABASE/RAW MIMIC II DATABASE/PRE_GENERATED RECORD';
    
    D_asthmaData = '/media/tmtb/LinuxDrive/MIMIC II WAVEFORM DATABASE/ASTHMA DATA';
    
    slash = '/';
    wfdb_toolbox = '/media/tmtb/LinuxDrive/matlab project/Asthma_TMTB/wfdb-app-toolbox-0-9-9/mcode/';
    addpath(wfdb_toolbox);
end;