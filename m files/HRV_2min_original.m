%%%%%%%%%%%%%%%%%%%%Configuring%%%%%%%%%%%%%%
clc;
% clear variables;
close all;
addpath('/mnt/LinuxDrive/matlab project/Asthma_TMTB/m files');
run Config.m;
addpath(CRP_tools);

cd(D_2min);

PatientList = dir;
PatientList = {PatientList.name}.';
startindex=4;
endindex=size(PatientList,1);

%% List index of patients' name
names = [];

for i = 4 : size(PatientList, 1)
    xx = PatientList{i}(1:6);
    yy = PatientList{i-1}(1:6);
    if (~strcmp(xx,yy))
        names = [names i];
    end;
end

names = [names size(PatientList, 1)];

tmp = diff(names);
[names1, Index] = sort(tmp);

%% Processing
for ptn_tmp = 2 : size(names, 2)-1
    
    ptn = Index(ptn_tmp);
    patient_name = PatientList{names(ptn)}(1:6);
    
    mkdir(strcat(D_asthDATA, slash, 'HRV_Figure', slash, patient_name));
    mkdir(strcat(D_asthDATA, slash, 'Result', slash, patient_name));
    mkdir(strcat(D_asthDATA, slash, 'Recurrence Plot', slash, patient_name));
    
    output = strcat(D_asthDATA, slash, 'Result', slash, patient_name, '.csv');
    error_output = strcat(D_asthDATA, slash, 'Result', slash, 'ERROR', '.txt');
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
    
    
    
    %% Run RP
    for t = names(ptn) : names(ptn+1)
        %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        data = load(PatientList{t});
        
        record_name = char(PatientList{t});
        wderr = record_name(19:20);
        
        fprintf('-- Record: %s - Window %s\n', record_name,wderr);
        
        try
            run RP_Asthma.m
        catch
            FILE = fopen(error_output, 'a');
            fprintf(FILE, '%s \n', record_name);
            fclose(FILE);
        end
        
    end
end
