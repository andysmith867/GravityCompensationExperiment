function [emg_data_rectified] = rectifier(emg_data_filtered)
for i = 1:length(emg_data_filtered)
    if emg_data_filtered(i) < 0
        emg_data_filtered(i) = emg_data_filtered(i)*-1;
       
    end
end
emg_data_rectified = emg_data_filtered;
end
