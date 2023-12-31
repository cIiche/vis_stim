% Harry_Plotter2 creates box and whisker plots and performs statistical
% analysis on median_x script data formatted as a vector (1x~60) of the variances for
% each event of a given trial for each mouse, for both the PEN and SHAM
% cohorts (~60 points per mouse recorded per trial, per cohort) 

% this is different than Harry_plotter, which deals with median_x data
% formatted such that only 1 median value per each waterfall plot/trial per
% mouse per cohort is recorded (7 points per trial, per cohort) 

close all 

%% data conditioning + intercohort MWs 
% cohort vectors are different (so boxplot wont work) because different number of events in the waterfalls 
% this attempts to expand the shorter vector by filling the vector with NaNs 
% that won't alter analysis (they are ommitted?) 
if medians_or_variance == 1 
    firstLOpen = [penmedians.Mouse1Trial1 penmedians.Mouse2Trial1 penmedians.Mouse3Trial1 penmedians.Mouse4Trial1 penmedians.Mouse5Trial1 penmedians.Mouse6Trial1 penmedians.Mouse7Trial1 ]; 
    % 1x354
    firstLOsham = [shammedians.Mouse1Trial1 shammedians.Mouse2Trial1 shammedians.Mouse3Trial1 shammedians.Mouse4Trial1 shammedians.Mouse5Trial1 shammedians.Mouse6Trial1 shammedians.Mouse7Trial1 ];
    % 1x396
    filler = NaN(1,42) ;
    firstLOpen = [firstLOpen filler] ;
    % MW 
    median_MW1LO = ranksum(firstLOpen,firstLOsham) ;
    
    LUSpen = [penmedians.Mouse1Trial3 penmedians.Mouse2Trial3 penmedians.Mouse3Trial3 penmedians.Mouse4Trial3 penmedians.Mouse5Trial3 penmedians.Mouse6Trial3 penmedians.Mouse7Trial3 ]; 
    % 1x389
    LUSsham = [shammedians.Mouse1Trial3 shammedians.Mouse2Trial3 shammedians.Mouse3Trial3 shammedians.Mouse4Trial3 shammedians.Mouse5Trial3 shammedians.Mouse6Trial3 shammedians.Mouse7Trial3 ];
    % 1x398
    filler = NaN(1,9) ;
    LUSpen = [LUSpen filler] ;
    % MW 
    median_MWLUS = ranksum(LUSpen,LUSsham) ;
    
    secondLOpen = [penmedians.Mouse1Trial4 penmedians.Mouse2Trial4 penmedians.Mouse3Trial4 penmedians.Mouse4Trial4 penmedians.Mouse5Trial4 penmedians.Mouse6Trial4 penmedians.Mouse7Trial4 ]; 
    % 1x396
    secondLOsham = [shammedians.Mouse1Trial4 shammedians.Mouse2Trial4 shammedians.Mouse3Trial4 shammedians.Mouse4Trial4 shammedians.Mouse5Trial4 shammedians.Mouse6Trial4 shammedians.Mouse7Trial4 ];
    % 1x395
    secondLOsham = [secondLOsham NaN] ;
     % MW 
    median_MW2LO = ranksum(secondLOpen,secondLOsham) ;    
    
else 
    firstLOpen = [penvariances.Mouse1Trial1 penvariances.Mouse2Trial1 penvariances.Mouse3Trial1 penvariances.Mouse4Trial1 penvariances.Mouse5Trial1 penvariances.Mouse6Trial1 penvariances.Mouse7Trial1 ]; 
    % 1x354
    firstLOsham = [shamvariances.Mouse1Trial1 shamvariances.Mouse2Trial1 shamvariances.Mouse3Trial1 shamvariances.Mouse4Trial1 shamvariances.Mouse5Trial1 shamvariances.Mouse6Trial1 shamvariances.Mouse7Trial1 ];
    % 1x396
    filler = NaN(1,42) ;
    firstLOpen = [firstLOpen filler] ;
    % MW 
    var_MW1LO = ranksum(firstLOpen,firstLOsham) ;
    
    LUSpen = [penvariances.Mouse1Trial3 penvariances.Mouse2Trial3 penvariances.Mouse3Trial3 penvariances.Mouse4Trial3 penvariances.Mouse5Trial3 penvariances.Mouse6Trial3 penvariances.Mouse7Trial3 ]; 
    % 1x389
    LUSsham = [shamvariances.Mouse1Trial3 shamvariances.Mouse2Trial3 shamvariances.Mouse3Trial3 shamvariances.Mouse4Trial3 shamvariances.Mouse5Trial3 shamvariances.Mouse6Trial3 shamvariances.Mouse7Trial3 ];
    % 1x398
    filler = NaN(1,9) ;
    LUSpen = [LUSpen filler] ;
    % MW 
    var_MWLUS = ranksum(LUSpen,LUSsham) ;
    
    secondLOpen = [penvariances.Mouse1Trial4 penvariances.Mouse2Trial4 penvariances.Mouse3Trial4 penvariances.Mouse4Trial4 penvariances.Mouse5Trial4 penvariances.Mouse6Trial4 penvariances.Mouse7Trial4 ]; 
    % 1x396
    secondLOsham = [shamvariances.Mouse1Trial4 shamvariances.Mouse2Trial4 shamvariances.Mouse3Trial4 shamvariances.Mouse4Trial4 shamvariances.Mouse5Trial4 shamvariances.Mouse6Trial4 shamvariances.Mouse7Trial4 ];
    % 1x395
    secondLOsham = [secondLOsham NaN] ;
    % MW 
    var_MW2LO = ranksum(secondLOpen,secondLOsham) ;
end 

%% kruskal-wallis test
% 6 data sets, sham and pen for each of 3 trial types
% 
max_length = max([length(firstLOpen), length( LUSpen),length(secondLOpen),length(firstLOsham),length(LUSsham),length(secondLOsham)]);

varNames = {'firstLOpen', 'LUSpen', 'secondLOpen', 'firstLOsham', 'LUSsham', 'secondLOsham'};
targetLength = max_length;

for i = 1:numel(varNames)
    var = eval(varNames{i}); % get variable value by name
    len = length(var);
    diff = targetLength - len;
    
    if diff > 0 % variable is shorter than target length
        var = [var, nan(1, diff)]; % add NaNs to reach target length
        assignin('base', varNames{i}, var); % save updated variable to workspace
    end
end

% cohorttrialdata.(concat) 
% datastings = {'firstLOpen' 'LUSpen' 'secondLOpen' 'firstLOsham' 'LUSsham' 'secondLOsham'} ;
% for i = 1:6
%     concat =
%     vec_length = length(datastrings{i});
%     diff = max_length - vec_length ;
%     filler = NaN(1,diff) ;
%     LUSpen = [LUSpen filler] ;
% end 

dataset = [firstLOpen; LUSpen; secondLOpen; firstLOsham; LUSsham; secondLOsham]';
KWp = kruskalwallis(dataset);

%% medians/variance box and whisker plots 
% they like each box's data to be a column
if medians_or_variance == 1
    
    % for whiskers 
    q3=norminv(.75);
    q95=norminv(0.95);
    w95=(q95-q3)/(2*q3);

%     x1 = subplot(1,3,1)
    tiledlayout(1,3)
    
    ax1 = nexttile;
    
%         % finding whisker length for boxplot 
%             % Calculate the percentiles
%         lower_percentile = prctile(firstLOsham, 2.5);
%         upper_percentile = prctile(firstLOsham, 97.5);
% 
%             % Find the whisker values
%         lower_whisker = min(firstLOsham(firstLOsham >= lower_percentile));
%         upper_whisker = max(firstLOsham(firstLOsham <= upper_percentile));
        
%       boxplot([firstLOpen',firstLOsham'],'Whisker',w95,'Notch','on','Labels', {'PEN US', 'SHAM US'}) 
%     boxplot([firstLOpen',firstLOsham'],'whiskers', [lower_whisker, upper_whisker],'Notch','on','Labels', {'PEN US', 'SHAM US'}) 
%     boxplot([firstLOpen',firstLOsham'],'Notch','on','Labels', {'PEN US', 'SHAM US'}) 
boxplot([firstLOpen',firstLOsham'],'Symbol', '','Notch','on','Labels', {'PEN US', 'SHAM US'}) 
%     hold on 
%     scatter(ones(length(firstLOpen)),firstLOpen,4,'r','filled')
%     hold on 
%     scatter(2.*ones(length(firstLOsham)),firstLOpen,4,'r','filled')
    title('1st LO','Fontsize', 13) 
    ylabel('Normalized RMS Brain Activity','FontWeight','bold', 'Fontsize', 14) 
    
%     x2 = subplot(1,3,2)
    ax2 = nexttile;
    
%     % finding whisker length for boxplot 
%             % Calculate the percentiles
%         lower_percentile = prctile(LUSsham, 2.5);
%         upper_percentile = prctile(LUSsham, 97.5);
% 
%             % Find the whisker values
%         lower_whisker = min(LUSsham(LUSsham >= lower_percentile));
%         upper_whisker = max(LUSsham(LUSsham <= upper_percentile));
%         boxplot([LUSpen',LUSsham'],'Whisker',w95,'Notch','on','Labels', {'PEN US', 'SHAM US'})
%     boxplot([LUSpen',LUSsham'],'whiskers', [lower_whisker, upper_whisker],'Notch','on','Labels', {'PEN US', 'SHAM US'})
%     boxplot([LUSpen',LUSsham'],'Notch','on','Labels', {'PEN US', 'SHAM US'})
 boxplot([LUSpen',LUSsham'],'Symbol', '','Notch','on','Labels', {'PEN US', 'SHAM US'})
    set(gca,'YTickLabel',[]);
%     hold on 
%     scatter(ones(length(LUSpen)),LUSpen,3,'r','filled')
%     hold on 
%     scatter(2.*ones(length(LUSsham)),LUSpen,3,'r','filled')
    title('L+tDUS','FontWeight','bold','Fontsize', 13) 
%     ylabel('Normalized RMS Brain Activity') 
    
%     x3 = subplot(1,3,3)
    ax3 = nexttile;
    
%     % finding whisker length for boxplot 
%             % Calculate the percentiles
%         lower_percentile = prctile(secondLOsham, 2.5);
%         upper_percentile = prctile(secondLOsham, 97.5);
% 
%             % Find the whisker values
%         lower_whisker = min(LUSsham(LUSsham >= lower_percentile));
%         upper_whisker = max(LUSsham(LUSsham <= upper_percentile));
        
%     boxplot([secondLOpen',secondLOsham'],'Whisker',w95,'Notch','on','Labels', {'PEN US', 'SHAM US'}) 
%     boxplot([secondLOpen',secondLOsham'],'whiskers', [lower_whisker, upper_whisker],'Notch','on','Labels', {'PEN US', 'SHAM US'}) 
%     boxplot([secondLOpen',secondLOsham'],'Notch','on','Labels', {'PEN US', 'SHAM US'}) 
boxplot([secondLOpen',secondLOsham'],'Symbol', '','Notch','on','Labels', {'PEN US', 'SHAM US'})
    set(gca,'YTickLabel',[]);
%     hold on 
%     scatter(ones(length(secondLOpen)),secondLOpen,3,'r','filled')
%     hold on
%     scatter(2.*ones(length(secondLOsham)),secondLOsham,3,'r','filled')
    title('2nd LO', 'Fontsize',13) % Normalized RMS Brain Activity by Cohort
%     ylabel('Normalized RMS Brain Activity') 
    
    linkaxes([ax1 ax2 ax3],'xy')
    

if normalize_by_1LOvar == 1 
    ax1.YLim = [0.2 2.5];
else 
    ax1.YLim = [0.5 3.7];
end 
    
    %     for sharey x axis : 
%     p1 = get(x1, 'Position');
%     p2 = get(x2, 'Position');
%     p1(2) = p2(2)+p2(4);
%     set(x1, 'pos', p1);
end 
% % 1LO 
%     figure(1)
%     % boxplot (input vectors: 7 x~58 = 406)
%     boxplot([firstLOpen',firstLOsham'],'Notch','on','Labels', {'PEN US', 'SHAM US'}) 
%     hold on 
%     %scatterplot; scatter(x,y) creates a scatter plot with circular markers at the locations specified by the vectors x and y.
%     scatter(ones(length(firstLOpen)),firstLOpen,4,'r','filled')
%     hold on 
%     scatter(2.*ones(length(firstLOsham)),firstLOpen,4,'r','filled')
%     if medians_or_variance == 1
%         title('1LO rms values by Cohort') 
%         ylabel('rms values') 
%     else  
%         title('1LO rms variances by Cohort') 
%         ylabel('variance (rms^2?)') 
%     end 
%            
% % L+US  
%     figure(2)
%     % boxplot (input vectors: 7 x~58 = 406)
%     boxplot([LUSpen',LUSsham'],'Notch','on','Labels', {'PEN US', 'SHAM US'}) 
%     hold on 
%     %scatterplot
%     scatter(ones(length(LUSpen)),LUSpen,3,'r','filled')
%     hold on 
%     scatter(2.*ones(length(LUSsham)),LUSpen,3,'r','filled')
%     if medians_or_variance == 1
%         title('L+US rms values by Cohort') 
%         ylabel('rms values') 
%     else  
%         title('L+US variances by Cohort') 
%         ylabel('variance (rms^2?)') 
%     end 
%     
% % 2LO  
%     figure(3)
%     % boxplot (input vectors: 7 x~58 = 406)
%     boxplot([secondLOpen',secondLOsham'],'Notch','on','Labels', {'PEN US', 'SHAM US'}) 
%     hold on 
%     %scatterplot
%     scatter(ones(length(secondLOpen)),secondLOpen,3,'r','filled')
%     hold on 
%     scatter(2.*ones(length(secondLOsham)),secondLOsham,3,'r','filled')
%     if medians_or_variance == 1
%         title('2LO rms values by Cohort') 
%         ylabel('rms values') 
%     else  
%         title('2LO variances by Cohort') 
%         ylabel('variance (rms^2?)') 
%     end
    
%% Test for Equal Variances Using the Brown-Forsythe Test
% Test the null hypothesis that the variances are equal across each column of PEN/SHAM data in the 
% trial type matrix, using the Brown-Forsythe test. Suppress the display of the 
% summary table of statistics and the box plot.    

% trial vectors still have NaN entries so that they are same length 

% creating matrix for each cohort x trial type 
firstLO_matrix = [firstLOpen' firstLOsham'] ;
LUS_matrix = [LUSpen' LUSsham'];
secondLO_matrix = [secondLOpen' secondLOsham'];  

% BF test 
[BF_1LOp,bfstats1LO] = vartestn(firstLO_matrix,'TestType','BrownForsythe','Display','off');
[BF_LUSp,bfstatsLUS] = vartestn(LUS_matrix,'TestType','BrownForsythe','Display','off');
[BF_2LOp,bfstats2LO] = vartestn(secondLO_matrix,'TestType','BrownForsythe','Display','off');

%% variance by trial 

% removing NaN entries 
firstLOpen = firstLOpen(~isnan(firstLOpen));
firstLOsham = firstLOsham(~isnan(firstLOsham));
LUSpen = LUSpen(~isnan(LUSpen));
LUSsham = LUSsham(~isnan(LUSsham));
secondLOpen = secondLOpen(~isnan(secondLOpen));
secondLOsham = secondLOsham(~isnan(secondLOsham));

if medians_or_variance ~= 1
    
    % variance standard error for errorbars 
    var_stderror = zeros(2,3) ;
    var_stderror(1,1) = std(firstLOpen)/sqrt(length(firstLOpen)) ;
    var_stderror(1,2) = std(LUSpen)/sqrt(length(LUSpen)) ;
    var_stderror(1,3) = std(secondLOpen)/sqrt(length(secondLOpen)) ;
    
    var_stderror(2,1) = std(firstLOsham)/sqrt(length(firstLOsham)) ;
    var_stderror(2,2) = std(LUSsham)/sqrt(length(LUSsham)) ;
    var_stderror(2,3) = std(secondLOsham)/sqrt(length(secondLOsham)) ;
    
    % plotting 
    figure(7) 
    var_y_pen = [median(firstLOpen)  median(LUSpen) median(secondLOpen)] ;
    var_y_sham = [median(firstLOsham)  median(LUSsham) median(secondLOsham)] ;
    var_1 = errorbar(1:3, var_y_pen, var_stderror(1,:), 'o-r') ; 
    hold on 
    var_2 = errorbar(1:3, var_y_sham, var_stderror(2,:), 'o-b') ;  
%     xlim([-0.5, 2.5]);
    legend([var_1 var_2], {'PEN data', 'SHAM data'})
    title('Median Variance by cohort vs. Trial Type')
    ylabel('Variance') 
    trialtype = {'1LO' '' '' '' '' 'L+US' '' '' '' '' '2LO'};
    
    xticklabels(trialtype) ;
    
    
else 
    %% median of event median standard error for errorbars 
    median_stderror = zeros(2,3) ;
    median_stderror(1,1) = std(firstLOpen)/sqrt(length(firstLOpen)) ;
    median_stderror(1,2) = std(LUSpen)/sqrt(length(LUSpen)) ;
    median_stderror(1,3) = std(secondLOpen)/sqrt(length(secondLOpen)) ;
    
    median_stderror(2,1) = std(firstLOsham)/sqrt(length(firstLOsham)) ;
    median_stderror(2,2) = std(LUSsham)/sqrt(length(LUSsham)) ;
    median_stderror(2,3) = std(secondLOsham)/sqrt(length(secondLOsham)) ;
% % standard dev
%     median_stderror(1,1) = std(firstLOpen) ;
%     median_stderror(1,2) = std(LUSpen);
%     median_stderror(1,3) = std(secondLOpen) ;
%     
%     median_stderror(2,1) = std(firstLOsham);
%     median_stderror(2,2) = std(LUSsham) ;
%     median_stderror(2,3) = std(secondLOsham);

    
    % plotting 
    figure(7) 
    medmed_y_pen = [median(firstLOpen)  median(LUSpen) median(secondLOpen)] ;
    medmed_y_sham = [median(firstLOsham)  median(LUSsham) median(secondLOsham)] ;
%     medmed_1 = errorbar(1:3, medmed_y_pen, median_stderror(1,:), 'o-r') ; 
    medmed_1line = scatter(1:3, medmed_y_pen, 500, 'k.') ; 
    hold on 
    % medmed_1 = errorbar(1:3, medmed_y_pen, median_stderror(1,:),'k-','LineWidth', 1.5) ; 
    % hold on 
%     medmed_2 = errorbar(1:3, medmed_y_sham, median_stderror(2,:), 'o-b') ;  
    medmed_2line = scatter(1:3, medmed_y_sham, 500, 'k.') ;
    hold on 
    % medmed_2 = errorbar(1:3, medmed_y_sham, median_stderror(2,:),'k--','LineWidth', 1.5) ;

% Plot the lines without displaying them in the legend
hold on
medmed_1 = plot(1:3, medmed_y_pen, 'k-', 'LineWidth', 1.5);
medmed_2 = plot(1:3, medmed_y_sham, 'k--', 'LineWidth', 1.5);
set(get(get(medmed_1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(medmed_2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

    legend([medmed_1 medmed_2], {'PEN US', 'SHAM US'}, 'location', 'northwest')
%     title('Cohort Median RMS Responses vs. Trials','Fontsize', 14)
    ylabel('Normalized RMS Brain Activity','Fontsize', 14) 
    
%     ylim([1.3 2.0]);
%     labels = {'1LO', '', '', '', '', 'L+US', '', '', '', '', '2LO'};
    labels = {'1st LO', 'L+tDUS', '2nd LO'};

    % Find the positions of the categorical labels
    labelPositions = find(~cellfun(@isempty, labels));

    % Set the x-tick positions and labels
    xticks(labelPositions);
    xticklabels(labels(labelPositions));

    % Adjust the x-axis limits if needed
    xlim([0, numel(labels)+1]);

    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'fontsize',14)
    xlim([0.95 3.05]);
    
end 

%% intracohort median/variance MWs 

% if normalize_by_1LOvar == 1 
%     if medians_or_variance == 1 
%         median_MWpenLUS2LO = ranksum(LUSpen,secondLOpen); 
%         median_MWshamLUS2LO = ranksum(LUSsham,secondLOsham); 
%     else
%         var_MW_pen_LUS2LO = ranksum(LUSpen, secondLOpen) ; 
%         var_MW_sham_LUS2LO = ranksum(LUSsham, secondLOsham) ;
%     end 
% else 
    if medians_or_variance == 1 
        median_MWpen1LOLUS = ranksum(firstLOpen,LUSpen);
        median_MWpenLUS2LO = ranksum(LUSpen,secondLOpen); 
        median_MWpen1LO2LO = ranksum(firstLOpen,secondLOpen);

        median_MWsham1LOLUS = ranksum(firstLOsham,LUSsham);
        median_MWshamLUS2LO = ranksum(LUSsham,secondLOsham); 
        median_MWsham1LO2LO = ranksum(firstLOsham,secondLOsham); 
    else
        var_MW_pen_1LOLUS = ranksum(firstLOpen, LUSpen) ; 
        var_MW_pen_LUS2LO = ranksum(LUSpen, secondLOpen) ; 
        var_MWpen1LO2LO = ranksum(firstLOpen,secondLOpen);

        var_MW_sham_1LOLUS = ranksum(firstLOsham, LUSsham) ; 
        var_MW_sham_LUS2LO = ranksum(LUSsham, secondLOsham) ;
        var_MWsham1LO2LO = ranksum(firstLOsham,secondLOsham); 
    end 
% end 


%% QQ plots (for median analysis) 

if medians_or_variance == 1 
     figure(4) 
     firstLOqq = qqplot(firstLOpen,firstLOsham) ;
     title('QQ plot of pen vs sham 1LO event median rms values')
    %  hold on 
    %  plot(0:1:6, 0:1:6)

     figure(5) 
     LUSqq = qqplot(LUSpen,LUSsham) ;
     title('QQ plot of pen vs sham L+US event median rms values')

     figure(6) 
     secondLOqq = qqplot(secondLOpen,secondLOsham) ;
     title('QQ plot of pen vs sham 2LO event median rms values')
end  
 
% %% two-sample F-test for equal variances 
% % returns a test decision for the null hypothesis that the data in vectors x and y comes from normal distributions with the same variance
% % The result h is 1 if the test rejects the null hypothesis at the 5% significance level, and 0 otherwise.
% if medians_or_variance == 1 
%     % intercohort 
%     [F_decision_1LO,F_pvalue_1LO] = vartest2(firstLOpen,firstLOsham);
%     [F_decision_LUS,F_pvalue_LUS] = vartest2(LUSpen,LUSsham);
%     [F_decision_2LO,F_pvalue_2LO] = vartest2(secondLOpen,secondLOsham);
%     % intracohort 
%     % pen 
%     [F_decision_pen_1LOLUS,F_pvalue_pen_1LOLUS] = vartest2(firstLOpen,LUSpen);
%     [F_decision_pen_LUS2LO,F_pvalue_pen_LUS2LO] = vartest2(LUSpen,secondLOpen);
%     [F_decision_pen_1LO2LO,F_pvalue_pen_1LO2LO] = vartest2(firstLOpen,secondLOpen);
%     % sham 
%     [F_decision_sham_1LOLUS,F_pvalue_sham_1LOLUS] = vartest2(firstLOsham,LUSsham);
%     [F_decision_sham_LUS2LO,F_pvalue_sham_LUS2LO] = vartest2(LUSsham,secondLOsham);
%     [F_decision_sham_1LO2LO,F_pvalue_sham_1LO2LO] = vartest2(firstLOsham,secondLOsham);
% end 


 