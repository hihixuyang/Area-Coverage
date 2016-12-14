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

% Returns the voronoi cells of nodes x with uncertainty uncert in region
function [cells, overlap] = guar_voronoi_cells(region , x , uncert, p, max_line)
% use p points per edge
% the length of the largest line segment in region is max_line

% number of points
N = length( x(1,:) );

% Delaunay triangulation
dtr = delaunayTriangulation(x');

% Overlap matrix, overlap(i,j) is 1 if dsks i,j overlap
overlap = zeros(N,N);

% Find Voronoi edges (polygons) -------------------------------------------

% edges contains the voronoi edges for each point
edges = cell(N,N);

% Loop over upper triangular part of edges matrix
for i=1:N-1
    j = i+1;
    while j <= N
        
        if isConnected(dtr,i,j) || ( N == 2 ) % Check if it's a Delaunay neighbor
            
            [E, a, c] = GV_edge( x(:,i) , x(:,j) , uncert(i), uncert(j), p, max_line);
            


            % if the disks are overlapping save the value the move vector
            % has to be multiplied with
            if isempty(E)
                overlap(i,j) = a/(c*c);
                overlap(j,i) = a/(c*c);
            else
                
                % FASTER
                % Made clockwise
%                 [E(1,:), E(2,:)] = poly2cw(E(1,:), E(2,:));
%                 [E(3,:), E(4,:)] = poly2cw(E(3,:), E(4,:));
            
                % Edge of point A with B (on upper triangular)
                edges{i,j} = E( 1:2 , : );

                % Edge of point B with A (on lower triangular)
                edges{j,i} = E( 3:4 , : );
                
            end

        end
        
        j = j+1;
    end
end

%--------------------------------------------------------------------------



% Find Voronoi cells (from polygon intersection)---------------------------

% Cell array containing the voronoi cell of each node
cells = cell( [N 1] ); % Initialization

% parfor - slower
for i=1:N
    
    if sum(overlap(i,:)) == 0 % Disk i does not overlap
        
        ipoly = region; % Initialized to region omega

        % Loop over every element of line i except i,i
        jvalues = linspace(1,N,N);
        jvalues(i) = [];

        for j = jvalues

                if ~isempty(edges{i,j}) && ~isempty(ipoly) % Some nodes may not have a cell

                    % FASTER
%                     [ipolyx , ipolyy] =...
%                     polybool('and', ipoly(1,:), ipoly(2,:),...
%                     edges{i,j}(1,:), edges{i,j}(2,:) );
                    [ipolyx , ipolyy] =...
                polybooland(ipoly(1,:), ipoly(2,:),...
                edges{i,j}(1,:), edges{i,j}(2,:) );

                    ipoly = [ ipolyx; ipolyy];

                end

        end

        cells{i} = ipoly;
        
        
        
        
        
    else % Disk i overlaps
        
        cells{i} = [];
        
    end
    
end
