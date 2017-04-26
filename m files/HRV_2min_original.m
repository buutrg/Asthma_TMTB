%%%%%%%%%%%%%%%%%%%%Configuring%%%%%%%%%%%%%%
clc;
% clear variables;
close all;
addpath('/mnt/LinuxDrive/matlab project/Asthma_TMTB/m files');
run Config.m;
addpath(CRP_tools);

cd(D_2min);

PatientList = dir;
PatientList = {PatientList.name}';
startindex=;
endindex=size(PatientList,1);
%

for t = startindex : endindex
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    data = load(PatientList{t});
    
    record_name = char(PatientList{t});
    patient_name = record_name(1:6);
    wderr = record_name(19:20);
    
    %create file
    
    mkdir(strcat(D_asthDATA, slash, 'HRV_Figure', slash, patient_name));
    mkdir(strcat(D_asthDATA, slash, 'Result', slash, patient_name));
    mkdir(strcat(D_asthDATA, slash, 'Recurrence Plot', slash, patient_name));
    output = strcat(D_asthDATA, slash, 'Result', slash, patient_name, '.csv');
    
    if (exist(output, 'file') ~= 2)
        
        FILE = fopen(output, 'w');
        firstline = ['Record Name \t Window \t Number of samples \t Severity \t Dimension \t Time delay \t Threshold \t ',...
            'Recurrence rate \t Determinism \t  Averaged diagonal length \t ', ...
            'Length of longest diagonal line \t Entropy of diagonal length \t ',...
            'Laminarity \t Trapping time \t Length of longest vertical line \t ',...
            'Recurrence time of 1st type \t Recurrence time of 2nd type \t ',...
            'Recurrence period density entropy \t Clustering coefficient \t ',...
            'Transitivity \n'];
        fprintf(FILE,firstline,'\n');
        fclose(FILE);
    end;
    fprintf('\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('Patient No.                        %s\n', patient_name);
    
    fprintf('-- Record: %s - Window %s\n', record_name,wderr);
    %     if isempty(data)
    %         FILE = fopen(output, 'a');
    %         fprintf(FILE, '%s \t', record_name);
    %         fprintf(FILE, '\n');
    %         fclose(FILE);
    %     else
    %         run RP_Asthma.m
    %     end
    run RP_Asthma.m
    
end
