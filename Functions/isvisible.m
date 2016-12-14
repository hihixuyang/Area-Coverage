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

function b = isvisible(side, pt, pol)
% checks if side of polygon pol is visible from point pt
% side contains the two indices of the sides vertices

% create the triangle defined by side and pt
tri = [ pt pol(:,side(1)) pol(:,side(2)) ];
% faster without poly2cw
% [tri(1,:), tri(2,:)] = poly2cw(tri(1,:), tri(2,:));

% DEBUG
d=fill(tri(1,:), tri(2,:), 'g');
delete(d);

% find the intersection of the triangle and the polygon
% if it is not empty, the side is invisible
% xb = polybool('and', tri(1,:), tri(2,:), pol(1,:), pol(2,:));
xb = polybooland(tri(1,:), tri(2,:), pol(1,:), pol(2,:));

if isempty(xb)
	% the vertices of side might be colinear with pt
	% if this happens, side is invisible
	if (pt(2)-pol(2,side(1)))/(pt(1)-pol(1,side(1))) == (pt(2)-pol(2,side(2)))/(pt(1)-pol(1,side(2)))
		b = 0;
	else
    	b = 1;
	end
else
    b = 0;
end
