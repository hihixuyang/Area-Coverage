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

% Returns the Guaranteed Voronoi edges between two disks
function [E, a, c] = GV_edge(A , B , uncertA, uncertB , p , max_line)
% Voronoi edges are hyperbolas (polygons)
% Returns the Voronoi edges between points A and B
% p defines how many points the polygon will have (MAKE SURE ITS ODD)
% l is the largest x on the polygon

% Calculate parameters
c = eucl_dist(A,B) / 2;
a = (uncertA + uncertB) / 2;
b = sqrt(c^2 - a^2);


% if c <= a there are no cells
if c <= a
    E = [];
    return
end

% if a = 0 then the edge is the classic Voronoi edge, the perpendicular bisector of A and B
if a == 0
	x = [0 0 max_line max_line];
	y = [max_line -max_line -max_line max_line];
else
    % if a > 0 then the edge is a hyperbola branch
    % Use the parametric equation of the hyperbola
    t = linspace( -acosh(max_line/a), acosh(max_line/a), p);
%     t = logspace( -10, ceil(log(acosh(max_line/a))), (p-1)/2 );
%     t = [-fliplr(t) 0 t];
    x = a .* cosh(t);
    y = b .* sinh(t);
end

% Edge of point in right hand plane
EB = [ x;
        y];
% Edge of point in left hand plane
EA = [ -x;
        y];

% EA: edge of point A wrt B
% EB: edge of point B wrt A
E = [EA; EB];


% Rotation
theta = atan2( B(2) - A(2) , B(1) - A(1) );
for i = 1:length( E(1,:) ) % p points per edge
	E(1:2,i) = rot( E(1:2,i) , theta);
	E(3:4,i) = rot( E(3:4,i) , theta);
end


% Translation vector
f = (A+B) / 2;

% Translation
E = [   (E(1,:) + f(1)) ;
        (E(2,:) + f(2)) ;
        (E(3,:) + f(1)) ;
        (E(4,:) + f(2)) ];
