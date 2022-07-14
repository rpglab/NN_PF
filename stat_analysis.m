clear;
clc;
bus = 9;

test = readmatrix(['Result\V_',num2str(bus),'_Bus_Test.csv']);
pred = readmatrix(['Result\V_',num2str(bus),'_Bus_Predict.csv']);

close all;
diff = abs(pred - test);
max_diff = max(diff,[],2);
avg_diff = mean(diff,2);
std_diff = std(diff,0,2);
figure;
hold on;
errorbar(avg_diff,std_diff);
plot(max_diff);
title([num2str(bus),' Bus Absolute Value Difference in Voltage Magnitude'])
legend('Average Difference', 'Maximum Difference')
xlabel('Bus')
ylabel('MVA')
saveas(gcf,['Stat_Graph\V_',num2str(bus),'_Absolute_Error.png']);


error = abs((pred - test)./test) * 100;
max_error = max(error,[],2);
avg_error = mean(error,2);
std_error = std(error,0,2);
figure;
hold on;
errorbar(avg_error,std_error);
plot(max_error);
title([num2str(bus),' Bus Percent Error Difference in Voltage Magnitude'])
legend('Average Error','Maximum Error')
xlabel('Bus')
ylabel('Percent(%)')
saveas(gcf,['Stat_Graph\V_',num2str(bus),'_Percent_Error.png']);


%%

clear;
clc;
bus = 118;

test = readmatrix(['Result\S_',num2str(bus),'_Bus_Test.csv']);
pred = readmatrix(['Result\S_',num2str(bus),'_Bus_Predict.csv']);
testdc = readmatrix(['Result\S_',num2str(bus),'_Bus_DC.csv']);

close all;

% Absolute Value Comparison
diff = abs(pred - test);
max_diff = max(diff,[],2);
min_diff = min(diff,[],2);
med_diff = median(diff,2);
avg_diff = mean(diff,2);
std_diff = std(diff,0,2);
figure;
hold on;
errorbar(avg_diff,std_diff);
plot(max_diff);
title([num2str(bus),' Bus Absolute Value Difference in P Power Flow'])
legend('Average Difference', 'Maximum Difference')
xlabel('Branch')
ylabel('MW')
saveas(gcf,['Stat_Graph\P_',num2str(bus),'_Absolute_Error.png']);
abs_table = [ mean(diff,'all') max(diff,[],'all') min(diff,[],'all') median(diff,'all') std(diff,0,'all') ];
display(abs_table);


% DC Absolute Value Comparison
dc_diff = abs(testdc - test);
dc_max_diff = max(dc_diff,[],2);
dc_min_diff = min(dc_diff,[],2);
dc_med_diff = median(dc_diff,2);
dc_avg_diff = mean(dc_diff,2);
dc_std_diff = std(dc_diff,0,2);
figure;
hold on;
errorbar(dc_avg_diff,dc_std_diff);
plot(dc_max_diff);
title([num2str(bus),' Bus Absolute Value Difference in DC Power Flow'])
legend('Average Difference', 'Maximum Difference')
xlabel('Branch')
ylabel('MW')
saveas(gcf,['Stat_Graph\P_',num2str(bus),'_DC_Absolute_Error.png']);
abs_dc_table = [ mean(dc_diff,'all') max(dc_diff,[],'all') min(dc_diff,[],'all') median(dc_diff,'all') std(dc_diff,0,'all') ];
display(abs_dc_table);

figure;
hold on;
plot(avg_diff);
plot(dc_avg_diff);
title([num2str(bus),' Bus Average Absolute Value Difference (NN vs. DC) Power Flow'])
legend('NN', 'DC')
xlabel('Branch')
ylabel('MW')
saveas(gcf,['Stat_Graph\P_',num2str(bus),'_Average_Absolute_Error.png']);

figure;
hold on;
plot(max_diff);
plot(dc_max_diff);
title([num2str(bus),' Bus Maximum Absolute Value Difference (NN vs. DC) Power Flow'])
legend('NN', 'DC')
xlabel('Branch')
ylabel('MW')
saveas(gcf,['Stat_Graph\P_',num2str(bus),'_Maximum_Absolute_Error.png']);

% Percent Difference Comparison

avg_test = mean(test,2);
line_filter = 100;
index = find(avg_test >= line_filter); % for 9 bus use 10


error = 2 * abs(pred - test)./ abs(pred + test) * 100;
error = error(index,:);
max_error = max(error,[],2);
min_error = min(error,[],2);
med_error_ = median(error,2);
avg_error = mean(error,2);
std_error = std(error,0,2);
figure;
hold on;
errorbar(avg_error,std_error);
plot(max_error);
title([num2str(bus),' Bus Percent Error Difference in P Power Flow'])
legend('Average Error','Maximum Error')
xlabel('Branch')
xticks('manual')
xticklabels(index)
ylabel('Percent(%)')
saveas(gcf,['Stat_Graph\P_',num2str(bus),'_Percent_Error.png']);
err_table = [ mean(error,'all') max(error,[],'all') min(error,[],'all') median(error,'all') std(error,0,'all') ];
display(err_table);

% DC Percent Difference Comparison

dc_error = 2 * abs(testdc - test)./ abs(testdc + test) * 100;
dc_error = dc_error(index,:);
dc_max_error = max(dc_error,[],2);
dc_min_error = min(dc_error,[],2);
dc_med_error_ = median(dc_error,2);
dc_avg_error = mean(dc_error,2);
dc_std_error = std(dc_error,0,2);
figure;
hold on;
errorbar(dc_avg_error,dc_std_error);
plot(dc_max_error);
title([num2str(bus),' Bus Percent Error Difference in DC Power Flow'])
legend('Average Error','Maximum Error')
xlabel('Branch')
xticks('manual')
xticklabels(index)
ylabel('Percent(%)')
saveas(gcf,['Stat_Graph\P_',num2str(bus),'_DC_Percent_Error.png']);
dc_err_table = [ mean(dc_error,'all') max(dc_error,[],'all') min(dc_error,[],'all') median(dc_error,'all') std(dc_error,0,'all') ];
display(dc_err_table);

figure;

bar(index,[avg_error dc_avg_error]);
title([num2str(bus),' Bus Average Percent Error Difference (NN vs. DC) Power Flow For Line Above ', num2str(line_filter),'MW'])
legend('NN', 'DC')
xlabel('Branch')
ylabel('Percent(%)')
xticklabels(index)
set (gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);
saveas(gcf,['Stat_Graph\P_',num2str(bus),'_Average_Percent_Error.png']);


figure;

bar(index,[max_error dc_max_error]);
title([num2str(bus),' Bus Maximum Percent Error Difference (NN vs. DC) Power Flow For Line Above ', num2str(line_filter),'MW'])
legend('NN', 'DC')
xlabel('Branch')
ylabel('Percent(%)')
xticks(index)
set (gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);
saveas(gcf,['Stat_Graph\P_',num2str(bus),'_Maximum_Percent_Error.png']);


writematrix(abs_table   ,'Result.xlsx','Sheet',[num2str(bus) ' bus'],'Range','B2');
writematrix(abs_dc_table,'Result.xlsx','Sheet',[num2str(bus) ' bus'],'Range','B3');
writematrix(err_table   ,'Result.xlsx','Sheet',[num2str(bus) ' bus'],'Range','B7');
writematrix(dc_err_table,'Result.xlsx','Sheet',[num2str(bus) ' bus'],'Range','B8');

%%

clear;
clc;
bus = 24;

test = readmatrix(['Result\S_',num2str(bus),'_Bus_Test.csv']);
pred = readmatrix(['Result\S_',num2str(bus),'_Bus_Predict.csv']);

close all;
diff = abs(pred - test);
avg_test = mean(test,2);
avg_pred = mean(pred,2);


error = abs((pred - test)./test) * 100;
max_error = max(error,[],2);
avg_error = mean(error,2);
std_error = std(error,0,2);

for i = 1:length(avg_test)
    if avg_test(i) <= 200
        avg_error(i) = 0;       
        std_error(i) = 0; 
    end
end


figure;
hold on;
errorbar(avg_error,std_error);
% plot(avg_error);
title([num2str(bus),' Bus Percent Error Difference in S Power Flow'])
legend('Average Error','Maximum Error')
xlabel('Branch')
ylabel('Percent(%)')
saveas(gcf,['Stat_Graph\S_',num2str(bus),'_Percent_Error.png']);