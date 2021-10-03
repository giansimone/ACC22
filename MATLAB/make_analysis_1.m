%% make_analysis_1.m
%%% SEPTEMBER 16, 2021

clear
close all 

%% Create the object 's' from the class 'simulator'
s = simulator;

s.tf = 40;
s.parameters('az') = 400;
s.parameters('kz') = 5;

c_arr = 1e-3:1e-3:.4;
dim_arr = length(c_arr);
pgss = nan(1, dim_arr);

for z = 1:dim_arr
    disp(num2str(z));
    s.parameters('c') = c_arr(z);
    %% Execute the simulation
    s = s.simulate_model;
    pgss(z) = s.x(end,4);
end

%% Save data results
save('./MAT_data/results_analysis_4', 'c_arr', 'pgss');

%% Plot analysis
clear
str_var = {'\alpha_z = 100 and \kappa_z = 15', '\alpha_z = 100 and \kappa_z = 1.5', '\alpha_z = 400 and \kappa_z = 1.5'};
str_var = {'a_z = 100 and k_z = 15', 'a_z = 100 and k_z = 1.5', 'a_z = 400 and k_z = 1.5'};
F = figure('Position',[0 0 360 360]);
set(F, 'defaultLineLineWidth', 2)
set(F, 'defaultAxesFontSize', 16)
for z = 1:3
    load(['./MAT_data/results_analysis_' num2str(z)]);
    plot(c_arr, pgss);
    hold on;
end
xlabel('Plasmid copy number c (uM)');
ylabel('Steady-state concentration (uM)');
legend(str_var);