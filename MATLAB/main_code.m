%% main_code.m
%%% AUGUST 12, 2021

close all 

%% Create the object 's' from the class 'simulator'
s = simulator;

s.tf = 100;
s.parameters('c') = .1;
s.parameters('Kmu') = 0.01;
s.parameters('az') = 400;
s.parameters('kz') = 1.5;
s.parameters('dg') = 0.6;
s.parameters('dz') = 0.6;

%% Execute the simulation
s = s.simulate_model;

%% Plot the simulation
s.plot_simulation;