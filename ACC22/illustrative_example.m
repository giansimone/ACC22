%% illustrative_example.m
%%% MARCH 4, 2022

clear
close all 

%% Create the object 's' from the class 'simulator'
s = simulator;
s.tf = 50;

%% Execute the simulation until the first perturbation
s = s.simulate_model;
t = s.t;
x = s.x;
u = s.parameters('c') * ones(size(s.t));

%% Execute the simulation until the second perturbation
s.parameters('c') = .5 * s.parameters('c');
s.init_conditions('my') = s.x(end, 1);
s.init_conditions('py') = s.x(end, 2);
s.init_conditions('mz') = s.x(end, 3);
s.init_conditions('pz') = s.x(end, 4);
s = s.simulate_model;
t = [t; t(end) + s.t(2:end)];
x = [x; s.x(2:end, :)];
u = [u(1:end-1); s.parameters('c') * ones(size(s.t))];

%% Execute the simulation until the end
s.parameters('c') = 0.5 * s.parameters('c');
s.init_conditions('my') = s.x(end, 1);
s.init_conditions('py') = s.x(end, 2);
s.init_conditions('mz') = s.x(end, 3);
s.init_conditions('pz') = s.x(end, 4);
s = s.simulate_model;
t = [t; t(end) + s.t(2:end)];
x = [x; s.x(2:end, :)];
u = [u(1:end-1); s.parameters('c') * ones(size(s.t))];

%% Plot the simulation
F = figure('Position',[0 0 480 320]);
set(F, 'defaultLineLineWidth', 2)
set(F, 'defaultAxesFontSize', 16)
subplot(3, 1, [1, 2]);
plot(t, x(:,2), t, x(:,4));
ylabel('Concentration (nM)');
legend('p_y', 'p_z');
subplot(3, 1, 3);
plot(t, u)
legend('c')
xlabel('Time (h)');
ylim([0, +inf])