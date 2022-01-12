%% Interpolated Points Vs Non - Interpolated Points Comparison 
% Non-interpolated points [30, 30, 0]
%interpolated point [35, 35, -10]
% stationary for > 0.5 sec = plateau
load('numerical_data.mat')
fs = 0.01;
hip_angles = deg2rad(hip_angles_stored.right);
knee_angles = deg2rad(knee_angles_stored.right);
ankle_angles =deg2rad(ankle_angles_stored.right);
non_interp_hip = hip_angles(:,3700:4000);
interp_hip = hip_angles(:, 6200:6400);
non_interp_knee = knee_angles(:,3700:3840);
interp_knee = knee_angles(:,6200:6312);

% plot(non_interp)
% plot(interp)
velocity_non_interp_hip = (non_interp_hip(end) - non_interp_hip(1)) / (length(non_interp_hip)*fs)
velocity_interp_hip = (interp_hip(end) - interp_hip(1)) / (length(interp_hip)*fs)

velocity_non_interp_knee = (non_interp_knee(end) - non_interp_knee(1)) / (length(non_interp_knee)*fs)
velocity_interp_knee = (interp_knee(end) - interp_knee(1)) / (length(interp_knee)*fs)

velocity_diff_hip = velocity_non_interp_hip - velocity_interp_hip
velocity_diff_knee = velocity_non_interp_knee - velocity_interp_knee

joint_bar = figure(1);
x_labels = {'Hip Non Interpolated';'Hip Interpolated';'Knee Non-Interpolated';'Knee Interpolated'};
x = [1:4];
y = [velocity_non_interp_hip, velocity_interp_hip, velocity_non_interp_knee, velocity_interp_knee];
bar(y)
set(gca,'xticklabel',x_labels)
ylabel('Joint Veloctiy (rad s^{-1})')
xlabel('Relevant Joint And Torque Derivation Method')
title('Joint Velocity With Varying Methods Of Gravity Compensation','Data Over a Period Of 3 Seconds Or Until Joint Angle Plateaus')
saveas(joint_bar,'../Angle_Data/interp_comparison.fig')
saveas(joint_bar,'../Angle_Data/interp_comparison.png')

%% plot]

time_hip_interp = linspace(0,length(interp_hip)*fs, length(interp_hip) );
time_hip_non_interp = linspace(0,length(non_interp_hip)*fs, length(non_interp_hip) );

hip_interp_comp = figure(2);
plot(time_hip_non_interp,rad2deg(non_interp_hip),'r')
hold on
plot(time_hip_interp,rad2deg(interp_hip),['k'])
lgd = legend('Non Interpolated Torque','Interpolated Torque');
lgd.Location = 'northeast';
xlabel('Time (seconds)');
ylabel('Angle (degrees)')
title('Comparison Between Hip Joint Angle',' Interpolated And Non Interpolated Torques Applied')
legend('boxoff')
time_knee_interp = linspace(0,length(interp_knee)*fs, length(interp_knee) );
time_knee_non_interp = linspace(0,length(non_interp_knee)*fs, length(non_interp_knee) );

knee_interp_comp = figure(3);
plot(time_knee_non_interp, rad2deg(non_interp_knee),'r')
hold on
plot(time_knee_interp, rad2deg(interp_knee),['k'])
lgd = legend('Non Interpolated Torque','Interpolated Torque');
lgd.Location = 'northeast';
xlabel('Time (seconds)');
ylabel('Angle (degrees)')
title('Comparison Between Knee Joint Angle',' Interpolated And Non Interpolated Torques Applied')
legend('boxoff')
