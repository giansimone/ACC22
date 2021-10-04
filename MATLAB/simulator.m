%% simulator.m
%%% OCTOBER 4, 2021

classdef simulator
    
    properties (SetAccess = protected)
        x0;
        t;
        x;
% %         mu;
    end
    
    properties (SetAccess = public)
        opt = odeset('RelTol', 1e-12, 'AbsTol', 1e-16);
        tf = 100;
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
% %             obj = obj.get_growth_rate;
        end
        
        function plot_simulation(obj)
            str_var = {'m_y', 'p_y', 'm_z', 'p_z'};
            F = figure('Position',[0 0 320 320]);
            set(F, 'defaultLineLineWidth', 2)
            set(F, 'defaultAxesFontSize', 16)
            plot(obj.t, obj.x(:,2), obj.t, obj.x(:,4));
            xlabel('Time (h)');
            ylabel('Concentration (nM)');
            legend(str_var{[2,4]});
            title(['c = ' num2str(obj.parameters('c')) ' (uM)']); 
        end
        
    end
    
    methods (Access = protected)
        
        function obj = set_default_init_conditions(obj)
            obj.init_conditions = containers.Map('KeyType', 'char', ...
            'ValueType', 'double');
        
            obj.init_conditions('my') = 0;
            obj.init_conditions('py') = 0;
            obj.init_conditions('mz') = 0;
            obj.init_conditions('pz') = 0;
        end
        
        function obj = set_default_parameters(obj)
            obj.parameters = containers.Map('KeyType', 'char', ...
                'ValueType', 'double');
            
            obj.parameters('c') = 100; % (nM)
            obj.parameters('r0') = 1000; % (nM)
            obj.parameters('ay') = 1; % (/h)
            obj.parameters('by') = 1; % (/h)
            obj.parameters('gy') = 1; % (/h)
            obj.parameters('dy') = .347; % (/h) % Half-life ~ 2 hours
            obj.parameters('ky') = 1; % (nM)
            obj.parameters('az') = 1; % (/h)
            obj.parameters('bz') = 1; % (/h)
            obj.parameters('gz') = 1; % (/h)
            obj.parameters('dz') = .347; % (/h) % Half-life ~ 2 hours
            obj.parameters('kz') = 1; % (nM)
% %             obj.parameters('mu0') = .4; % (/h)
% %             obj.parameters('Kmu') = 0.07; % (uM)
        end
        
        function obj = set_x0(obj)
            obj.x0 = [
                      obj.init_conditions('my');
                      obj.init_conditions('py');
                      obj.init_conditions('mz');
                      obj.init_conditions('pz');
                      ];
        end
        
% %         function obj = get_growth_rate(obj)
% %             n = length(obj.t);
% %             obj.mu = nan(n,1);
% %             for z = 1:n
% %                 xTemp = obj.x(z,:).';
% %                 [~, muTemp] = obj.ss_model(NaN, xTemp);
% %                 obj.mu(z) = muTemp;
% %             end
% %         end
        
        function dxdt = ss_model(obj, ~, x)
% %         function [dxdt, muTemp] = ss_model(obj, ~, x)
            %% Assign the parameters' map to the variable p
            par = obj.parameters;
            
            %% Assign the state x to the single variables
            my = x(1);
            py = x(2);
            mz = x(3);
            pz = x(4);
            
% %             %% Compute growth rate mu
% %             muTemp = par('mu0') .* par('r0') ./ (par('r0') + par('Kmu') .* (...
% %                 1 + my ./ par('ky') + mz ./ par('kz')));
            
            %% Assign the vector state dxdt
            dxdt = [
                    par('c') .* par('ay') - par('by') .* my;
                    par('gy') .* (my ./ par('ky')) ./ (1 + my ./ par('ky') + mz ./ par('kz')) .* par('r0') - par('dy') .* py;
                    par('c') .* par('az') - par('bz') .* mz;
                    par('gz') .* (mz ./ par('kz')) ./ (1 + my ./ par('ky') + mz ./ par('kz')) .* par('r0') - par('dz') .* pz;
                    ];
        end
        
    end
    
end