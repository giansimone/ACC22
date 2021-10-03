%% make_analysis.m
%%% OCTOBER 3, 2021

clear
close all 

%% Create the object 's' from the class 'simulator'
if ~isfile('./ss_output_data.mat')
    s = simulator;
    
    s.tf = 1000;
    
    c_arr = 1e-3:1e-3:.4;
    dim_arr = length(c_arr);
    ss_output = nan(1, dim_arr);
    
    for z = 1:dim_arr
        disp(num2str(z));
        s.parameters('c') = c_arr(z);
        %% Execute the simulation
        s = s.simulate_model;
        ss_output(z) = s.x(end,4);
    end
    
    %% Save data results
    save('./ss_data.mat', 'c_arr', 'pgss');
end

%% Plot analysis
clear
F = figure('Position',[0 0 360 360]);
set(F, 'defaultLineLineWidth', 2)
set(F, 'defaultAxesFontSize', 16)
load(['./MAT_data/results_analysis_' num2str(z)]);
plot(c_arr, ss_output);
xlabel('Plasmid concentration c (uM)');
ylabel('Steady-state concentration (uM)');
legend(str_var);