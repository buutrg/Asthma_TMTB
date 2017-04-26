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
endindex=size(PatientList,1) - 2;


for t = startindex : endindex
    %     clear all;
    load(PatientList{t});
    
<<<<<<< HEAD
    tmp1 = char(PatientList{t});
    patient_name = tmp1(5:10);
    
    %%create file
    
    mkdir(strcat(D_asthDATA, slash, 'HRV_Figure', slash, patient_name));
    mkdir(strcat(D_asthDATA, slash, 'Result', slash, patient_name));
    output = strcat(D_asthDATA, slash, 'Result', slash, patient_name, slash, tmp1, '.csv');
=======
    record_name = char(recHRV(t, 1));
    patient_name = record_name(1:6);
    
    %%create file
    
    output = strcat(D_asthDATA, slash, 'Result', slash, patient_name, '.csv');
>>>>>>> 0b3ea19ac3d94282e30f2fb9f4429a276a928103
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
    
<<<<<<< HEAD
    fprintf('\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('Testing on patient                            %s\n', patient_name);
    
    
    for idxptlist = 2 : size(recHRV, 1)
        data1 = recHRV{idxptlist, 2};
        record_name = char(recHRV(idxptlist, 1));
        data2 = [];
        
        for wderr = 2 : size(data1, 1)
            data = data1{wderr, 2};
            
            fprintf('-- Record: %s - Window %d\n', record_name,wderr-1);
=======
    for idxptlist = 2 : size(recHRV, 1)
        data1 = recHRV(idxptlist, 2);
        data1 = data1{1,1};
        
        for wderr = 2 : size(data1, 1)
            data = data1(wderr, 2);
            data = data{1,1};
            
>>>>>>> 0b3ea19ac3d94282e30f2fb9f4429a276a928103
            if isempty(data)
                FILE = fopen(output, 'a');
                fprintf(FILE, '%s \t', record_name);
                fprintf(FILE, '\n');
                fclose(FILE);

            else  run RP_Asthma.m
            end
        end
        
    end
<<<<<<< HEAD
=======
    
>>>>>>> 0b3ea19ac3d94282e30f2fb9f4429a276a928103
end
