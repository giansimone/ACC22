%% simulator.m
%%% AUGUST 12, 2021

classdef simulator
    
    properties (SetAccess = protected)
        x0;
        t;
        x;
        mu;
    end
    
    properties (SetAccess = public)
        opt = odeset('RelTol', 1e-12, 'AbsTol', 1e-16);
        tf = 2;
        init_conditions;
        parameters;
    end
    
    methods (Access = public)
        
        function obj = simulator(tf) % Constructor
            if nargin == 1
                obj.tf = tf;
            end
            obj = obj.set_default_init_conditions;
            obj = obj.set_default_parameters;
        end
        
        function obj = simulate_model(obj)
            obj = obj.set_x0;
            [obj.t, obj.x] = ode15s(@obj.ss_model, [0, obj.tf], ...
                obj.x0, obj.opt);
            obj = obj.get_growth_rate;
        end
        
        function plot_simulation(obj)
            str_var = {'m_z', 'p_z', 'm_g', 'p_g'};
            F = figure('Position',[0 0 320 320]);
            set(F, 'defaultLineLineWidth', 2)
            set(F, 'defaultAxesFontSize', 16)
            plot(obj.t, obj.x(:,2), obj.t, obj.x(:,4));
            xlabel('Time (h)');
            ylabel('Concentration (uM)');
            legend(str_var{[2,4]});
            title(['c = ' num2str(obj.parameters('c')) ' (uM)']); 
        end
        
    end
    
    methods (Access = protected)
        
        function obj = set_default_init_conditions(obj)
            obj.init_conditions = containers.Map('KeyType', 'char', ...
            'ValueType', 'double');
        
            obj.init_conditions('mz') = 0;
            obj.init_conditions('pz') = 0;
            obj.init_conditions('mg') = 0;
            obj.init_conditions('pg') = 0;
        end
        
        function obj = set_default_parameters(obj)
            obj.parameters = containers.Map('KeyType', 'char', ...
                'ValueType', 'double');
            
            obj.parameters('c') = .2; % (uM)
            obj.parameters('rt') = .14; % (uM)
            obj.parameters('az') = 100; % (/h)
            obj.parameters('bz') = 5; % (/h)
            obj.parameters('gz') = 100; % (/h)
            obj.parameters('dz') = .04; % (/h) %%%%%%%
            obj.parameters('kz') = 15; % (uM)
            obj.parameters('ag') = 100; % (/h)
            obj.parameters('bg') = 5; % (/h)
            obj.parameters('gg') = 100; % (/h)
            obj.parameters('dg') = .04; % (/h) %%%%%%
            obj.parameters('kg') = 15; % (uM)
            obj.parameters('mu0') = .4; % (/h)
            obj.parameters('Kmu') = 0.07; % (uM)
        end
        
        function obj = set_x0(obj)
            obj.x0 = [
                      obj.init_conditions('mz');
                      obj.init_conditions('pz');
                      obj.init_conditions('mg');
                      obj.init_conditions('pg');
                      ];
        end
        
        function obj = get_growth_rate(obj)
            n = length(obj.t);
            obj.mu = nan(n,1);
            for z = 1:n
                xTemp = obj.x(z,:).';
                [~, muTemp] = obj.ss_model(NaN, xTemp);
                obj.mu(z) = muTemp;
            end
        end
        
        function [dxdt, muTemp] = ss_model(obj, ~, x)
            %% Assign the parameters' map to the variable p
            par = obj.parameters;
            
            %% Assign the state x to the single variables
            mz = x(1);
            pz = x(2);
            mg = x(3);
            pg = x(4);
            
            %% Compute growth rate mu
            muTemp = par('mu0') .* par('rt') ./ (par('rt') + par('Kmu') .* (...
                1 + mz ./ par('kz') + mg ./ par('kg')));
            
            %% Assign the vector state dxdt
            dxdt = [
                    par('c') .* par('az') - par('bz') .* mz;
                    par('gz') .* (mz ./ par('kz')) ./ (1 + mz ./ par('kz') + mg ./ par('kg')) .* par('rt') - (par('dz') + muTemp) .* pz;
                    par('c') .* par('ag') - par('bg') .* mg;
                    par('gg') .* (mg ./ par('kg')) ./ (1 + mz ./ par('kz') + mg ./ par('kg')) .* par('rt') - (par('dg') + muTemp) .* pg;
                    ];
        end
        
    end
    
end