%%%%%%%%%%%%%%%%%%%%Configuring%%%%%%%%%%%%%%
clc;
clear all; close all;
addpath('/mnt/LinuxDrive/matlab project/Asthma_TMTB/m files');
run('Config.m');

cd(D_2min);
startindex=3;endindex=179;
PatientList = dir;
PatientList = {PatientList.name}';
mkdir(strcat(D_asthDATA, slash, 'Result'));

for t = startindex : endindex
    %     clear all;
    load(PatientList{t});
    
    record_name = char(recHRV(t, 1));
    patient_name = record_name(1:6);
    
    %%create file
    
    output = strcat(D_asthDATA, slash, 'Result', slash, patient_name, '.csv');
    FILE = fopen(output, 'w');
    firstline = ['Record Name \t Window \t Dimension \t Time delay \t Epsilon \t ',...
        'Recurrence rate \t Determinism \t  Averaged diagonal length \t ', ...
        'Length of longest diagonal line \t Entropy of diagonal length \t ',...
        'Laminarity \t Trapping time \t Length of longest vertical line \t ',...
        'Recurrence time of 1st type \t Recurrence time of 2nd type \t ',...
        'Recurrence period density entropy \t Clustering coefficient \t ',...
        'Transitivity \n'];
    fprintf(FILE,firstline,'\n');
    fclose(FILE);
    
    for idxptlist = 2 : size(recHRV, 1)
        data1 = recHRV(idxptlist, 2);
        data1 = data1{1,1};
        
        for wderr = 2 : size(data1, 1)
            data = data1(wderr, 2);
            data = data{1,1};
            
            if isempty(data)
                FILE = fopen(output, 'a');
                fprintf(FILE, '%s \t', record_name);
                fprintf(FILE, '\n');
                fclose(FILE);
            else  run RP_Asthma.m
            end
        end
        
    end
    
end
