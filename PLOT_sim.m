% MIT License
% 
% Copyright (c) 2016 Sotiris Papatheodorou
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

% Plot simulation for area coverage of a convex region by circular sensors
% Created 8/10/2016

clear variables
close all


%%%%%%%%%%%%%%%%%%%%%%%%%% Set plot settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation to load
sim1 = 'sim_FREE_ARCS_inreg_20161217_1759.mat';

% Plots to show
TRAJECTORIES = 1;
OBJECTIVE = 0;
AREA = 0;
OBJECTIVE_AREA = 0;
FINAL = 0;
INITIAL = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add function path
addpath( genpath('Functions') );

% Load simulations
s1 = load(sim1);
s1.axis_scale = [-0.5 2.5 0 2.5];


%%%%%%%%%% Plot trajectories %%%%%%%%%%
if TRAJECTORIES
	figure('name','trajectories')
	hold on
	
	% Simulation 1
	h1 = plot( squeeze( s1.xstorage(1,:,:) )', ...
		squeeze( s1.xstorage(2,:,:) )', 'b');
	hi = plot( squeeze( s1.xstorage(1,:,1) )', ...
		squeeze( s1.xstorage(2,:,1) )', 'ko');
	plot( squeeze( s1.xstorage(1,:,end) )', ...
		squeeze( s1.xstorage(2,:,end) )', 'bs');
	plot_poly( s1.region, 'k' );
	
	axis( s1.axis_scale );
    axis off
	axis equal
end


%%%%%%%%%% Plot objective %%%%%%%%%%
if OBJECTIVE
	figure
	hold on
	
	% Simulation 1
	t1 = linspace(0, s1.Tstep*s1.smax, s1.smax);
	Hmax1 = 0;
    for i=1:s1.N
        Hmax1 = Hmax1 + pi * (s1.sradii(i)-s1.uradii(i))^2;
    end
	plot(t1, 100*s1.H/Hmax1, 'b');

	xlabel('Time (s)')
	ylabel('H (% of maximum)')
	title('Coverage Objective')
	axis([0 max(t1(end), t2(end)) 0 100])
end


%%%%%%%%%% Plot area %%%%%%%%%%
if AREA
	figure
	hold on
	
	% Simulation 1
	t1 = linspace(0, s1.Tstep*s1.smax, s1.smax);
	Amax1 = polyarea_nan(s1.region(1,:), s1.region(2,:));
	plot(t1, 100*s1.covered_area/Amax1, 'b');

	xlabel('Time (s)')
	ylabel('Area (% of maximum)')
	title('Covered area')
	axis([0 max(t1(end), t2(end)) 0 100])
end


%%%%%%%%%% Plot objective and area %%%%%%%%%%
if OBJECTIVE_AREA
	figure
	hold on
	
	% Simulation 1
	t1 = linspace(0, s1.Tstep*s1.smax, s1.smax);
	Amax1 = polyarea_nan(s1.region(1,:), s1.region(2,:));
    Hmax1 = 0;
    for i=1:s1.N
        Hmax1 = Hmax1 + pi * (s1.sradii(i)-s1.uradii(i))^2;
    end
	plot(t1, 100*s1.H/Hmax1, 'b');
	plot(t1, 100*s1.covered_area/Amax1, 'b--');

	xlabel('Time (s)')
	ylabel('% of maximum')
	title('Covered area and coverage objective')
	legend('Coverage objective', 'Covered area', 'Location','southeast');
	axis([0 t1(end) 0 100])
end

if FINAL
    % Create sim struct, used for plots
    sim = struct;
    sim.plot_cells = 1;
    sim.plot_rcells = 0;
    sim.plot_comm = 0;
    sim.region = s1.region;
    sim.x = squeeze( s1.xstorage(:,:,end) );
    sim.uradii = s1.uradii;
    sim.sradii = s1.sradii - s1.uradii;
    sim.cradii = s1.cradii;
    sim.axis = s1.axis_scale;
    sim.cells = cell([1 s1.N]);
    sim.rcells = cell([1 s1.N]);
    sim.in_range = cell([1 s1.N]);
    % Find cells
    for i=1:s1.N
        sim.in_range{i} = in_comms_range( sim.x, i, sim.cradii(i) );
		% Put point i first in the list of neighbors
		sim.in_range{i} = [i sim.in_range{i}];
        tmpx = sim.x(:,sim.in_range{i});

        % Find the cell of each node based on its neighbors
        sim.cells{i} = GV_cell( sim.region, tmpx, sim.uradii, 1 );
        sim.rcells{i} = rad_cell( sim.x(:,i) , sim.cells{i} , sim.sradii(i));
    end
    
    figure('name','Final')
    plot_sim( sim );
    
    % Fill uncertainty disks
    for i=1:s1.N
        fill_circle( sim.x(1:2,i) , sim.uradii(i) , 'k');
    end
end

if INITIAL
    % Create sim struct, used for plots
    sim = struct;
    sim.plot_cells = 1;
    sim.plot_rcells = 0;
    sim.plot_comm = 0;
    sim.region = s1.region;
    sim.x = squeeze( s1.xstorage(:,:,1) );
    sim.uradii = s1.uradii;
    sim.sradii = s1.sradii - s1.uradii;
    sim.cradii = s1.cradii;
    sim.axis = s1.axis_scale;
    sim.cells = cell([1 s1.N]);
    sim.rcells = cell([1 s1.N]);
    sim.in_range = cell([1 s1.N]);
    % Find cells
    for i=1:s1.N
        sim.in_range{i} = in_comms_range( sim.x, i, sim.cradii(i) );
		% Put point i first in the list of neighbors
		sim.in_range{i} = [i sim.in_range{i}];
        tmpx = sim.x(:,sim.in_range{i});

        % Find the cell of each node based on its neighbors
        sim.cells{i} = GV_cell( sim.region, tmpx, sim.uradii, 1 );
        sim.rcells{i} = rad_cell( sim.x(:,i) , sim.cells{i} , sim.sradii(i));
    end
    
    figure('name','Initial')
    plot_sim( sim );
    
    % Fill uncertainty disks
    for i=1:s1.N
        fill_circle( sim.x(1:2,i) , sim.uradii(i) , 'k');
    end
end
