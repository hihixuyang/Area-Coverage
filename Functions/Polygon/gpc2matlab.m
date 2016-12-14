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

function polys = gpc2matlab(filename, read_single_polygon, read_hole_flags)

% if no option is provided, assume hole flags should be read
if nargin == 1
    read_single_polygon = 0;
    read_hole_flags = 0;
elseif nargin == 2
    read_hole_flags = 0;
end

a = importdata(filename);

% the data index points to the first element of the data that hasn't been
% accessed
data_index = 1;

% if read_multiple_polygons is true, the first number in the file is the
% number of polygons
if read_single_polygon == 0
    num_polys = a(1);
    data_index = data_index + 1;
else
    num_polys = 1;
end

polys = cell( [1 num_polys] );

% loop over each polygon
for i=1:num_polys
    
    num_contours_i = a(data_index);
    data_index = data_index + 1;
    
    % loop over each contour of polygon i
    for j=1:num_contours_i
        
        % number of vertices of contour j
        num_vertices_j = a(data_index);
        data_index = data_index + 1;
        
        % is hole of contour j (can be turned off)
        if read_hole_flags == 1
            is_hole_j = a(data_index);
            data_index = data_index + 1;
        else
            % if no hole flag is present, assume it's not a hole
            is_hole_j = 0;
        end
        
        contour_j = zeros(2,num_vertices_j);
        
        % loop over every point coordinate of contour j
        for k=1:2*num_vertices_j
            contour_j(k) = a(data_index);
            data_index = data_index + 1;
        end
        
        % make CW or CCW depending on is_hole_j
        if is_hole_j == 0
            [ contour_j(1,:), contour_j(2,:) ] = poly2cw(...
                contour_j(1,:), contour_j(2,:) );
        else
            [ contour_j(1,:), contour_j(2,:) ] = poly2ccw(...
                contour_j(1,:), contour_j(2,:) );
        end
        
        % add the contour to the contour list (the cell of polygon i)
        polys{i} = [ polys{i} contour_j ];
        
        % if there is another contour to be added, add NaNs to the cell
        if j ~= num_contours_i
            polys{i} = [ polys{i} [NaN ; NaN] ];
        end
        
        
    end
    
end

% if only one polygon was read, return it as an array
% if read_single_polygon == 1
%     polys = polys{1};
% end
        
