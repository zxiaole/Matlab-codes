%% Dec. 5, Xiaole Zhang
% read the plant coverage data for each province
clear
close all
regionId =13;

%%
filename ='provinces.shp';
[I, R] = geotiffread('coverage.tif');

info = shapeinfo(filename);
roi = shaperead(filename);
rx = roi(regionId).X(1:end-1);
ry = roi(regionId).Y(1:end-1);
 % convert to image coordinates
ix = (rx - R.LongitudeLimits(1))/R.CellExtentInLongitude + 1;
iy = (R.LatitudeLimits(2)-ry)/R.CellExtentInLatitude + 1;
idd = isnan(ix)|isnan(iy);
ix(idd) = [];
iy(idd) = [];

 %Make the mask
mask = poly2mask(ix,iy,R.RasterSize(1),R.RasterSize(2));
 %Following line checks some 1's are generated in mask
% maskcheck=sum(sum(mask));

dataUsed = mask.*I;
alphadata = abs(dataUsed)>0;
ximg = R.LongitudeLimits(1):R.CellExtentInLongitude:R.LongitudeLimits(2);
yimg = R.LatitudeLimits(2):-R.CellExtentInLatitude:R.LatitudeLimits(1);
imH = imagesc(ximg, yimg, dataUsed);
set(imH, 'alphadata', alphadata);
hold on
axis xy
axis equal
% plot(ix, iy, 'r')
boundarySpaceX = 0.1;
boundarySpaceY = 0.1;
grid on
set(gca, 'xlim', [min(rx)-boundarySpaceX max(rx)+boundarySpaceX], 'ylim', [min(ry)-boundarySpaceY max(ry)+boundarySpaceY] )
colormap jet
colorbar
xlabel('Longitude')
ylabel('Latitude')
set(gca, 'fontname', 'arial', 'fontsize', 16)