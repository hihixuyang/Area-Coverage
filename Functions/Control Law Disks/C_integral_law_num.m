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

% Checked for analytic expression for ds, no change
function move_vector = C_integral_law_num( xi, GVcelli, sradiusi, DEBUG )
% Calculate the integral over Ci numerically and return the move vector
% Handle optional debug argument
if nargin == 3
    DEBUG = 0;
end

% If the cell is empty, dont move
if isempty(GVcelli)
    move_vector = zeros(2,1);
    return;
end

% Points per circle - affects accuracy
ppc = 360;

% Create the sensing circle
C = create_circle(xi, sradiusi, ppc);
% Add the first vertex to the end
C = [C C(:,1)];
% The distance between consecutive points on the circle is constant
ds = norm( C(:,1) - C(:,2) );

move_vector = zeros(2,1);
% Loop over all sensing circle edges
for i=1:length(C(1,:))-1
    % Current edge endpoints
    p1 = C(:,i);
    p2 = C(:,i+1);
    % Check if the edge is inside the GV cell
    if inpolygon(p1(1), p1(2), GVcelli(1,:), GVcelli(2,:)) && ...
       inpolygon(p2(1), p2(2), GVcelli(1,:), GVcelli(2,:))
        
        % Find the normal vector
        n = (p1+p2)/2 - xi;
        n = n / norm(n);
        
        % Add the normal vector to the sum multiplied by ds
        move_vector = move_vector + ds.*n;
        
        %%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
        if DEBUG
            plot(p1(1), p1(2), 'r.');
            plot(p2(1), p2(2), 'r.');
%             tmp = (p1+p2)/2;
%             plot([tmp(1) tmp(1)+n(1)], [tmp(2) tmp(2)+n(2)], 'r');
        end
        %%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
    end
end
