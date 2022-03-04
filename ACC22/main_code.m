%% main_code.m
%%% MARCH 4, 2022

clear
close all 

%% Create the object 's' from the class 'simulator'
s = simulator;

s.tf = 100;

%% Execute the simulation
s = s.simulate_model;

%% Plot the simulation
s.plot_simulation;