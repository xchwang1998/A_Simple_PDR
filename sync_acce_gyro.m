function synced_data = sync_acce_gyro(Accelerometer_data, Gyroscope_data);

% 时间同步  由于加速度计与陀螺仪的频率相同，所以直接取小数点后两位进行相交
acce_time = fix(Accelerometer_data(:,1)*1000);
gyro_time = fix(Gyroscope_data(:,1)*1000);
[~, acce_index, gyro_index] = intersect(acce_time, gyro_time);

% 同步后的加速度计与陀螺仪数据
Accelerometer_data = Accelerometer_data(acce_index, :);
Gyroscope_data = Gyroscope_data(gyro_index, :);

synced_data = [Accelerometer_data, Gyroscope_data(:,2:end)];

end