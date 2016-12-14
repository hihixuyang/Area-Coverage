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

% Returns the total area the nodes cover, not just the GV cells
function covered_area = total_covered_area(region_vert, x, guarsrad)

N = length(x(1,:));

sensor_circles = cell( [N 1] );
circle_union = zeros(2,2);

for i=1:N
    sensor_circles{i} = create_circle(x(:,i), guarsrad(i));
    
    [polyboolx, polybooly] = polybool('or',...
        circle_union(1,:), circle_union(2,:),...
        sensor_circles{i}(1,:), sensor_circles{i}(2,:) );
    
    circle_union = [polyboolx ; polybooly];
end

% intersect circle union with region Omega
[polyboolx, polybooly] = polybool('and',...
    circle_union(1,:), circle_union(2,:),...
    region_vert(1,:), region_vert(2,:) );

region_intersection = [polyboolx ; polybooly];


covered_area = polyarea_nan(region_intersection(1,:), region_intersection(2,:));

