%%%%%%%%%%%%%%%%%%%%Configuring%%%%%%%%%%%%%%
clc;
clear variables;
close all;
addpath('/mnt/LinuxDrive/matlab project/Asthma_TMTB/m files');
run Config.m;

cd(D_2min);

PatientList = dir;
PatientList = {PatientList.name}';
startindex=3;
endindex=size(PatientList,1);
%

for t = startindex : endindex
    
    data = load(PatientList{t});
    
    tmp1 = char(PatientList{t});
    patient_name = tmp1(1:6);
    
    %create file
    
    mkdir(strcat(D_asthDATA, slash, 'HRV_Figure', slash, patient_name));
    mkdir(strcat(D_asthDATA, slash, 'Result', slash, patient_name));
    output = strcat(D_asthDATA, slash, 'Result', slash, patient_name, '.csv');
    
    if (exist(output, 'file') == 2)
        iswrite = 'a';
    else iswrite = 'w';
    end;
    FILE = fopen(output, iswrite);
    firstline = ['Record Name \t Window \t Data size \t Dimension \t Time delay \t Threshold \t ',...
        'Recurrence rate \t Determinism \t  Averaged diagonal length \t ', ...
        'Length of longest diagonal line \t Entropy of diagonal length \t ',...
        'Laminarity \t Trapping time \t Length of longest vertical line \t ',...
        'Recurrence time of 1st type \t Recurrence time of 2nd type \t ',...
        'Recurrence period density entropy \t Clustering coefficient \t ',...
        'Transitivity \n'];
    fprintf(FILE,firstline,'\n');
    fclose(FILE);
    
    fprintf('\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('Testing on patient                            %s\n', patient_name);
    
    wderr = str2double(tmp1(19:20));
    
    fprintf('-- Record: %s - Window %d\n', record_name,wderr);
    run RP_Asthma.m
end
