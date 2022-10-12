function [all_data, SL] = step_length(sync_acce_mag_gyro_head_data)
%% total accelerations
x_a = sync_acce_mag_gyro_head_data(:,2);
y_a = sync_acce_mag_gyro_head_data(:,3);
z_a = sync_acce_mag_gyro_head_data(:,4);
x_a = smoothdata(x_a,"movmedian");
y_a = smoothdata(y_a,"movmedian");
z_a = smoothdata(z_a,"movmedian");
total_acc = sqrt(x_a.^2+y_a.^2+z_a.^2);

%% smooth
alpha = 0.83;
acc_linear = zeros(length(total_acc),1);
gravity_list = zeros(length(total_acc),1);
for i = 1:length(total_acc)
    gravity  = alpha*9.8 + (1-alpha)*total_acc(i);
    gravity_list(i) = gravity;
    linear = total_acc(i) - gravity;
    acc_linear(i) = linear;
end
acc_linear = smoothdata(acc_linear,"movmedian");

%% step frequency and step length
acc_time = sync_acce_mag_gyro_head_data(:,1);
last_peak_time = acc_time(1);
curr_time = acc_time(1);
diff_a_list = zeros(length(acc_linear),1);
step_flag = zeros(length(acc_linear),1);
step_nums=0;
for i = 1:(length(acc_linear)-1)
    diff_a = acc_linear(i+1) - acc_linear(i);
    diff_a_list(i) = diff_a;
    curr_time = acc_time(i);
    if diff_a<-0.5 && (curr_time-last_peak_time)>0.025
        step_flag(i) = 1;
        last_peak_time = curr_time;
        step_nums = step_nums+1;
    end
end
% step frequency
SF = step_nums/(length(sync_acce_mag_gyro_head_data)/100);
a_coff = 0.371;
b_coff = 0.227;
H = 1.74;
% step length
SL = 0.7 + a_coff*(H-1.75) + b_coff*(SF-1.79)*H/1.75;
all_data = [sync_acce_mag_gyro_head_data, step_flag];
end

