%% make_analysis.m
%%% OCTOBER 3, 2021

clear
close all 

%% Create the object 's' from the class 'simulator'
if ~isfile('./ss_output_data.mat')
    s = simulator;
    
    s.tf = 1000;
    
    c_arr = linspace(1e-5, 1e-1, 1000);
    dim_arr = length(c_arr);
    ss_output = nan(1, dim_arr);
    
    for z = 1:dim_arr
        disp([num2str(z), '/', num2str(dim_arr)]);
        s.parameters('c') = c_arr(z);
        %% Execute the simulation
        s = s.simulate_model;
        ss_output(z) = s.x(end,4);
    end
    
    %% Save data results
    save('./ss_output_data.mat', 'c_arr', 'ss_output');
end

%% Plot analysis
clear
F = figure('Position', [0 0 360 360]);
set(F, 'defaultLineLineWidth', 2);
set(F, 'defaultAxesFontSize', 16);
load('./ss_output_data.mat');
plot(c_arr, ss_output);
xlabel('Plasmid copy number (uM)');
ylabel('Steady-state output (uM)');
ylim([0,4])