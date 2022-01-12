%% Create Matrix to Store Data
% Analytical = column 1
% numerical = column 2 
% zero - torque = column 3
my_data_hip = ones(4,4);
my_data_hip(1,1) = -3530;
my_data_hip(2,1) = -3535;
my_data_hip(3,1) = 3530;
my_data_hip(4,1) = 3535;
my_data_knee= ones(4,4);
my_data_knee(1,1) = -3530;
my_data_knee(2,1) = -3535;
my_data_knee(3,1) = 3530;
my_data_knee(4,1) = 353
%% Process EMG Data
[numerical_emg, analytical_emg, zero_emg, impulse] = ProcessingScript;
%% Plot Analytical
% clear
% clc

load('analytical_data.mat')
fs = 0.01;
%calculate time and create time vector
time = length(Q_hip_stored.right)*fs;
time_array = linspace(0,time,length(Q_hip_stored.right));
% convert from radians to degree. Minus one is to make opensim and exo-h3
% data the same
hip_angle = rad2deg(Q_hip_stored.right);
knee_angle = rad2deg(Q_knee_stored.right)*-1;

analytical_fig_hip = figure(1);
plot(time_array,hip_angle,'k')
xlabel('Time (seconds)')
ylabel('Joint Angle (degrees)')
title('Hip Angle During Analytical Experiment')
% saveas(analytical_fig_hip,'../Angle_Data/analytical_hip.fig')
% saveas(analytical_fig_hip,'../Angle_Data/analytical_hip.png')
analytical_fig_knee = figure(2);
plot(time_array,knee_angle,'k')
xlabel('Time (seconds)')
ylabel('Joint Angle (degrees)')
title('Knee Angle During Analytical Experiment')
% saveas(analytical_fig_knee,'../Angle_Data/analytical_knee.fig')
% saveas(analytical_fig_knee,'../Angle_Data/analytical_knee.png')

% plot on joint plot
joint_plot_hip = figure(7); 
hold on
plot(time_array,hip_angle,'k')
joint_plot_knee = figure(8)
hold on
plot(time_array, knee_angle,'k')
hip_angle = deg2rad(hip_angle);
knee_angle = deg2rad(knee_angle);

% isolate three second interval where gravity compensation is applied

neg_thirty_five_thirty_five_hip = hip_angle(2701:3000);
neg_thirty_five_thirty_hip = hip_angle(3701:4000);

thirty_five_thirty_five_hip = hip_angle(4701:5000);
thirty_five_thirty_hip = hip_angle(5701:6000);

neg_thirty_five_thirty_five_knee = knee_angle(2701:3000);
neg_thirty_five_thirty_knee = knee_angle(3701:4000);

thirty_five_thirty_five_knee = knee_angle(4701:5000);
thirty_five_thirty_knee = knee_angle(5701:6000);
%calculate average velocities for the hip 
neg_thirty_five_thirty_five_velocity_hip = (neg_thirty_five_thirty_five_hip(end) -neg_thirty_five_thirty_five_hip(1))/(length(neg_thirty_five_thirty_five_hip)*fs)
neg_thirty_five_thirty_velocity_hip = (neg_thirty_five_thirty_hip(end) -neg_thirty_five_thirty_hip(1))/(length(neg_thirty_five_thirty_hip)*fs)
my_data_hip(1,2) = neg_thirty_five_thirty_velocity_hip;
my_data_hip(2,2) = neg_thirty_five_thirty_five_velocity_hip;
thirty_five_thirty_five_velocity_hip = (thirty_five_thirty_five_hip(end) -thirty_five_thirty_five_hip(1))/(length(thirty_five_thirty_five_hip)*fs)
thirty_five_thirty_velocity_hip = (thirty_five_thirty_hip(end) -thirty_five_thirty_hip(1))/(length(thirty_five_thirty_hip)*fs)
my_data_hip(3,2) = thirty_five_thirty_velocity_hip;
my_data_hip(4,2) = thirty_five_thirty_five_velocity_hip;
% calculate average velocities for the knee
neg_thirty_five_thirty_five_velocity_knee = (neg_thirty_five_thirty_five_knee(end) -neg_thirty_five_thirty_five_knee(1))/(length(neg_thirty_five_thirty_five_knee)*fs)
neg_thirty_five_thirty_velocity_knee = (neg_thirty_five_thirty_knee(end) -neg_thirty_five_thirty_knee(1))/(length(neg_thirty_five_thirty_knee)*fs)
my_data_knee(1,2) = neg_thirty_five_thirty_velocity_knee;
my_data_knee(2,2) = neg_thirty_five_thirty_five_velocity_knee;
thirty_five_thirty_five_velocity_knee = (thirty_five_thirty_five_knee(end) -thirty_five_thirty_five_knee(1))/(length(thirty_five_thirty_five_knee)*fs)
thirty_five_thirty_velocity_knee = (thirty_five_thirty_knee(end) -thirty_five_thirty_knee(1))/(length(thirty_five_thirty_knee)*fs)
my_data_knee(3,2) = thirty_five_thirty_velocity_knee;
my_data_knee(4,2) = thirty_five_thirty_five_velocity_knee;
%% Plot Numerical
% clear
% clc
load('numerical_data.mat')
fs = 0.01;
% calculate time and create time vector
time = length(hip_angles_stored.right)*fs;
time_array = linspace(0,time,length(hip_angles_stored.right));
% isolate data, already in degrees
hip_angle = hip_angles_stored.right;
knee_angle = knee_angles_stored.right;
%plot
numerical_fig_hip = figure(3);
plot(time_array,hip_angle,'r')
xlabel('Time (seconds)')
ylabel('Joint Angle (degrees)')
title('Hip Angle During Numerical Experiment')
saveas(numerical_fig_hip,'../Angle_Data/numerical_hip.fig')
saveas(numerical_fig_hip,'../Angle_Data/numerical_hip.png')
numerical_fig_knee = figure(4);
plot(time_array, knee_angle, 'r')
xlabel('Time (seconds)')
ylabel('Joint Angle (degrees)')
title('Knee Angle During Numerical Experiment')
saveas(numerical_fig_knee,'../Angle_Data/numerical_knee.fig')
saveas(numerical_fig_knee,'../Angle_Data/numerical_knee.png')
%plot on joint plot

figure(7)
hold on
plot(time_array,hip_angle,'r')
figure(8)
hold on
plot(time_array, knee_angle,'r')
% convert to radians and isolate three second interval where grav comp
% applied
hip_angle = deg2rad(hip_angle);
knee_angle = deg2rad(knee_angle);
neg_thirty_five_thirty_five_hip = hip_angle(201:500);
neg_thirty_five_thirty_hip = hip_angle(1201:1500);

thirty_five_thirty_five_hip = hip_angle(6201:6400);
thirty_five_thirty_hip = hip_angle(7201:7500);
neg_thirty_five_thirty_five_knee = knee_angle(201:328);
neg_thirty_five_thirty_knee = knee_angle(1201:1321);

thirty_five_thirty_five_knee = knee_angle(6201:6310);
thirty_five_thirty_knee = knee_angle(7201:7434);
% calculate average velocity
neg_thirty_five_thirty_five_velocity_hip = (neg_thirty_five_thirty_five_hip(end) -neg_thirty_five_thirty_five_hip(1))/(length(neg_thirty_five_thirty_five_hip)*fs)
neg_thirty_five_thirty_velocity_hip = (neg_thirty_five_thirty_hip(end) -neg_thirty_five_thirty_hip(1))/(length(neg_thirty_five_thirty_hip)*fs)
my_data_hip(1,3) = neg_thirty_five_thirty_velocity_hip;
my_data_hip(2,3) = neg_thirty_five_thirty_five_velocity_hip;
thirty_five_thirty_five_velocity_hip = (thirty_five_thirty_five_hip(end) -thirty_five_thirty_five_hip(1))/(length(thirty_five_thirty_five_hip)*fs)
thirty_five_thirty_velocity_hip = (thirty_five_thirty_hip(end) -thirty_five_thirty_hip(1))/(length(thirty_five_thirty_hip)*fs)
my_data_hip(3,3) = thirty_five_thirty_velocity_hip;
my_data_hip(4,3) = thirty_five_thirty_five_velocity_hip;
% calculate average velocity
neg_thirty_five_thirty_five_velocity_knee = (neg_thirty_five_thirty_five_knee(end) -neg_thirty_five_thirty_five_knee(1))/(length(neg_thirty_five_thirty_five_knee)*fs)
neg_thirty_five_thirty_velocity_knee = (neg_thirty_five_thirty_knee(end) -neg_thirty_five_thirty_knee(1))/(length(neg_thirty_five_thirty_knee)*fs)
my_data_knee(1,3) = neg_thirty_five_thirty_velocity_knee;
my_data_knee(2,3) = neg_thirty_five_thirty_five_velocity_knee;
thirty_five_thirty_five_velocity_knee = (thirty_five_thirty_five_knee(end) -thirty_five_thirty_five_knee(1))/(length(thirty_five_thirty_five_knee)*fs)
thirty_five_thirty_velocity_knee = (thirty_five_thirty_knee(end) -thirty_five_thirty_knee(1))/(length(thirty_five_thirty_knee)*fs)
my_data_knee(3,3) = thirty_five_thirty_velocity_knee;
my_data_knee(4,3) = thirty_five_thirty_five_velocity_knee;

%% Plot Zero Torques
% clear
% clc
load('zero_torque_data.mat')
fs = 0.01;
% calculate time and create vector
time = length(Q_hip_stored.right)*fs;
time_array = linspace(0,time,length(Q_hip_stored.right));
% convert to radians and isolate data. Minus one is to make opensim and
% exo-h3 notation the same
hip_angle = rad2deg(Q_hip_stored.right);
knee_angle = rad2deg(Q_knee_stored.right)*-1;
% plot
zero_torque_fig_hip = figure(5);
plot(time_array,hip_angle,'c')
xlabel('Time (seconds)')
ylabel('Joint Angle (degrees)')
title('Hip Angle With Zero Torques Applied')
% saveas(zero_torque_fig_hip,'../Angle_Data/zero_torque_hip.fig')
% saveas(zero_torque_fig_hip,'../Angle_Data/zero_torque_hip.png')

zero_torque_knee = figure(6);
plot(time_array,knee_angle,'c')
xlabel('Time (seconds)')
ylabel('Joint Angle (degrees)')
title('Knee Angle With Zero Torques Applied')
% saveas(zero_torque_knee,'../Angle_Data/zero_torque_knee.fig')
% saveas(zero_torque_knee,'../Angle_Data/zero_torque_knee.png')
% plot on joint plot
figure(7) 
hold on
plot(time_array,hip_angle,'c')
figure(8)
hold on
plot(time_array, knee_angle,'c')
% convert to radians and isolate three seconds where measurement required
hip_angle = deg2rad(hip_angle);
knee_angle = deg2rad(knee_angle);
neg_thirty_five_thirty_five_hip = hip_angle(2701:2746);
neg_thirty_five_thirty_hip = hip_angle(3701:3751);

thirty_five_thirty_five_hip = hip_angle(4701:4819);
thirty_five_thirty_hip = hip_angle(4701:4766);

neg_thirty_five_thirty_five_knee = knee_angle(2701:2785);
neg_thirty_five_thirty_knee = knee_angle(3701:3760);

thirty_five_thirty_five_knee = knee_angle(4701:4747);
thirty_five_thirty_knee = knee_angle(5701:5746);
%calculate velocities
neg_thirty_five_thirty_five_velocity_hip = (neg_thirty_five_thirty_five_hip(end) -neg_thirty_five_thirty_five_hip(1))/(length(neg_thirty_five_thirty_five_hip)*fs)
neg_thirty_five_thirty_velocity_hip = (neg_thirty_five_thirty_hip(end) -neg_thirty_five_thirty_hip(1))/(length(neg_thirty_five_thirty_hip)*fs)
my_data_hip(1,4) = neg_thirty_five_thirty_velocity_hip;
my_data_hip(2,4) = neg_thirty_five_thirty_five_velocity_hip;
thirty_five_thirty_five_velocity_hip = (thirty_five_thirty_five_hip(end) -thirty_five_thirty_five_hip(1))/(length(thirty_five_thirty_five_hip)*fs)
thirty_five_thirty_velocity_hip = (thirty_five_thirty_hip(end) -thirty_five_thirty_hip(1))/(length(thirty_five_thirty_hip)*fs)
my_data_hip(3,4) = thirty_five_thirty_velocity_hip;
my_data_hip(4,4) = thirty_five_thirty_five_velocity_hip;

neg_thirty_five_thirty_five_velocity_knee = (neg_thirty_five_thirty_five_knee(end) -neg_thirty_five_thirty_five_knee(1))/(length(neg_thirty_five_thirty_five_knee)*fs)
neg_thirty_five_thirty_velocity_knee = (neg_thirty_five_thirty_knee(end) -neg_thirty_five_thirty_knee(1))/(length(neg_thirty_five_thirty_knee)*fs)
my_data_knee(1,4) = neg_thirty_five_thirty_velocity_knee;
my_data_knee(2,4) = neg_thirty_five_thirty_five_velocity_knee;
thirty_five_thirty_five_velocity_knee = (thirty_five_thirty_five_knee(end) -thirty_five_thirty_five_knee(1))/(length(thirty_five_thirty_five_knee)*fs)
thirty_five_thirty_velocity_knee = (thirty_five_thirty_knee(end) -thirty_five_thirty_knee(1))/(length(thirty_five_thirty_knee)*fs)
my_data_knee(3,4) = thirty_five_thirty_velocity_knee;
my_data_knee(4,4) = thirty_five_thirty_five_velocity_knee;
%% Joint Position Plot 
% label the plots
joint_plot_hip= figure(7); 
hold on
% plot(time_array,hip_angle,'k')
% plot(time_array,hip_angle,'r')
% plot(time_array,hip_angle,'b')
xlabel('Time (seconds)')
ylabel('Joint Angle (degrees)')
title('Hip Angle During Numerical, Analytical and Zero Torque Experiments')
lgd = legend('Analytical','Numerical','Zero Applied Torque');
lgd.FontSize = 8;
legend('boxoff')
lgd.Location = 'northwest';
% saveas(joint_plot_hip,'../Angle_Data/all_methods_hip.fig');
% saveas(joint_plot_hip,'../Angle_Data/all_methods_hip.png');
joint_plot_knee= figure(8); 
hold on
% plot(time_array,hip_angle,'k')
% plot(time_array,hip_angle,'r')
% plot(time_array,hip_angle,'b')
xlabel('Time (seconds)')
ylabel('Joint Angle (degrees)')
title('Knee Angle During Numerical, Analytical and Zero Torque Experiments')
ylim([-5 45])
lgd= legend('Analytical','Numerical','Zero Applied Torque');
lgd.FontSize = 8;
lgd.Location = 'northwest';
legend('boxoff')
% saveas(joint_plot_knee,'../Angle_Data/all_methods_knee.fig');
% saveas(joint_plot_knee,'../Angle_Data/all_methods_knee.png');
%% Plot Table
% create table with standard deviation, mean and normalised mean
normalised_medial_analytical = (analytical_emg.medial_vast.mean/impulse.medial_vast_impulse)*100;
normalised_lateral_analytical = (analytical_emg.lateral_vast.mean/impulse.lateral_vast_impulse)*100;
normalised_rectus_analytical = (analytical_emg.rectus_femoris.mean/impulse.rectus_femoris_impulse)*100;
normalised_semitendon_analytical = (analytical_emg.semitendon.mean/impulse.semitendon_impulse)*100;

normalised_medial_numerical = (numerical_emg.medial_vast.mean/impulse.medial_vast_impulse)*100;
normalised_lateral_numerical = (numerical_emg.lateral_vast.mean/impulse.lateral_vast_impulse)*100;
normalised_rectus_numerical= (numerical_emg.rectus_femoris.mean/impulse.rectus_femoris_impulse)*100;
normalised_semitendon_numerical= (numerical_emg.semitendon.mean/impulse.semitendon_impulse)*100;

col = {'Mean (mV)', 'Percentage Mean (%)','Standard Deviation (mV)'};
row = {'Zero Torque - Medial Vast','Zero Torque - Lateral Vast','Zero Torque - Rectus Femoris', ...
    'Zero Torque - Semitendon','Numerical - Medial Vast','Numerical - Lateral Vast','Numerical - Rectus Femoris', ...
    'Numerical - Semitendon'};
% create plot wiht error bars
mean_bar = [analytical_emg.medial_vast.mean numerical_emg.medial_vast.mean zero_emg.medial_vast.mean;
    analytical_emg.lateral_vast.mean numerical_emg.lateral_vast.mean zero_emg.lateral_vast.mean;
    analytical_emg.rectus_femoris.mean numerical_emg.rectus_femoris.mean zero_emg.rectus_femoris.mean;
    analytical_emg.semitendon.mean numerical_emg.semitendon.mean zero_emg.semitendon.mean]
x_labels = {'Vastus Medialis';'Vastus Lateralis';'Rectus Femoris';'Semitendinosus'}
% errhigh = [analytical_emg.medial_vast.sd numeric
errlow = [analytical_emg.medial_vast.sd numerical_emg.medial_vast.sd;
        analytical_emg.lateral_vast.sd numerical_emg.lateral_vast.sd;
    analytical_emg.rectus_femoris.sd numerical_emg.rectus_femoris.sd;
    analytical_emg.semitendon.sd numerical_emg.semitendon.sd];
erran = [analytical_emg.medial_vast.sd analytical_emg.lateral_vast.sd analytical_emg.rectus_femoris.sd analytical_emg.semitendon.sd ]
errnum =  [numerical_emg.medial_vast.sd numerical_emg.lateral_vast.sd numerical_emg.rectus_femoris.sd numerical_emg.semitendon.sd ]
errzero = [zero_emg.medial_vast.sd zero_emg.lateral_vast.sd zero_emg.rectus_femoris.sd zero_emg.semitendon.sd ]

Ect_type = [erran; errnum; errzero]'; 
Ect_type = [analytical_emg.medial_vast.sd numerical_emg.medial_vast.sd zero_emg.medial_vast.sd;
    analytical_emg.lateral_vast.sd  numerical_emg.lateral_vast.sd zero_emg.lateral_vast.sd;
   analytical_emg.rectus_femoris.sd numerical_emg.rectus_femoris.sd zero_emg.rectus_femoris.sd;
   analytical_emg.semitendon.sd numerical_emg.semitendon.sd  zero_emg.semitendon.sd ];
x = [ 1 2 3 4;
    1 2 3 4;
    1 2 3 4]'
emg_bar = figure(12)
hBar = bar(x,mean_bar)
hold on

hold on
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(mean_bar);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, mean_bar(:,i), Ect_type(:,i), 'k', 'linestyle', 'none');
end
hold off

% er = errorbar(x, mean_bar, Ect_type, '.k','MarkerSize',1);
% legend()
set(gca,'xticklabel',x_labels)
ylabel('Mean EMG (mV)')
lgd = legend('Analytical Method','Numerical Method', 'Zero Torques (Transparent)');
lgd.FontSize = 8;
lgd.Location = 'northwest';
title('Mean EMG Signal For Different Muscle Groups')

hold on
% er = errorbar(x,mean_bar,errlow)
saveas(emg_bar,'../Angle_Data/EMG/comparison.fig')
saveas(emg_bar,'../Angle_Data/EMG/comparison.png')

Percent= {normalised_medial_analytical; normalised_lateral_analytical;normalised_rectus_analytical; normalised_semitendon_analytical; normalised_medial_numerical;normalised_lateral_numerical;  normalised_rectus_numerical; normalised_semitendon_numerical};
Impulse = {analytical_emg.medial_vast.sd; analytical_emg.lateral_vast.sd;analytical_emg.rectus_femoris.sd;analytical_emg.semitendon.sd;numerical_emg.medial_vast.sd;numerical_emg.lateral_vast.sd; numerical_emg.rectus_femoris.sd; numerical_emg.semitendon.sd};

T = table(Means,Percent,Impulse,'RowNames',row,'VariableNames',col);
figure(11)
my_table = uitable('Data',T{:,:},'ColumnName',col,...
    'RowName',row,'Units', 'Normalized', 'Position',[0,0,1,1]);
% T.Properties.DimensionNames{1} = 'Mean (mV)';
% T.Properties.DimensionNames{2} ='Percentage Mean (%)';
% T.Properties.DimensionNames{2} ='Standard Deviation (mV)';

 
%% Joint Bar Graph
hip_bar = figure(9);

x_labels = {'[-35,30,-10]';'[-35, 35, -10]';'[35, 30, 10]';'[35, 35, 10]'};
x = [1:4]; 
y = [my_data_hip(1,2) my_data_hip(1,3) my_data_hip(1,4);
    my_data_hip(2,2) my_data_hip(2,3) my_data_hip(2,4);
    my_data_hip(3,2) my_data_hip(3,3) my_data_hip(3,4);
    my_data_hip(4,2) my_data_hip(4,3) my_data_hip(4,4)];
bar(y,'stacked')
set(gca,'xticklabel',x_labels)
ylabel('Hip Joint Veloctiy (rad s^{-1})')
lgd = legend('Analytical Method','Numerical Method','Zero Torques');
lgd.FontSize = 8;
legend('boxoff')
xlabel({'Joint Angle Vector (degrees)'})
title('Average Hip Joint Velocity With Varying Methods Of Gravity Compensation','Data Over a Period Of 3 Seconds Or Until Joint Angle Stabilises')
% saveas(hip_bar,'../Angle_Data/hip_bar_comparison.fig')
% saveas(hip_bar,'../Angle_Data/hip_bar_comparison.png')
knee_bar = figure(10);
x_labels = {'[-35,30,10]';'[-35, 35, 10]';'[35, 30, 10]';'[35, 35, 10]'};
x = [1:4];
y = [my_data_knee(1,2) my_data_knee(1,3) my_data_knee(1,4);
    my_data_knee(2,2) my_data_knee(2,3) my_data_knee(2,4);
    my_data_knee(3,2) my_data_knee(3,3) my_data_knee(3,4);
    my_data_knee(4,2) my_data_knee(4,3) my_data_knee(4,4)];
bar(y,'stacked')
set(gca,'xticklabel',x_labels)
ylabel('Knee Joint Veloctiy (rad s^{-1})')
ylim([-1.6 0])
lgd = legend('Analytical Method','Numerical Method','Zero Torques');
lgd.FontSize = 8;
lgd.Location = 'southwest';
legend('boxoff')
xlabel({'Joint Angle Vector (degrees)'})
title('Average Knee Joint Velocity With Varying Methods Of Gravity Compensation','Data Over a Period Of 3 Seconds Or Until Joint Angle Stabilises')
% saveas(knee_bar,'../Angle_Data/knee_bar_comparison.fig')
% saveas(knee_bar,'../Angle_Data/knee_bar_comparison.png')