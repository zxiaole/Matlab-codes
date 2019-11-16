%% plot the shares aviation emissions in different regions 
% share
offset = 1.06;
alpha = 0.25;
% load('globalAviationEmissionByRegions.mat');
load('aviationEmissionByContinentEnsemble.mat');
load('aviationEmissionByOceanEnsemble.mat');
aviationEmissionData = [ mean(PM_number_continent,2)  mean(PM_mass_continent,2) mean(PM_fuel_continent,2);...
    mean(PM_number_ocean,2)  mean(PM_mass_ocean,2) mean(PM_fuel_ocean,2)];
err = [ std(PM_number_continent,1,2)  std(PM_mass_continent,1,2) std(PM_fuel_continent,1,2);...
    std(PM_number_ocean,1,2)  std(PM_mass_ocean,1,2) std(PM_fuel_ocean,1,2)];
% id = 1:16;
% id = [1 11 2 3 4 12 5 13 6 7 8 9 14 10 15 16]

scrsz = get(0,'ScreenSize');
hfigure = figure('name', 'Reconstruction Results', 'NumberTitle','off',...
    'Position',[0.2*scrsz(3) 0.3*scrsz(4) scrsz(3)*0.73 scrsz(4)*0.5], 'color', 'w');


aviationTotal = [10.92*10^25 9.5*10^6 180.5*10^9];
% regionNames = {'NORTHERN AMERICA'; 'ASIA (EX. NEAR EAST)'; 'WESTERN EUROPE';'C.W. OF IND. STATES';...
%     'LATIN AMER. & CARIB'; 'SUB-SAHARAN AFRICA'; 'NEAR EAST';'EASTERN EUROPE';'OCEANIA';'NORTHERN AFRICA'};
regionNames = [regionNames; oceans];

shares = aviationEmissionData./repmat(aviationTotal, size(aviationEmissionData,1),1)*100;
sharesTmp = shares(1:end-2, 1);
[v, id] = sort(sharesTmp, 'descend');


h = bar(shares(id,:),  1);
hold on
% plot([10.5 10.5], [0 100], 'r-');
% grid on

axis([0 length(id)+1 0 30])
set(gca, 'xtick', 1:length(regionNames(id)), 'Xticklabel', regionNames(id), 'XTickLabelRotation',20,'FontName', 'Arial', 'FontSize',13)
ylabel('Contributions to total aviation emission (%)','FontName', 'Arial', 'FontSize',13)
% get the current tick labeks
ticklabels = get(gca,'XTickLabel');

% prepend a color for each tick label
ticklabels_new = cell(size(ticklabels));
oceanId = [2 6 8 13 15 16];
for i = 1:16
    if(ismember(i,oceanId))
    ticklabels_new{i} = ['\color{red} ' ticklabels{i}];
    else
        ticklabels_new{i} = ['\color{black} ' ticklabels{i}];
    end
end

% set the tick labels
set(gca, 'XTickLabel', ticklabels_new);


colorCode = [0.6 0.2 0.9];
GMD = [GMD_continent; GMD_ocean];
GSD = [GSD_continent; GSD_ocean];

yyaxis right
h2 = plot(1:length(id),mean(GMD(id,:),2),'marker', 'o','linestyle','-', 'Color',colorCode,'markerfacecolor', colorCode);
ylim([26.5 38.5])
ylabel('{\itGMD} (nm)','FontName', 'Arial', 'FontSize',13)
ax = gca;
c = ax.Color;
% ax.Color = 'blue';
ax.YColor = colorCode;
ax.YTick = 26.5:2.0:38.5;
ax.Position(3) = ax.Position(3) *0.98;
hold on
yup = mean(GMD(id,:),2)+std(GMD(id,:),1,2);
ydown = mean(GMD(id,:),2)-std(GMD(id,:),1,2);
xtmp = 1:length(id);
xtmp = [xtmp, fliplr(xtmp)];
inBetween = [yup',fliplr(ydown')];
ax12 = axes('Position', get(gca,'Position'), ...
    'xlim', get(gca, 'xlim'),'ylim', get(gca, 'ylim'), ...
    'Visible', 'off', 'Color', 'none');
% hs = plot((1:length(id))/offset,mean(GSD(id,:),2)*0.5,'marker', '^','linestyle','-.', 'Color',colorCode,'Parent',ax2,'markerfacecolor', colorCode);
hold on
hss = fill(xtmp, inBetween, colorCode, 'facealpha', alpha, 'edgeAlpha', 0, 'Parent', ax12);


% legend('boxoff')


% annotation(hfigure,'textbox',...
%     [0.638931034482755 0.600176470588235 0.0634677661169416 0.0529411764705883],...
%     'String','Oceans',...
%     'FitBoxToText','off', 'linestyle', 'none','FontName', 'Arial', 'FontSize',13);
% annotation(hfigure,'arrow',[0.616191904047976 0.661169415292354],...
%     [0.60191904047976 0.60191904047976]);
% annotation(hfigure,'arrow',[0.600449775112443 0.554722638680659],...
%     [0.742333333333333 0.742333333333333]);
% annotation(hfigure,'textbox',...
%     [0.515992503748126 0.772549019607843 0.0634677661169416 0.0529411764705883],...
%     'String',{'Continents'},...
%     'FitBoxToText','off','linestyle', 'none','FontName', 'Arial', 'FontSize',13);

colorCode = [0.2 0.7 0.5];
offset = 1.07;
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax1_pos(3)=ax1_pos(3)*offset;
ax2 = axes('Position',ax1_pos,...
    'YAxisLocation','right',...
    'Color','none');
ax2.YColor = colorCode;
% set(ax2, 'XColor', 'none', 'xlim', [0 length(regionNames)+1], 'ylim', [25 40])


set(ax2, 'XColor', 'none', 'xlim', [0 length(id)+1], 'ylim',  [1.76 2],'FontName', 'Arial', 'FontSize',13)
ylabel('{\itGSD}','FontName', 'Arial', 'FontSize',13)
ax2.YTick = (1.76:0.04:2);
hold on

numIdex = [PM_number_continent; PM_number_ocean]./[PM_fuel_continent; PM_fuel_ocean];
h3 = plot((1:length(id))/offset,mean(GSD(id,:),2),'marker', '^','linestyle','-.', 'Color',colorCode,'Parent',ax2,'markerfacecolor', colorCode);
hold on
yup = mean(GSD(id,:),2)+std(GSD(id,:),1,2);
ydown = mean(GSD(id,:),2)-std(GSD(id,:),1,2);
xtmp = (1:length(id))/offset;
xtmp = [xtmp, fliplr(xtmp)];
inBetween = [yup',fliplr(ydown')];
ax22 = axes('Position', get(gca,'Position'), ...
    'xlim', get(gca, 'xlim'),'ylim', get(gca, 'ylim'), ...
    'Visible', 'off', 'Color', 'none');
% hs = plot((1:length(id))/offset,mean(GSD(id,:),2)*0.5,'marker', '^','linestyle','-.', 'Color',colorCode,'Parent',ax2,'markerfacecolor', colorCode);
hold on
hs = fill(xtmp, inBetween, colorCode, 'facealpha', alpha, 'edgeAlpha', 0, 'Parent', ax22);

% Axis 3
colorCode = 'blue';
offset = 1.075;
ax3_pos = ax1.Position; % position of first axes
ax3_pos(1)=ax3_pos(1) + ax3_pos(3) - (ax3_pos(3))*offset;
ax3_pos(3)=(ax3_pos(3))*offset;
ax3 = axes('Position',ax3_pos,...
    'YAxisLocation','left',...
    'Color','none');
ax3.YColor = colorCode;
% set(ax2, 'XColor', 'none', 'xlim', [0 length(regionNames)+1], 'ylim', [25 40])
set(ax3, 'XColor', 'none', 'xlim', [0 length(id)+1], 'ylim', [3.5 18.5]*10^14,'FontName', 'Arial', 'FontSize',13)
ylabel('Average fleet {\itEI}_{n}(BC) (kg^{-1}-fuel)','FontName', 'Arial', 'FontSize',13)
ax3.YTick = (3.5:2.5:18.5)*10^14;
hold on
h4 = plot(length(id)+1 - (length(id)+1-(1:length(id)))/offset,mean(numIdex(id,:),2),'marker', 'd','linestyle','--', 'Color',colorCode,'Parent',ax3,'markerfacecolor', colorCode);
hold on

% h4 = plot(id,mean(GSD(id,:),2),'bo-','markerfacecolor', 'b');


%  legend('boxoff')
 yup = mean(numIdex(id,:),2)+std(numIdex(id,:),1,2);
ydown = mean(numIdex(id,:),2)-std(numIdex(id,:),1,2);
xtmp = length(id)+1 - (length(id)+1-(1:length(id)))/offset;
xtmp = [xtmp, fliplr(xtmp)];
inBetween = [yup',fliplr(ydown')];
ax32 = axes('Position', get(gca,'Position'), ...
    'xlim', get(gca, 'xlim'),'ylim', get(gca, 'ylim'), ...
    'Visible', 'off', 'Color', 'none');
% hs = plot((1:length(id))/offset,mean(GSD(id,:),2)*0.5,'marker', '^','linestyle','-.', 'Color',colorCode,'Parent',ax2,'markerfacecolor', colorCode);
hold on
hs = fill(xtmp, inBetween, colorCode, 'facealpha', alpha, 'edgeAlpha', 0, 'Parent', ax32);
tt = legend([h h2 h3 h4],...
    {'Aviation BC number emission'; ...
    'Aviation BC mass emission';...
    'Aviation fuel consumption'; ...
    'Geometric Mean Diameter ({\itGMD})';...
    'Geometric Standard Deviation ({\itGSD})'; ...
   'Average fleet {\itEI}_{n}(BC)' },...
    'FontName', 'Arial', 'FontSize',13, 'box', 'off');
uistack(ax1, 'top')

