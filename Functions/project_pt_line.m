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

% Returns the projection of x on line. May also check if the projection
% lies on the line segment defined by the two points in line
function [pr, on] = project_pt_line( x, line )

% Line parameters ax + by + c = 0
a = line(2,2) - line(2,1);
b = line(1,1) - line(1,2);
c = -a * line(1,1) - b * line(2,1);

pr = [ ( b*(b*x(1)-a*x(2))-a*c ) / (a*a+b*b) ;
    ( a*(-b*x(1)+a*x(2))-b*c ) / (a*a+b*b) ];

% Also check if the projection is on the line segment
if nargout == 2
    xmin = min( line(1,:) );
    xmax = max( line(1,:) );
    ymin = min( line(2,:) );
    ymax = max( line(2,:) );
    
    if (pr(1) >= xmin) && (pr(1) <= xmax) && ...
       (pr(2) >= ymin) && (pr(2) <= ymax)
        on = 1;
    else
        on = 0;
    end
end
