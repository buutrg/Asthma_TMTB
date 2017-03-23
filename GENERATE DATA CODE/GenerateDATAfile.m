

try load(tempDATAname)
catch
    disp('Cant find section .mat');
    disp('Generating .mat from original record...');
    cd(D_recordFolder);
        try
            [m_t0,m_val,m_fs] = rdsamp(recordName,sig_choose,N,N0);
        catch          
            disp('Error in offline data, downloading ...');
            try
            [m_t0,m_val,m_fs] = rdsamp(L_alternateDownload,sig_choose,N,N0);
            disp('Download completed');
            catch
                disp('ERROR !!!!!');
                ErrorDATA(m_section,1) = {'Download DATA error'};
            end
        end
            m_t0 = m_t0';
            m_val = m_val';
            m_fs = m_fs(1);
            
m_II = NaN(1,length(m_t0));
m_PLETH = NaN(1,length(m_t0));
try
m_II = m_val(1,:); 
m_PLETH = m_val(2,:);
catch
    ErrorDATA(m_section,1) = {'No ECG or PPG available'};
end

end