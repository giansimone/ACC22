%% main_code.m
%%% JUNE 28, 2021

close all 

%% Create the object 's' from the class 'simulator'
s = simulator;

s.tf = 40;
s.parameters('c') = .4;

%% Execute the simulation
s = s.simulate_model;

%% Plot the simulation
s.plot_simulation;