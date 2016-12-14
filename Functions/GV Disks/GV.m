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

% Constructs the Guaranteed Voronoi diagram of the input disks
function [GVcells, rcells, covered_area, overlap] = ...
GV(region_vert, max_line, x, uncert, guarsrad)
%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%%%%%
% It doesnt work on three or more colinear nodes
%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%%%%%

% Number of nodes
N = length( x(1,:) );

% Voronoi Cells -----------------------------------------------------------
p = 201; % points per edge
% increase max_line
max_line = 1.01 * max_line;

[GVcells, overlap] = guar_voronoi_cells(region_vert , x , uncert, p, max_line);


% Radius constrained cells ------------------------------------------------
covered_area = 0;
rcells = cell( [N 1] ); % Initialization
% parfor - slower
for i=1:N
    if ~isempty( GVcells{i} )
        rcells{i} = rad_cell( x(:,i) , GVcells{i} , guarsrad(i) );
        
        % Add covered area
        if ~isempty( rcells{i} )
            covered_area = covered_area + polyarea( rcells{i}(1,:), rcells{i}(2,:) );
        end
        
    end
end




