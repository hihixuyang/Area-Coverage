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

% Offset the convex polygon P inwards by r
function Poffset = offset_in( P, r )

d = diameter(P);
% Add the first vertex to the end if needed
if ~isequal(P(:,1), P(:,end))
    P = [P P(:,1)];
end
N = length(P(1,:));


Poffset = P;
for i=1:N-1
    edge = P(:,i:i+1);
    % Check the direction of offset with the midpoint
    midpoint = (edge(:,1)+edge(:,2))/2;
    dir = 1;
    midpoint = point_perp(edge, midpoint, dir*10*eps);
    if ~inpolygon(midpoint(1), midpoint(2), P(1,:), P(2,:))
        dir = -1;
    end
    
    % Create the polygon to remove from P
    edge_offset = zeros(2,4);
    edge_offset(:,1) = point_perp(edge, edge(:,1), dir*r);
    edge_offset(:,2) = point_perp(edge, edge(:,2), dir*r);
    edge_offset(:,3) = point_perp(edge, edge(:,2), -2*dir*r);
    edge_offset(:,4) = point_perp(edge, edge(:,1), -2*dir*r);
    [xr , yr] = poly2cw(edge_offset(1,:), edge_offset(2,:));
    edge_offset = [xr ; yr];
    
    [x, y] = polybool('minus', Poffset(1,:), Poffset(2,:), ...
                            edge_offset(1,:), edge_offset(2,:));
    Poffset = [x; y];
end
