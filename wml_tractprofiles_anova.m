% This script reads in FA and MD measures (from Brad Caron's
% TractProfiles App) for each of the tracts generated (from Dan Bullock's
% White Matter Segmentation App).
% It also reads in behavioral data (e.g., experimental group) collected as part of the
% spade study.
%it runs twice, one for producing the plots for mena Fa and difference (S2-S1) and one for mean MD and
%Md difference (S2-S1)

clear all; close all; clc
format shortG

% Set working directories.
rootDir = '/Volumes/Seagate/wml';

w_measures = {'fa', 'ad', 'md', 'rd', 'ndi', 'isovf', 'odi'};

blprojectid = 'proj-6047efa9ebfe45171d3aae9d';
session = 1;
measure = 'fa';

di_color = [0.6350 0.0780 0.1840]; %red

hold on;
linewidth = 1.5;
linestyle = 'none';
fontname = 'Arial';
fontsize = 20;
fontangle = 'italic';
xticklength = 0;

save_figures = 'yes';

% Should outliers be removed? If so, which subIDs?
remove_outliers = 'yes';
if strcmp(remove_outliers, 'yes')
    
    % Identify outliers to be removed - e.g., outlier = [108 126 212 214 318];
    outlier = [];
    
else
    
    outlier = [];
    
end

% % Read in behavioral data.
% beh_tbl = readtable(fullfile(rootDir, 'supportFiles', 'wml_demographics.csv'), 'TreatAsEmpty', {'.', 'na'});

% Read in mri data.
load(fullfile(rootDir, 'supportFiles', ['wml_data_session' num2str(1) '_' measure '.mat']))
mri_1 = table2array(data_tbl(:, 2:end)); clear data_tbl;

load(fullfile(rootDir, 'supportFiles', ['wml_data_session' num2str(2) '_' measure '.mat']))
mri_2 = table2array(data_tbl(:, 2:end)); clear data_tbl;

load(fullfile(rootDir, 'supportFiles', ['wml_data_session' num2str(3) '_' measure '.mat']))
mri_3 = table2array(data_tbl(:, 2:end)); 

% Make plot for each tract.
for t = 1:size(mri_1, 2)
    
    figure(t);
    hold on;
    
    tractname = data_tbl.Properties.VariableNames{t+1};
    
    % Plot individual data.
    c = colormap(parula); c = c(1:size(c, 1)/size(mri_1, 1):size(c, 1), :);
    for subject = 1:size(mri_1, 1)
        
        p = plot([1 3 5], [mri_1(subject, t), mri_2(subject, t), mri_3(subject, t)]);
        p.Color = c(subject, :);
        p.LineStyle = ':';
        p.Marker = 'o';
        p.MarkerSize = 6;
        p.MarkerFaceColor = p.Color;

    end % end subject
    
    % Plot group mean and standard deviation.
    s = scatter([1 3 5], [nanmean(mri_1(:, t)), nanmean(mri_2(:, t)), nanmean(mri_3(:, t))]);
    s.MarkerFaceColor = di_color;
    s.MarkerEdgeColor = di_color;
    s.SizeData = 100;
    p = plot([1 1], [nanmean(mri_1(:, t))-nanstd(mri_1(:, t)) nanmean(mri_1(:, t))+nanstd(mri_1(:, t))]);
    p.Color = di_color;
    p = plot([3 3], [nanmean(mri_2(:, t))-nanstd(mri_2(:, t)) nanmean(mri_2(:, t))+nanstd(mri_2(:, t))]);
    p.Color = di_color;
    p = plot([5 5], [nanmean(mri_3(:, t))-nanstd(mri_3(:, t)) nanmean(mri_3(:, t))+nanstd(mri_3(:, t))]);
    p.Color = di_color;
    
    % xaxis
    xax = get(gca, 'xaxis');
    xax.Limits = [0 6];
    xax.TickValues = [1 3 5];
    xax.TickLabels = {'Pre-training', 'Post-training', 'Post-delay'};
    xax.TickDirection = 'out';
    xax.TickLength = [xticklength xticklength];
    xax.FontName = fontname;
    xax.FontSize = fontsize;
    
    % yaxis
    ylim_lo = 0.40; ylim_hi = 0.60;
    yax = get(gca,'yaxis');
    yax.Limits = [ylim_lo ylim_hi];
    yax.TickValues = [ylim_lo (ylim_lo+ylim_hi)/2 ylim_hi];
    yax.TickDirection = 'out';
    yax.TickLabels = {num2str(ylim_lo, '%2.2f'), num2str((ylim_lo+ylim_hi)/2, '%2.2f'), num2str(ylim_hi, '%2.2f')};
    yax.FontName = fontname;
    yax.FontSize = fontsize;
    yax.FontAngle = fontangle;
    
    % general
    g = gca;
    box off
    g.YLabel.String = measure;
    g.YLabel.FontSize = fontsize;
    g.YLabel.FontAngle = fontangle;
    g.XLabel.String = '';
    
    legend off;
    
    title(tractname);
    pbaspect([1 1 1])
        
    print(fullfile(rootDir, 'plots', ['plot_tractmeans_' measure '_' tractname]), '-dpng')
    print(fullfile(rootDir, 'plots', 'eps', ['plot_tractmeans_' measure '_' tractname]), '-depsc')
            
    hold off;
    
end % end t

