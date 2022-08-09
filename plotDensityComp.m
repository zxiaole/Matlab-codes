function plotDensityComp(prediction,measurement)
% Aug. 9, 2022
%   plot density scattering
posVal = 0.98;
stepsN = 100; 
fontsize = 12;

figure('position', [100 100 850 400])

valmin = quantile([prediction(:); measurement(:)], 1-posVal);
valmax = quantile([prediction(:); measurement(:)], posVal);

x = linspace(valmin, valmax, stepsN);
y = x;

stepsX = mean(diff(x));
stepsY = stepsX;

numbers = zeros(length(y), length(x));

validId = ~isnan(prediction)...
    &~isnan(measurement)...
    &prediction>=min(x)...
    &prediction<=max(x)...
    &(measurement>=min(y))...
    &(measurement<=max(y));
xi = ceil((prediction(validId)-min(x)+0.5*stepsX)/stepsX);
yi = ceil((max(y)+0.5*stepsY-(measurement(validId)))/stepsY);
inds = sub2ind([length(y), length(x)], yi, xi);
inds = sort(inds, 'ascend');

while(~isempty(inds))
    idXY = inds(1);
    id = inds == idXY;
    [i, j] = ind2sub([length(y) length(x)], idXY);
    numbers(i,j)=sum(id);
    inds(id) = [];
end

densities = log10(numbers/sum(numbers(:))*100);
im = imagesc(x, fliplr(y),densities, [min(densities(:)) max(densities(:))]);
alphadata = (numbers/sum(numbers(:)))==0;
set(im, 'alphadata', 1-alphadata)
hold on

axis equal

axis xy
hold on

cb = colorbar;
colormap(jet)
barTicks = cb.Ticks;
for i=1:length(barTicks)
    
    cb.TickLabels{i} = ['10^{' num2str(barTicks(i)) '}'];
    
    cb.FontSize = fontsize;
    cb.FontName = 'Arial';
end
cb.Label.String = 'Fraction of data (%)';
cb.Label.Rotation = 90;

ylabel('Predictions');
xlabel('Measurements')

set(gca, 'fontname', 'arial', 'fontsize', fontsize, 'xlim', [min(x) max(x)], 'ylim',[min(y) max(y)])

set(gcf,'PaperPositionMode','auto')
print('residual_distribution','-dpng','-r300')
end

