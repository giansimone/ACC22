%% simulator.m
%%% JUNE 28, 2021

classdef simulator
    
    properties (SetAccess = protected)
        x0;
        t;
        x;
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
            [obj.t, obj.x] = ode15s(@obj.model_odes, [0, obj.tf], ...
                obj.x0, obj.opt);
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
            obj.parameters('dz') = .4; % (/h)
            obj.parameters('kz') = 15; % (mM)
            obj.parameters('ag') = 100; % (/h)
            obj.parameters('bg') = 5; % (/h)
            obj.parameters('gg') = 100; % (/h)
            obj.parameters('dg') = .4; % (/h)
            obj.parameters('kg') = 15; % (mM)
        end
        
        function obj = set_x0(obj)
            obj.x0 = [
                      obj.init_conditions('mz');
                      obj.init_conditions('pz');
                      obj.init_conditions('mg');
                      obj.init_conditions('pg');
                      ];
        end
        
        function dxdt = model_odes(obj, ~, x)
            %% Assign the parameters' map to the variable p
            par = obj.parameters;
            
            %% Assign the state x to the single variables
            mz = x(1);
            pz = x(2);
            mg = x(3);
            pg = x(4);
            
            %% Assign the vector state dxdt
            dxdt = [
                    par('c') .* par('az') - par('bz') .* mz;
                    par('gz') .* (mz ./ par('kz')) ./ (1 + mz ./ par('kz') + mg ./ par('kg')) .* par('rt') - par('dz') .* pz;
                    par('c') .* par('ag') - par('bg') .* mg;
                    par('gg') .* (mg ./ par('kg')) ./ (1 + mz ./ par('kz') + mg ./ par('kg')) .* par('rt') - par('dg') .* pg;
                    ];
        end
        
    end
    
end