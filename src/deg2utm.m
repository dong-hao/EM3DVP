function [x,y,zone]=deg2utm(lat,lon,lonR)
% description:
%       Function to convert degrees (lat/lon) into
%       UTM coordinates(Northing Easting) using WGS84 ellipsoid
%       added some small modifications from Rafael Palacios's deg2utm.
%       DONG Hao
% input:
%       latitude and longitude in degrees [and the reference longitude]
% output:
%       Easting, Northing and UTM Zone number.
% example:
%	lat=[40 35.782 41.389782]
%	lon=[115 115.489 112.892135]	
%	deg2utm(lat,lon,115)
% 	[easting,northing,utmzone]=deg2utm(35, 135);
% some useful variables
% lat = latitude 
% lon = longitude 
% lat0= reference latitude, normally it would be 0;
% lon0= central meridian of the UTM zone
% a     Equatorial Radius (m) (of the earth, of course...)
% b     Polar Radius (m)
% f   = (a-b)/a , Flattening Ratio 
% k0  = scale along lon0 = 0.9996. Even though it's a constant, we retain 
%       it as a separate symbol to keep the numerical coefficients simpler,
%       also to allow for systems that might use a different Mercator projection.
% e   = SQRT(1-b^2/a^2) = .08 approximately. This is the eccentricity of the 
%       earth's elliptical cross-section.
% n   = (a-b)/(a+b)
% rho = a(1-e2)/(1-e2sin2(lat))3/2. This is the radius of curvature of the
%       earth in the meridian plane.
% nu  = a/(1-e2sin2(lat))1/2. This is the radius of curvature of the earth 
%       perpendicular to the meridian plane. It is also the distance from 
%       the point in question to the polar axis, measured perpendicular to
%       the earth's surface.
% p   = (lon-lon0) in radians (This differs from the treatment in the Army
%       reference)

% Argument checking
switch nargin
    case 0
        error('not enough input arguments, 2 at least')
    case 1
        error('not enough input arguments, 2 at least')       
    case 2
        lon0 = floor(lon./6).*6+3; % reference longitude in degrees
    case 3
        lon0 = lonR; % force mode, will project all sites to the given lonR
end
if (size(lon)~=size(lat))
	error('Lat and Lon should have same size');
end
%   earth parameters for WGS84
a = 6378137;
b = 6356752.3142;
e = sqrt(1-(b^2/a^2));
%   projection parameters for UTM
lat0 = 0;                  % reference latitude, not used here
k0 = 0.9996;               % scale on central meridian
FE = 500000;              % false easting, for conventional UTM
FN = (lat < 0).*0; % false northing, set to minus if in south hemisphere
% Equations parameters
eps = e.^2./(1-e.^2);  % e prime square
%   convert degrees to radians
Lat=lat.*pi./180;
Lon=lon.*pi./180;
Lon0 = lon0.*pi./180;
% N: radius of curvature of the earth perpendicular to meridian plane
% Also, distance from point to polar axis
N = a./sqrt(1-e.^2.*sin(Lat).^2); 
T = tan(Lat).^2;                
C = ((e.^2)./(1-e.^2)).*(cos(Lat)).^2;
A = (Lon-Lon0).*cos(Lat);                   
%   calculating the meridian arc
%   might be slow if you have a large array...
M = a.*(  ( 1 - e.^2./4 - 3.*e.^4./64 - 5.*e.^6./256 )  .* Lat         ...
         -( 3.*e.^2./8 + 3.*e.^4./32 + 45.*e.^6./1024 ) .* sin(2.*Lat) ...
         +( 15.*e.^4./256 + 45.*e.^6./1024 )            .* sin(4.*Lat) ...
         -(35.*e.^6./3072 )                             .* sin(6.*Lat));
%   calculating Northing
y = FN + k0.*M + k0.*N.*tan(Lat).*(                                     A.^2./2  ...
                                   + (5-T+9.*C+4.*C.^2)              .* A.^4./24 ...
                                   + (61-58.*T+T.^2+600.*C-330.*eps) .* A.^6./720 );
%   calculating Easting
x = FE + k0.*N.*(                                  A       ...
                 + (1-T+C)                      .* A.^3./6 ...
                 + (5-18.*T+T.^2+72.*C-58.*eps) .* A.^5./120 );
%   calculate UTM zone
zone = floor(lon0./6)+31;
return
