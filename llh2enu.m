function enu = llh2enu(Location_data)
%% const number  WGS-84
a = 6378137.0;
f = 1/298.257223565;
e2 = 0.00669437999013;
%% const number  CGC2000
% a = 6378137.0;
% f = 1/298.257223563;
% e2 = 0.0818191910428*0.0818191910428;
%% altitude
alt = Location_data(:,4);
%% cos and sin of latitude and longitude
cos_lat = cosd(Location_data(:,2));
sin_lat = sind(Location_data(:,2));
sin_lon = sind(Location_data(:,3));
cos_lon = cosd(Location_data(:,3));

%% calculate N
N = a./sqrt(1-e2*sin_lat.*sin_lat);

%% ECEF
X = (N+alt) .* cos_lat .* cos_lon;
Y = (N+alt) .* cos_lat .* sin_lon;
Z = (N.*(1-e2) + alt) .* sin_lat;
xyz = [X,Y,Z];
orixyz = xyz(2,:);
difxyz = xyz - orixyz;
%% ENU
ori_llh = Location_data(1,2:4);
phi = ori_llh(1);
lam = ori_llh(2);
sinphi = sind(phi);
cosphi = cosd(phi);
sinlam = sind(lam);
coslam = cosd(lam);
R = [ -sinlam          coslam         0     ; ...
      -sinphi*coslam  -sinphi*sinlam  cosphi; ...
       cosphi*coslam   cosphi*sinlam  sinphi];
enu = (R*difxyz')';
end

