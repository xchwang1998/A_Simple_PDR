clc;
clear all;
close all;
%% read data 读取数据
file_path = 'cc 2022-09-16 11-49-45.xls';
Accelerometer_data = xlsread(file_path,['Accelerometer']);
Gyroscope_data = xlsread(file_path,['Gyroscope']);
Location_data = xlsread(file_path,['Location']);
Magnetometer_data = xlsread(file_path,['Magnetometer']);

%% 裁剪无用数据
cropTime = Location_data(2, 1);
Location_data = Location_data(2:end, :);
Accelerometer_data = crop_data(Accelerometer_data, cropTime);
Gyroscope_data = crop_data(Gyroscope_data, cropTime);
Magnetometer_data = crop_data(Magnetometer_data, cropTime);

%% synced time  数据预处理，加速度计，陀螺仪，磁力计时间同步
sync_acce_mag_data = sync_acce_mag(Accelerometer_data, Magnetometer_data);
sync_acce_mag_gyro_data = sync_acce_gyro(sync_acce_mag_data, Gyroscope_data);

%% calculate the head angle 计算航向角
sync_acce_mag_gyro_head_data = cal_head_acce(sync_acce_mag_gyro_data);

%% 计算步长，并组合成为新的数组
[all_data,SL] = step_length(sync_acce_mag_gyro_head_data);

%% ENU as the ground truth  经纬度转为ENU  作为参考真值
enu = llh2enu(Location_data);

%% PDR计算  根据步长与航向进行计算位置
j = 2;
XYZ = [0,0,0]; % 起始坐标
for i=1:size(all_data,1)
    if(all_data(i,end) == 1)
        XYZ(j,1) = XYZ(j-1,1) + SL * sin(all_data(i,end-1));
        XYZ(j,2) = XYZ(j-1,2) + SL * cos(all_data(i,end-1));
        j = j+1;
    end
end

%% 画图
% figure;
% plot(XYZ(:,1),XYZ(:,2));
% hold on;
% %plot(enu(1:end, 2),-enu(1:end, 1));
% plot(enu(1:end, 1),enu(1:end, 2));
% axis equal;

figure;
plot(XYZ(:,1),XYZ(:,2),'LineWidth',1);
hold on;
plot(enu(1:end, 1),enu(1:end, 2),'LineWidth',1);
plot(XYZ(1,1),XYZ(1,2),'Marker','^',MarkerSize=10,MarkerFaceColor='r',Color='r');

plot(XYZ(end,1),XYZ(end,2),'Marker','^',MarkerSize=10,MarkerFaceColor='g',Color='g');
plot(enu(end,1),enu(end,2),'Marker','^',MarkerSize=10,MarkerFaceColor='b',Color='b');
legend('PDR','GNSS','Start','PDR\_End','GNSS\_End');
xlabel('m');
ylabel('m');
set(gca, 'Fontname', 'Times New Roman', 'Fontsize', 12);
axis equal;

