function synced_data = cal_head_acce(sync_acce_mag_gyro_data)

for i = 1:size(sync_acce_mag_gyro_data,1)
    acce_vals = sync_acce_mag_gyro_data(i,2:4);
    mag_vals = sync_acce_mag_gyro_data(i,5:7);
    yaw(i) = getYaw(acce_vals,mag_vals) - pi*0.5;
end

synced_data = [sync_acce_mag_gyro_data, yaw'];

end

%% 计算旋转角
function yaw = getYaw(acce_vals, mag_vals)

roll = atan2(acce_vals(1),acce_vals(3));
pitch = -atan(acce_vals(2)/(acce_vals(1)*sin(roll)+acce_vals(3)*cos(roll)));
yaw  = atan2(mag_vals(1)*sin(roll)*sin(pitch)+mag_vals(3)*cos(roll)*sin(pitch)+mag_vals(2)*cos(pitch), ...
    mag_vals(1)*cos(roll)-mag_vals(3)*sin(roll));
end
