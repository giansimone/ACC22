%% make_analysis.m
%%% OCTOBER 4, 2021

clear

%% Create the table 'tab'
tab_var = {'alpha_z', 'kappa_z'};
az_arr = [1; 1; 1; 1; 1];
kz_arr = [1; 2; 4; 8; 16];

tab = table(az_arr, kz_arr, 'VariableNames', tab_var);

%% Create the vector 'c_arr'
c_arr = linspace(1e-1, 100, 1000);
% c_arr = logspace(-2, 2, 20);
dim_arr = length(c_arr);

%% Exploring the parameter space
for q = 1:size(tab,1)
    tmp_az = table2array(tab(q,1));
    tmp_kz = table2array(tab(q,2));
    file_str = ['./ss_output_az', num2str(tmp_az), '_kz', ...
        num2str(tmp_kz), '_data.mat'];
    %% Create the object 's' from the class 'simulator'
    if ~isfile(file_str)
        disp([file_str, ' found'])
        s = simulator;
        s.tf = 100;
        s.parameters('az') = tmp_az;
        s.parameters('kz') = tmp_kz;

        ss_output = nan(1, dim_arr);
        
        for z = 1:dim_arr
            disp([num2str(z), '/', num2str(dim_arr)]);
            s.parameters('c') = c_arr(z);
            %% Execute the simulation
            s = s.simulate_model;
            ss_output(z) = s.x(end,4);
        end
        %% Save data results
        save(file_str, 'c_arr', 'tmp_az', 'tmp_kz', 'ss_output');
        clear s ss_output file_str tmp_az tmp_kz
    end
end

%% Plot analysis
clearvars -except tab
close all
F = figure('Position', [0 0 360 360]);
set(F, 'defaultLineLineWidth', 2);
set(F, 'defaultAxesFontSize', 16);
%% Plot steady-state concentrations
for q = 1:size(tab,1)
    tmp_az = table2array(tab(q,1));
    tmp_kz = table2array(tab(q,2));
    file_str = ['./ss_output_az', num2str(tmp_az), '_kz', ...
        num2str(tmp_kz), '_data.mat'];
    load(file_str);
    plot(c_arr, ss_output);
    hold on
end
xlabel('Plasmid concentration c (nM)');
ylabel('Steady-state concentration py (nM)');