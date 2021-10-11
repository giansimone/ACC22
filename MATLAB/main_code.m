%% main_code.m
%%% OCTOBER 4, 2021

close all 

%% Create the object 's' from the class 'simulator'
s = simulator;

s.tf = 100;

s.parameters('az') = 0;
% s.parameters('kz') = 100;
% s.parameters('c') = 10^100;

%% Execute the simulation
s = s.simulate_model;

%% Plot the simulation
s.plot_simulation;