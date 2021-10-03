%% main_code.m
%%% OCTOBER 3, 2021

close all 

%% Create the object 's' from the class 'simulator'
s = simulator;

s.tf = 1000;

s.parameters('c') = 1e-5;

%% Execute the simulation
s = s.simulate_model;

%% Plot the simulation
s.plot_simulation;