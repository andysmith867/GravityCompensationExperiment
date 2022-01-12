function [emg_data_band] = bandPass(emg_data_og, fs, order, min_band, max_band)
bandPass = designfilt('bandpassfir','FilterOrder',order,'CutoffFrequency1'...
    ,min_band,'CutoffFrequency2',max_band,'SampleRate',fs);% plot
emg_data_band = filter(bandPass, emg_data_og);
end