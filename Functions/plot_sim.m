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

% Plots the state of the network in the input struct
function plot_sim( sim )

N = length(sim.x(1,:));

hold on

% Plot cells
if sim.plot_cells
    for i=1:N
        plot_poly( sim.cells{i}, 'b');
    end
end

% Plot r limited cells
if sim.plot_rcells
    for i=1:N
        plot_poly( sim.rcells{i}, 'g');
    end
end

% Plot the region
plot_poly( sim.region, 'k');

% Plot nodes and uncertainty
plot(sim.x(1,:), sim.x(2,:), 'k.');
for i=1:N
    plot_circle( sim.x(1:2,i) , sim.uradii(i) , 'k');
end

% Plot sensing
for i=1:N
    plot_circle( sim.x(1:2,i) , sim.sradii(i) , 'r');
end

% Plot communication graph and radii
if sim.plot_comm
    for i=1:N
        plot_circle( sim.x(:,i) , sim.cradii(i) , 'r--');
    end
    % Plot communicating pairs
    for i=1:N
        for j=1:length(sim.in_range{i})
            if j ~= i
                % Only plot neighbors with higher index to avoid repetitions
                plot([sim.x(1,i) sim.x(1,sim.in_range{i}(j))], ...
                    [sim.x(2,i) sim.x(2,sim.in_range{i}(j))], 'g');
            end
        end
    end
end

% Plot velocity vectors
if sim.plot_vel
	for i=1:N
		plot_poly([sim.x(:,i) sim.x(:,i) + sim.velocity(:,i)], 'm');
	end
end

axis(sim.axis)
axis equal
axis off
