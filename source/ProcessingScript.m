function [numerical_emg, analytical_emg, zero_emg, impulse] = ProcessingScript()
%% Processing Script - EMG 
% close all figures

%% Numerical
% initialise some filter properites
min_band = 10;
max_band = 450;
min_notch = 48;
max_notch = 52;

order = 10;
addpath('../data/')
[time_numerical, emg_numerical] = readViconEMGData('Standing_Numerical_18.txt');
fs = length(time_numerical)/time_numerical(end);
%isolate data
medial_vast = emg_numerical(:,1);
rectus_femoris = emg_numerical(:,2);
lateral_vast  = emg_numerical(:,3);
semitendon = emg_numerical(:,4);
noise = emg_numerical(:,5);
% filter data
[bandpass_emg_medial_vast] = bandPass(medial_vast,fs,order,min_band,max_band);
[notched_medial_vast] = notchFilter(bandpass_emg_medial_vast,fs,order,min_notch,max_notch);
rectified_medial_vast = rectifier(notched_medial_vast);

[bandpass_emg_rectus_femoris] = bandPass(rectus_femoris,fs,order,min_band,max_band);
[notched_rectus_femoris] = notchFilter(bandpass_emg_rectus_femoris,fs,order,min_notch,max_notch);
rectified_rectus_femoris = rectifier(notched_rectus_femoris);

[bandpass_emg_lateral_vast] = bandPass(lateral_vast,fs,order,min_band,max_band);
[notched_lateral_vast] = notchFilter(bandpass_emg_lateral_vast,fs,order,min_notch,max_notch);
rectified_lateral_vast = rectifier(notched_lateral_vast);

[bandpass_semitendon] = bandPass(semitendon,fs,order,min_band,max_band);
[notched_semitendon] = notchFilter(bandpass_semitendon,fs,order,min_notch,max_notch);
rectified_semitendon = rectifier(notched_semitendon);

[bandpass_noise] = bandPass(noise,fs,order,min_band,max_band);
[notched_noise] = notchFilter(bandpass_noise,fs,order,min_notch,max_notch);
rectified_noise = rectifier(notched_noise);
% uing impulse, find the data which triggered data collection by using the
% tcpip host- client. Impulse threshold set to 0.05 as that was tcp/ip
% client threshold

for  semitendon_index= 2:length(rectified_semitendon)
    if rectified_semitendon(semitendon_index) > 0.05
        disp(semitendon_index)
        break
    end
end
% calculate the mean for the impulses
impulse.semitendon_impulse = mean(rectified_semitendon(29076:30287));
impulse.medial_vast_impulse = mean(rectified_medial_vast(29076:29316));
impulse.rectus_femoris_impulse = mean(rectified_rectus_femoris(29076:29472));
impulse.lateral_vast_impulse = mean(rectified_medial_vast(29076:29772)); 

% From threshold point, isolate the remaining length of the data

rectified_medial_vast = rectified_medial_vast(semitendon_index:(semitendon_index +79999));
rectified_rectus_femoris = rectified_rectus_femoris(semitendon_index:(semitendon_index+79999));
rectified_lateral_vast = rectified_lateral_vast(semitendon_index:(semitendon_index+79999));
rectified_semitendon= rectified_semitendon(semitendon_index:(semitendon_index +79999));
rectified_noise= rectified_noise(semitendon_index:(semitendon_index +79999));
time_numerical = linspace(0,length(rectified_semitendon)*(1/fs),length(rectified_semitendon));

% Calculate the mean

numerical_emg.medial_vast.mean = mean(rectified_medial_vast);
numerical_emg.rectus_femoris.mean = mean(rectified_rectus_femoris);
numerical_emg.lateral_vast.mean = mean(rectified_lateral_vast);
numerical_emg.semitendon.mean = mean(rectified_semitendon);
numerical_emg.noise.mean = mean(rectified_noise);
 
% Calculate the Standard Deviation

numerical_emg.medial_vast.sd = std(rectified_medial_vast);
numerical_emg.rectus_femoris.sd = std(rectified_rectus_femoris);
numerical_emg.lateral_vast.sd = std(rectified_lateral_vast);
numerical_emg.semitendon.sd = std(rectified_semitendon);
numerical_emg.noise.sd = std(rectified_noise);

% Plot

vastus_medialis_numerical = figure(1);
plot(time_numerical,rectified_medial_vast, 'k')
title('Filtered And Rectified EMG During Numerical Experiment','Vastus Medialis Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])
% saveas(vastus_medialis_numerical,'../Numerical/vastus_medialis_numerical')
% saveas(vastus_medialis_numerical,'../Numerical/vastus_medialis_numerical.png')

rectus_femoris_numerical = figure(2);
plot(time_numerical,rectified_rectus_femoris, 'k')
title('Filtered And Rectified EMG During Numerical Experiment',' Rectus Femoris Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(rectus_femoris_numerical, '../Numerical/rectus_femoris_numerical.fig')
% saveas(rectus_femoris_numerical, '../Numerical/rectus_femoris_numerical.png')

vastus_lateralis_numerical = figure(3);
plot(time_numerical,rectified_lateral_vast, 'k')
title('Filtered And Rectified EMG During Numerical Experiment',' Vastus Lateralis Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(vastus_lateralis_numerical,'../Numerical/vastus_lateralis_numerical.png')
% saveas(vastus_lateralis_numerical,'../Numerical/vastus_lateralis_numerical.fig')

semitendon_numerical = figure(4);
plot(time_numerical,rectified_semitendon,'k')
title('Filtered And Rectified EMG During Numerical Experiment',' Semitendinosus Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(semitendon_numerical,'../Numerical/semitendon_numerical.fig')
% saveas(semitendon_numerical,'../Numerical/semitendon_numerical.png')

noise_numerical = figure(5);
plot(time_numerical,rectified_noise, 'k')
title('Filtered And Rectified EMG During Numerical Experiment',' Noise - Ankle Placement')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(noise_numerical,'../Numerical/noise_numerical.png')
% saveas(noise_numerical,'../Numerical/noise_numerical.fig')

%% Zero Torque

% Initialise Filter Properties
min_band = 20;
max_band = 400;
min_notch = 48;
max_notch = 52;

order = 10;
addpath('../data/')

% extract from .txt file
[time_numerical, emg_numerical] = readViconEMGData('Standing_ZeroTorques02.txt');
fs = length(time_numerical)/time_numerical(end);

%isolate data
medial_vast = emg_numerical(:,1);
rectus_femoris = emg_numerical(:,2);
lateral_vast  = emg_numerical(:,3);
semitendon = emg_numerical(:,4);
noise = emg_numerical(:,5);

% filter and rectify the data

[bandpass_emg_medial_vast] = bandPass(medial_vast,fs,order,min_band,max_band);
[notched_medial_vast] = notchFilter(bandpass_emg_medial_vast,fs,order,min_notch,max_notch);
rectified_medial_vast = rectifier(notched_medial_vast);

[bandpass_emg_rectus_femoris] = bandPass(rectus_femoris,fs,order,min_band,max_band);
[notched_rectus_femoris] = notchFilter(bandpass_emg_rectus_femoris,fs,order,min_notch,max_notch);
rectified_rectus_femoris = rectifier(notched_rectus_femoris);

[bandpass_emg_lateral_vast] = bandPass(lateral_vast,fs,order,min_band,max_band);
[notched_lateral_vast] = notchFilter(bandpass_emg_lateral_vast,fs,order,min_notch,max_notch);
rectified_lateral_vast = rectifier(notched_lateral_vast);

[bandpass_semitendon] = bandPass(semitendon,fs,order,min_band,max_band);
[notched_semitendon] = notchFilter(bandpass_semitendon,fs,order,min_notch,max_notch);
rectified_semitendon = rectifier(notched_semitendon);

[bandpass_noise] = bandPass(noise,fs,order,min_band,max_band);
[notched_noise] = notchFilter(bandpass_noise,fs,order,min_notch,max_notch);
rectified_noise = rectifier(notched_noise);
% uing impulse, find the data which triggered data collection by using the
% tcpip host- client

% find threshold
for  semitendon_index= 2:length(rectified_semitendon)
    if rectified_semitendon(semitendon_index) > 0.05 
        break
    end
end

% isolate experimental data from threshold
rectified_medial_vast = rectified_medial_vast(semitendon_index:(semitendon_index +79999));
rectified_rectus_femoris = rectified_rectus_femoris(semitendon_index:(semitendon_index+79999));
rectified_lateral_vast = rectified_lateral_vast(semitendon_index:(semitendon_index+79999));
rectified_semitendon= rectified_semitendon(semitendon_index:(semitendon_index +79999));
rectified_noise= rectified_noise(semitendon_index:(semitendon_index +79999));
time_numerical = linspace(0,length(rectified_semitendon)*(1/fs),length(rectified_semitendon));
%calculate mean
zero_emg.medial_vast.mean = mean(rectified_medial_vast);
zero_emg.rectus_femoris.mean = mean(rectified_rectus_femoris);
zero_emg.lateral_vast.mean = mean(rectified_lateral_vast);
zero_emg.semitendon.mean = mean(rectified_semitendon);
zero_emg.noise.mean = mean(rectified_noise);
% calculate standard deviation
zero_emg.medial_vast.sd = std(rectified_medial_vast);
zero_emg.rectus_femoris.sd = std(rectified_rectus_femoris);
zero_emg.lateral_vast.sd = std(rectified_lateral_vast);
zero_emg.semitendon.sd = std(rectified_semitendon);
zero_emg.noise.sd = std(rectified_noise);

%plot

vastus_medialis_zero = figure(1);
plot(time_numerical,rectified_medial_vast, 'k')
title('Filtered And Rectified EMG During Zero Applied Torques','Vastus Medialis Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(vastus_medialis_zero,'../Zero_torques/vastus_medialis_zero.fig')
% saveas(vastus_medialis_zero,'../Zero_torques/vastus_medialis_zero.png')

rectus_femoris_zero = figure(2);
plot(time_numerical,rectified_rectus_femoris, 'k')
title('Filtered And Rectified EMG During Zero Applied Torques',' Rectus Femoris Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(rectus_femoris_zero, '../Zero_torques/rectus_femoris_zero.fig')
% saveas(rectus_femoris_zero, '../Zero_torques/rectus_femoris_zero.png')

vastus_lateralis_zero= figure(3);
plot(time_numerical,rectified_lateral_vast, 'k')
title('Filtered And Rectified EMG During Zero Applied Torques',' Vastus Lateralis Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(vastus_lateralis_zero,'../Zero_torques/vastus_lateralis_zero.png')
% saveas(vastus_lateralis_zero,'../Zero_torques/vastus_lateralis_zero.fig')

semitendon_zero = figure(4);
plot(time_numerical,rectified_semitendon,'k')
title('Filtered And Rectified EMG During Zero Applied Torques', 'Semitendinosus Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(semitendon_zero,'../Zero_torques/semitendon_zero.fig')
% saveas(semitendon_zero,'../Zero_torques/semitendon_zeri.png')

noise_numerical = figure(5);
plot(time_numerical,rectified_noise, 'k')
title('Filtered And Rectified EMG During Zero Applied Torques',' Noise - Ankle Placement')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])
% saveas(noise_numerical,'../Zero_torques/noise_zero.png')
% saveas(noise_numerical,'../Zero_torques/noise_zero.fig')
%% Analytical

% initialise filter properties
min_band = 20;
max_band = 400;
min_notch = 48;
max_notch = 52;

order = 10;
addpath('../data/')

% extract data from .txt file
[time_numerical, emg_numerical] = readViconEMGData('Standing_Analytical01.txt');
fs = length(time_numerical)/time_numerical(end);

medial_vast = emg_numerical(:,1);
rectus_femoris = emg_numerical(:,2);
lateral_vast  = emg_numerical(:,3);
semitendon = emg_numerical(:,4);
noise = emg_numerical(:,5);
%filter
[bandpass_emg_medial_vast] = bandPass(medial_vast,fs,order,min_band,max_band);
[notched_medial_vast] = notchFilter(bandpass_emg_medial_vast,fs,order,min_notch,max_notch);
rectified_medial_vast = rectifier(notched_medial_vast);

[bandpass_emg_rectus_femoris] = bandPass(rectus_femoris,fs,order,min_band,max_band);
[notched_rectus_femoris] = notchFilter(bandpass_emg_rectus_femoris,fs,order,min_notch,max_notch);
rectified_rectus_femoris = rectifier(notched_rectus_femoris);

[bandpass_emg_lateral_vast] = bandPass(lateral_vast,fs,order,min_band,max_band);
[notched_lateral_vast] = notchFilter(bandpass_emg_lateral_vast,fs,order,min_notch,max_notch);
rectified_lateral_vast = rectifier(notched_lateral_vast);

[bandpass_semitendon] = bandPass(semitendon,fs,order,min_band,max_band);
[notched_semitendon] = notchFilter(bandpass_semitendon,fs,order,min_notch,max_notch);
rectified_semitendon = rectifier(notched_semitendon);

[bandpass_noise] = bandPass(noise,fs,order,min_band,max_band);
[notched_noise] = notchFilter(bandpass_noise,fs,order,min_notch,max_notch);
rectified_noise = rectifier(notched_noise);
% uing impulse, find the data which triggered data collection by using the
% tcpip host- client


for  semitendon_index= 2:length(rectified_semitendon)
    if rectified_semitendon(semitendon_index) > 0.06 
        break
    end
end
% extract all experimental data

rectified_medial_vast = rectified_medial_vast(semitendon_index:(semitendon_index +79999));
rectified_rectus_femoris = rectified_rectus_femoris(semitendon_index:(semitendon_index+79999));
rectified_lateral_vast = rectified_lateral_vast(semitendon_index:(semitendon_index+79999));
rectified_semitendon= rectified_semitendon(semitendon_index:(semitendon_index +79999));
rectified_noise= rectified_noise(semitendon_index:(semitendon_index +79999));
time_numerical = linspace(0,length(rectified_semitendon)*(1/fs),length(rectified_semitendon));

% calculate the mean
analytical_emg.medial_vast.mean = mean(rectified_medial_vast);
analytical_emg.rectus_femoris.mean = mean(rectified_rectus_femoris);
analytical_emg.lateral_vast.mean = mean(rectified_lateral_vast);
analytical_emg.semitendon.mean = mean(rectified_semitendon);
analytical_emg.noise.mean = mean(rectified_noise);
%calculate the standard deviation
analytical_emg.medial_vast.sd = std(rectified_medial_vast);
analytical_emg.rectus_femoris.sd = std(rectified_rectus_femoris);
analytical_emg.lateral_vast.sd = std(rectified_lateral_vast);
analytical_emg.semitendon.sd = std(rectified_semitendon);
analytical_emg.noise.sd = std(rectified_noise);
%plot
vastus_medialis_zero = figure(1);
plot(time_numerical,rectified_medial_vast, 'k')
title('Filtered And Rectified EMG During Analytical Method','Vastus Medialis Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(vastus_medialis_zero,'../Analytical/vastus_medialis_anal.fig')
% saveas(vastus_medialis_zero,'../Analytical/vastus_medialis_anal.png')

rectus_femoris_zero = figure(2);
plot(time_numerical,rectified_rectus_femoris, 'k')
title('Filtered And Rectified EMG During  Analytical Method',' Rectus Femoris Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(rectus_femoris_zero, '../Analytical/rectus_femoris_anal.fig')
% saveas(rectus_femoris_zero, '../Analytical/rectus_femoris_anal.png')

vastus_lateralis_zero= figure(3);
plot(time_numerical,rectified_lateral_vast, 'k')
title('Filtered And Rectified EMG During  Analytical Method',' Vastus Lateralis Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])
% 
% saveas(vastus_lateralis_zero,'../Analytical/vastus_lateralis_anal.png')
% saveas(vastus_lateralis_zero,'../Analytical/vastus_lateralis_anal.fig')

semitendon_zero = figure(4);
plot(time_numerical,rectified_semitendon,'k')
title('Filtered And Rectified EMG During  Analytical Method', 'Semitendinosus Muscle')
ylabel('Voltage (mV)')
xlabel('Time (s)')
ylim([ 0 0.4])

% saveas(semitendon_zero,'../Analytical/semitendon_anal.fig')
% saveas(semitendon_zero,'../Analytical/semitendon_anal.png')

noise_numerical = figure(5);
plot(time_numerical,rectified_noise, 'k')
title('Filtered And Rectified EMG During  Analytical Method',' Noise - Ankle Placement')
ylabel('Voltage (mV)')
xlabel('Time (s)')

ylim([ 0 0.4])
% saveas(noise_numerical,'../Analytical/noise_anal.png')
% saveas(noise_numerical,'../Analytical/noise_anal.fig')

end

