%% make_analysis4tradeoff.m
%%% OCTOBER 10, 2021

clear

%% Create the table 'tab'
tab_var = {'alpha_z', 'kappa_z'};
az_arr = [1; 1; 1; 1; 1];
kz_arr = [1; 2; 4; 8; 16];

tab = table(az_arr, kz_arr, 'VariableNames', tab_var);

%% Create the vector 'c_arr'
c_arr = linspace(1e-1, 100, 1000);
% c_arr = logspace(-1, 2, 1000);
dim_arr = length(c_arr);

%% Exploring the parameter space
for q = 1:size(tab,1)
    tmp_az = table2array(tab(q,1));
    tmp_kz = table2array(tab(q,2));
    file_str = ['./ss_tradeoff_az', num2str(tmp_az), '_kz', ...
        num2str(tmp_kz), '_data.mat'];
    %% Create the object 's' from the class 'simulator'
    if ~isfile(file_str)
        disp([file_str, ' found'])
        %% Create the object 's_cinf'
        s_cinf = simulator;
        s_cinf.tf = 100;
        s_cinf.parameters('az') = tmp_az;
        s_cinf.parameters('kz') = tmp_kz;
        s_cinf.parameters('c') = 10^100;
        %% Execute the simulation
        s_cinf = s_cinf.simulate_model;
        
        %% Create the object 's_cmin'
        s_cmin = simulator;
        s_cmin.tf = 100;
        s_cmin.parameters('az') = tmp_az;
        s_cmin.parameters('kz') = tmp_kz;
        
        %% Create the object 's_cinf_wz0'
        s_cmin_wz0 = simulator;
        s_cmin_wz0.tf = 100;
        s_cmin_wz0.parameters('az') = 0;
        s_cmin_wz0.parameters('kz') = tmp_kz;
        
        %% Allocate 'E' and 'S'
        E = nan(1, dim_arr);
        S = nan(1, dim_arr);
        
        for z = 1:dim_arr
            disp([num2str(z), '/', num2str(dim_arr)]);
            %% Execute the simulation
            s_cmin.parameters('c') = c_arr(z);
            s_cmin = s_cmin.simulate_model;
            
            %% Execute the simulation
            s_cmin_wz0.parameters('c') = c_arr(z);
            s_cmin_wz0 = s_cmin_wz0.simulate_model;
            
            %% Calculate 'E' and 'S'
            E(z) = s_cinf.x(end,2) / s_cmin.x(end,2) - 1;
            S(z) = s_cmin.x(end,2) / s_cmin_wz0.x(end,2);
        end
        %% Save data results
        save(file_str, 'c_arr', 'tmp_az', 'tmp_kz', 'E', 'S');
        clear s S E file_str tmp_az tmp_kz
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
    file_str = ['./ss_tradeoff_az', num2str(tmp_az), '_kz', ...
        num2str(tmp_kz), '_data.mat'];
    load(file_str);
    loglog(E, S);
    hold on
end
xlabel('Stabilisation error E');
ylabel('Stabilised promoter strength S');
ylim([.5,1])