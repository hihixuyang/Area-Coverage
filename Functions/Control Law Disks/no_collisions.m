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

function x_new = no_collisions(region, x, i, uncertx, DEBUG)
% Keep node i inside its no collision cell by projecting the move vector on
% the boundary
if nargin < 5
    DEBUG = 0;
end
region_diameter = diameter(region);
N = length(x);

% Find the Voronoi cell of node i
Vcelli = region;
for j=1:N
    if j ~= i
        midpt = (x(:,i) + x(:,j)) / 2;
        theta = atan2( x(2,j)-x(2,i), x(1,j)-x(1,i) );
        % Create halfplane
        hp = [ 0 -region_diameter -region_diameter 0 ; 
            region_diameter region_diameter -region_diameter -region_diameter];
        % Rotate halfplane
        hp = rot(hp, theta);
        hp = bsxfun(@plus,hp,midpt);

        %%%%%%%%% DEBUG %%%%%%%%%
%         if DEBUG
%             plot_poly( hp, 'b');
%         end
        %%%%%%%%% DEBUG %%%%%%%%%

        % Intersect with the current voronoi cell
        [ipolyx , ipolyy] =...
                    polybooland(Vcelli(1,:), Vcelli(2,:),...
                                hp(1,:), hp(2,:) );
        Vcelli = [ipolyx ; ipolyy];
        if isempty(Vcelli)
            x_new = x(:,i);
            return;
        end
    end
end

%%%%%%%%% DEBUG %%%%%%%%%
    if DEBUG
        plot_poly( Vcelli, 'g');
    end
%%%%%%%%% DEBUG %%%%%%%%%

% Use keep in region to keep the disk inside its voronoi cell
% x_new = keep_in_region_old(Vcelli, x(:,i), uncertx, move_vector);
x_new = keep_in_region(Vcelli, x(:,i), uncertx);
