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

% If x is outside polygon P, it projects it on its boundary and returns the
% projection. 
function pr = project_pt_poly( x, P )

% If x is in P do nothing
if inpolygon( x(1), x(2), P(1,:), P(2,:) )
    pr = x;
    return
end

% Add the first vertex to the end if needed
if ~isequal(P(:,1), P(:,end))
    P = [P P(:,1)];
end
N = length(P(1,:));

% Find the vertex of poly that is closest to x
minvd = inf;
for i=1:N-1
    if norm(x-P(:,i)) < minvd
        minvd = norm(x-P(:,i));
        minv = P(:,i);
    end
end

% Find the point on an edge of P that is closest to x
mine = [0;0];
mined = inf;
for i=1:N-1
    line = P(:,i:i+1);
    [pr, on] = project_pt_line( x, line );
    if on && norm(x-pr) < mined
       mined = norm(x-pr);
       mine = pr;
    end
end

% Return the closest point
if minvd < mined
    pr = minv;
else
    pr = mine;
end
