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

% returns a random convex polygon with M vertices in xmin xmax ymin ymax
function [poly, mbc_center, mbc_radius] = rand_convex_poly(region, M, scale)

% Maximum and minimum values of region multiplied with scaling factor
% used to generate a polygon inside the region
xminsc = scale*min( region(1,:) );
xmaxsc = scale*max( region(1,:) );
yminsc = scale*min( region(2,:) );
ymaxsc = scale*max( region(2,:) );

% generate three random points
poly = [ xminsc+xmaxsc*rand([1 3]) ;
        yminsc+ymaxsc*rand([1 3]) ];

% add points until the polygon has M vertices
while length( poly(1,:) ) < M
    % add a random point
    new_pt = [ xminsc+xmaxsc*rand ; yminsc+ymaxsc*rand ];
    poly_temp = [poly  new_pt];
    
    % find the convex hull
    k = convhull(poly_temp(1,:), poly_temp(2,:));
    k = k(1:end-1);
    
    if length(k) == length(poly_temp(1,:))
        poly = [poly_temp(1,k) ; poly_temp(2,k)];
    end
    
end

% make the vertices clockwise
[poly(1,:), poly(2,:)] = poly2cw(poly(1,:), poly(2,:));


% find the minimum bound circle
[mbc_center, mbc_radius] = minboundcircle(poly);
% center is returned as row vector
mbc_center = mbc_center';

% offset the region by mbc_radius
region_offset = offset(region, mbc_radius, 'in');

% randomly select a new point in region_offest and move mbc_center (and poly) to it
while true

    % Maximum and minimum values of region
    % used to generate points in the region
    xmin = min( region_offset(1,:) );
    xmax = max( region_offset(1,:) );
    ymin = min( region_offset(2,:) );
    ymax = max( region_offset(2,:) );

    xnew = max([ xmax-xmin ymax-ymin ]) * rand(2,1) + min([ xmin ymin ]);
    if inpolygon( xnew(1), xnew(2), region_offset(1,:), region_offset(2,:) )
        break;
    end
end

% move the polygon
poly = bsxfun(@plus, poly, xnew-mbc_center);

% move mbc_center
mbc_center = xnew;

