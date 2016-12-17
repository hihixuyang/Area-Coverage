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

clear variables
close all

%%%%%%%%%%%%%%%%%%%%%%%% Set simulation parameters %%%%%%%%%%%%%%%%%%%%%%%%
% Uncomment to select control law
% CTRL_LAW = 'CELL_CENTROID';
% CTRL_LAW = 'RCELL_CENTROID';
% CTRL_LAW = 'FREE_ARCS';
CTRL_LAW = 'GV_COMPLETE';
% CTRL_LAW = 'GV_COMPROMISE';

% Use a finite communication range
FINITE_COMM_RANGE = 0;
% Prevent robots from colliding when coming close
STOP_COLLISIONS = 0;
% Keep the nodes inside the region at all times
KEEP_IN_REGION = 1;
% Show the network state in each iteration
PLOT_STATE = 1;
% Save the network state in each iteration
SAVE_FRAMES = 0;
% Save the results to file
SAVE_RESULTS = 0;

% Common uncertainty disk radius. Can be set to differ between nodes
% Set to 0 for exact positioning
uncert_rad = 0.05;
% Common sensing disk radius. Must be common among nodes
sensing_rad = 0.5;
% Common communication radius. Can be set to differ between nodes
comm_rad = 0.8;

% Simulation duration in seconds
Tfinal = 5;
% Time step in seconds
Tstep = 0.1;
% Control law gain
a = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add function path
addpath( genpath('Functions') );


% Load region
region = importdata('Input Files/region.txt');
axis_scale = [ -0.5 3.5 -0.5 3.5 ];

% region = importdata('Input Files/region_pi.txt');
% sc = 0.6;
% axis_scale = [-sc sc -sc sc];

n = region(2);
region = region(3:end);
region = reshape(region, 2, n);
[xr , yr] = poly2cw(region(1,:), region(2,:));
region = [xr ; yr];
rdiameter = diameter(region);
rarea = polyarea_nan(region(1,:), region(2,:));


% Load nodes
% x = importdata('Input Files/2_nodes.txt');
% x = importdata('Input Files/3_nodes.txt');
x = importdata('Input Files/4_nodes.txt');
% x = importdata('Input Files/10_nodes.txt');
x = x(2:end);
N = length( x ) / 2;
x = reshape(x, 2, N);

%%%%%%%%% Set uncertainty, sensing and communication radii %%%%%%%%%%%%%%%%
% They can be set to differ between nodes here
uradii = uncert_rad * ones(1,N);
sradii = sensing_rad * ones(1,N);
cradii = comm_rad * ones(1,N);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~FINITE_COMM_RANGE
    cradii = 2 * rdiameter * ones(1,N);
end
% Use guaranteed sensing radii if there is uncertainty
sradii = sradii - uradii;

% Whether the robots have uncertain positions
if sum(uradii) == 0
    UNCERT = 0;
else
    UNCERT = 1;
end




tic;

% Initializations
smax = floor(Tfinal/Tstep);
s = 1;
move_vector = zeros(2,N);
x_new = zeros(2,N);
xstorage = zeros(2,N,smax);
covered_area = zeros(1,smax);
H = zeros(1,smax);
in_range = cell([1 N]);
GVcells = cell([1 N]);
GVrcells = cell([1 N]);

% Create sim struct that contains all information, used for plots
sim = struct;
sim.plot_cells = 1;
sim.plot_rcells = 0;
sim.plot_comm = FINITE_COMM_RANGE;
sim.region = region;
sim.x = x;
sim.uradii = uradii;
sim.sradii = sradii;
sim.cradii = cradii;
sim.cells = GVcells;
sim.rcells = GVrcells;
sim.in_range = in_range;
sim.axis = axis_scale;


if PLOT_STATE
    figure;
    hold on
end

while s <= smax
    fprintf('Iteration %d/%d  %.2f%%\n', s, smax, 100*s/smax)
    
    
	% Find the neighbors and cell of each node
	for i=1:N
		% Find the nodes in communication range of each node i
		in_range{i} = in_comms_range( x, i, cradii(i) );
		% Put node i first in the list of neighbors
		in_range{i} = [i in_range{i}];
		tmpx = x(:,in_range{i});

		% Find the cell of each node i based on its neighbors
		GVcells{i} = GV_cell( region, tmpx, uradii, 1 );
		GVrcells{i} = rad_cell( x(:,i) , GVcells{i} , sradii(i));

		% Update sim struct
		sim.cells = GVcells;
		sim.rcells = GVrcells;
		sim.in_range = in_range;
	end
	
	% Store values and covered area - objective function H
    xstorage(:,:,s) = x;
    covered_area(s) = total_covered_area(region, x, sradii);
	% If there is uncertainty, the objective H is not the covered area
    if UNCERT
		for i=1:N
            if ~isempty(GVrcells{i})
                H(s) = H(s) + polyarea_nan(GVrcells{i}(1,:), GVrcells{i}(2,:));
            end
		end
    else
        H(s) = covered_area(s);
    end
	
	
    % Plot network state
    if PLOT_STATE
        clf
        plot_sim( sim );
    end
    
    
    % Control law
    move_vector = zeros(2,N);
    for i=1:N % parfor slower
		% Select control law
        switch CTRL_LAW
            case 'CELL_CENTROID'
                move_vector(:,i) = ...
                    a * centroid_law( x(:,i), GVcells{i} );
            case 'RCELL_CENTROID'
                move_vector(:,i) = ...
                    a * centroid_law( x(:,i), GVrcells{i} );
            case 'FREE_ARCS'
                move_vector(:,i) = ...
                    a * C_integral_law_num( x(:,i), GVcells{i}, sradii(i) );
            case 'GV_COMPLETE'
                move_vector(:,i) = ...
                    a * C_integral_law_num( x(:,i), GVcells{i}, sradii(i) );
                %%%%%%% ADD DELAUNAY CHECK HERE %%%%%%%
				for j=1:N
					if i ~= j
						% Integral over Hij and Hji
						move_vector(:,i) = move_vector(:,i) + ...
						a * H_integral_law...
						( x(:,i), uradii(i), GVcells{i}, sradii(i),...
						  x(:,j), uradii(j), GVcells{j}, sradii(j), true );
					end
				end
            case 'GV_COMPROMISE'
                move_vector(:,i) = ...
                    a * C_integral_law_num( x(:,i), GVcells{i}, sradii(i) );
                %%%%%%% ADD DELAUNAY CHECK HERE %%%%%%%
				for j=1:N
					if i ~= j
						% Integral over Hij
						move_vector(:,i) = move_vector(:,i) + ...
						a * H_integral_law...
						( x(:,i), uradii(i), GVcells{i}, sradii(i),...
						  x(:,j), uradii(j), GVcells{j}, sradii(j), false );
					end
				end
        end
    end
    
    
    % Simulate with ode45
    Tspan = [s*Tstep (s+1)*Tstep];
    IC = [x(1,:) x(2,:)]';
    u = [move_vector(1,:) move_vector(2,:)]';
    [T, Xsim] = ode45(@(t,y) DYNAMICS_integrator(t, y, u), Tspan, IC);
	% Keep only the final state of the ODE simulation
    x(1,:) = Xsim(end , 1:N);
    x(2,:) = Xsim(end , N+1:end);

    
    % Make sure no nodes collide
    if STOP_COLLISIONS
        x_temp = x;
        for i=1:N
            x_temp(:,i) = no_collisions(region, x, i, uradii(i));
        end
        x = x_temp;
    end

    
    % Make sure the new position is inside the region
    if KEEP_IN_REGION
        for i=1:N
            x(:,i) = keep_in_region(region, x(:,i), uradii(i));
        end
    end
    
    % Update the sim struct with the new positions
    sim.x = x;


    % Pause for plot
    if PLOT_STATE
		if SAVE_FRAMES
			plot_AABB(axis_scale, 'w.');
			set( gca, 'Units', 'normalized', 'Position', [0 0 1 1] );
			fname = sprintf('~/Frames/frame_%05d.png',s);
			saveas(gcf, fname);
		else
			pause(0.01)
		end
    end
    
    
    s = s + 1;
end

elapsed_time = toc;
average_iteration = elapsed_time/s;
fprintf('Simulation time %.3f s\n', elapsed_time)
fprintf('Average iteration %.3f s\n', average_iteration)




%%%%%%%%%%%%%%%%%%%%%%% Final plots %%%%%%%%%%%%%%%%%%%%%%%
% Show final state if it was not shown during the simulation
if ~PLOT_STATE
    figure
    plot_sim( sim )
end

% Create time vector
t = Tstep*linspace(0,smax-1,smax);
% Total objective H
figure('name','Objective')
hold on
if UNCERT
    plot(t, 100 * H / rarea, 'b');
    plot(t, 100 * covered_area / rarea, 'r');
    legend('H', 'Covered area', 'Location','southeast')
else
    plot(t, 100 * H / rarea, 'b');
    legend('H - Covered area', 'Location','southeast')
end
xlabel('Time (s)')
ylabel('H - Covered area (% of total area)')



% Save results
if SAVE_RESULTS
	% Restore the original sensing radius
	sradii = sradii + uradii;
	
    % Generate filemane
    filename = strcat( 'sim_' , CTRL_LAW );
    if FINITE_COMM_RANGE
        filename = strcat( filename , '_fincomm' );
    end
    if KEEP_IN_REGION
        filename = strcat( filename , '_inreg' );
    end
    if STOP_COLLISIONS
        filename = strcat( filename , '_nocol' );
    end
    filename = ...
        strcat( filename , '_' , datestr(clock,'yyyymmdd_HHMM') , '.mat' );


    save(filename,'elapsed_time','smax','Tstep','region','N', ...
        'xstorage','uradii','sradii','cradii','H','covered_area','axis_scale', ...
        'CTRL_LAW', 'FINITE_COMM_RANGE', 'KEEP_IN_REGION', 'STOP_COLLISIONS');
end
