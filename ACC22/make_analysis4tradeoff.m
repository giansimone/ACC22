%% make_analysis4tradeoff.m
%%% MARCH 4, 2022

clear

%%
cmin = 1; % (nM)

%% Create the vector 'kz_arr'
kz_arr = logspace(-2, 2, 1000);
dim_arr = length(kz_arr);

%% Create the object 's' from the class 'simulator'
file_str = './ss_tradeoff_data.mat';
if ~isfile(file_str)
    disp([file_str, 'File not found'])
    %% Create the simulate object 's_cmin_wz0'
    s_cmin_wz0 = simulator;
    s_cmin_wz0.tf = 100;
    s_cmin_wz0.parameters('c') = cmin;
    s_cmin_wz0.parameters('az') = 0; % (nM)
    
    s_cmin_wz0 = s_cmin_wz0.simulate_model;
    
    %% Create the object 's_cinf'
    s_cinf = simulator;
    s_cinf.tf = 100;
    s_cinf.parameters('c') = 1e+100; % (nM)
    
    %% Create the object 's_cmin'
    s_cmin = simulator;
    s_cmin.tf = 100;
    s_cmin.parameters('c') = cmin;
    
    %% Allocate 'E' and 'S'
    E = nan(1, dim_arr);
    S = nan(1, dim_arr);
    
    for z = 1:dim_arr
        disp([num2str(z), '/', num2str(dim_arr)]);
        %% Simulate the object 's_cinf'
        s_cinf.parameters('kz') = kz_arr(z);
        s_cinf = s_cinf.simulate_model;
        
        %% Simulate the object 's_cmin'
        s_cmin.parameters('kz') = kz_arr(z);
        s_cmin = s_cmin.simulate_model;
        
        %% Calculate 'E' and 'S'
        E(z) = s_cinf.x(end,2) / s_cmin.x(end,2) - 1;
        S(z) = s_cmin.x(end,2) / s_cmin_wz0.x(end,2);
    end
    %% Save data results
    save(file_str, 'kz_arr', 'cmin', 'E', 'S');
    clear s S E s_cinf s_cmin s_cmin_wz0
end

%% Plot analysis
clearvars -except file_str
close all
F = figure('Position', [0 0 360 360]);
set(F, 'defaultLineLineWidth', 2);
set(F, 'defaultAxesFontSize', 16);
%% Plot trade-off regime
load(file_str);
line_colour = parula(length(kz_arr));
scatter(E, S, [], kz_arr);
xlabel('Stabilisation error E');
ylabel('Stabilised promoter strength S');
set(gca,'ColorScale','log');
cb = colorbar;
cb.Label.String = '\kappa_z';