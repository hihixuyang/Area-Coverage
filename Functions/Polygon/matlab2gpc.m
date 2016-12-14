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

function matlab2gpc(polys, filename, write_single_polygon, write_hole_flags)

file1 = fopen(filename,'w');

% if no option is provided, assume hole flags should not be written
if nargin == 2
    write_single_polygon = 0;
    write_hole_flags = 0;
elseif nargin == 3
    write_hole_flags = 0;
end

% if read_multiple_polygons is true, the first number in the file is the
% number of polygons
if write_single_polygon == 0
    num_polys = length(polys);
    fprintf(file1,'%d\n',num_polys);
else
    num_polys = 1;
end

% loop over each polygon
for i=1:num_polys
    
    % number of contours, make it use NaNs - NOT COMPLETE
    % Only works for single contour polygons
    num_contours_i = 1; % find the number of contours from the number of NaNs in polys
    fprintf(file1,'%d\n',num_contours_i);
    
    % loop over each contour of polygon i
    for j=1:num_contours_i
        
        % number of vertices of contour j
        num_vertices_j = length( polys{i}(1,:) );
        fprintf(file1,'%d\n',num_vertices_j);
        
        % is hole of contour j (can be turned off)
        if write_hole_flags == 1
            % add correct hole detection - NOT COMPLETE
            is_hole_j = 0;
            fprintf(file1,'%d\n',is_hole_j);
        end
        
        % If the last vertex is the same as the first, remove it
        if isequal(polys{i}(:,1), polys{i}(:,end))
            polys{i} = polys{i}(:,1:end-1);
        end
        
        % loop over every point coordinate of contour j
        for k=1:num_vertices_j
            fprintf(file1,'%f %f\n', polys{i}(1,k), polys{i}(2,k));
        end
        
    end
    
end
        
