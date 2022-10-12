function synced_data = sync_acce_mag(Accelerometer_data, Magnetometer_data)
% 针对加速度计（100Hz）与磁力计（50Hz）进行时间同步
acce_time = fix(Accelerometer_data(:,1)*100);
mag_time = fix(Magnetometer_data(:,1)*100);
[~, acce_index, mag_index] = intersect(acce_time, mag_time);

N = acce_index(end);
M = size(Accelerometer_data,2) + size(Magnetometer_data,2) - 1;

synced_data = zeros(N, M);
for i = 1:acce_index(end)
    for j = 1: mag_index(end)-1
        if(acce_time(i) == mag_time(j))
            synced_data(i,:) = [Accelerometer_data(i,:), Magnetometer_data(j,2:end)];
        elseif((acce_time(i) > mag_time(j)) && (acce_time(i) < mag_time(j+1)))
            scale = (acce_time(i) - mag_time(j))/(mag_time(j+1) - mag_time(j));
            delta = scale * (Magnetometer_data(j+1,2:end)-Magnetometer_data(j,2:end));
            synced_data(i,:) = [Accelerometer_data(i,:), Magnetometer_data(j,2:end)+delta];
        end
    end
end

end
