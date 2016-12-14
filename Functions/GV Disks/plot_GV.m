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

% Plots the GV with guaranteed cells
function plot_GV(region_vert, x, GVcells, uncert, guarsrad, rcells )
%%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
hold on
%%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%

N = length( x(1,:) );

% Plot guaranteed cells
for i=1:N
    if ~isempty(GVcells{i})
        plot_poly( GVcells{i}, 'b');
%         fill( GVcells{i}(1,:), GVcells{i}(2,:) , 'b', 'EdgeColor','None');
        %fill_nan( GVcells{i}(1,:), GVcells{i}(2,:) , 'b');
        hold on;
    end
end


if nargin > 5
    % Plot covered cells
    for i=1:N
        if ~isempty(rcells{i})
%             fill( rcells{i}(1,:), rcells{i}(2,:) , 'g', 'EdgeColor','None');
            %fill_nan( rcells{i}(1,:), rcells{i}(2,:) , 'g');
        end
    end
end

% Plot region - Black outline
plot_poly( region_vert, 'k');

% plot nodes
scatter( x(1,:) , x(2,:) , '.k');
hold on;

% plot node uncertainty
for i=1:N
    plot_circle( x(1:2,i) , uncert(i) , 'k');
end

if nargin > 4
    % Plot guaranteed node radius
    for i=1:N
        plot_circle( x(1:2,i) , guarsrad(i), 'r' );
    end

%     % plot centroids
%     for i=1:N
%         if ~isempty( GVcells{i} )
%             centroids = centroid( GVcells{i} );
%             scatter( centroids(1,:), centroids(2,:), 'm');
%         end
%     end
end



axis square;
% axis([ -0.5 3.5 -0.5 3.5 ]);
% hold off;

