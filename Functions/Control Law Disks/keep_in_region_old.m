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

% makes sure the move_vector results in movement inside region omega
function x_new = keep_in_region_old(region_vert, x, uncertx, move_vector)

% offset the region inwards so that the disk of node x will be inside
region_offset = offset(region_vert, uncertx, 'in');
if isempty(region_offset)
    x_new = x;
    return;
end
%%%%%%%%% DEBUG %%%%%%%%%
% plot_poly( region_offset, 'm');
%%%%%%%%% DEBUG %%%%%%%%%

% use uncertx to guarantee the disk will not move out of omega
% Maybe use polyxpoly instead of inpolygon (might be slower)
x_new = x + move_vector;

if inpolygon(x_new(1), x_new(2), region_offset(1,:), region_offset(2,:) )
    % movement inside omega
    return;
    
else
    % movement outside omega
    
    % move the node to the intersection point
    % ONLY ONE INTERSECTION POINT, ok for CONVEX region
    [xi, yi, ii] = polyxpoly([x_new(1) x(1)], [x_new(2) x(2)],...
        region_offset(1,:), region_offset(2,:) );
    
    % if x is on the boundary of omega, polyxpoly sometimes returns no
    % intersection
    if isempty(xi)
        x_new = x;
        % should find which edge x is on but polyxpoly doesnt work
        return;
        
    else
        x_new = [xi(1) ; yi(1)];
        
        % subtract the above move from the move vector
        move_vector = move_vector - (x_new - x);

        % find the edge where the intersection happened
        % ONLY ONE INTERSECTION POINT
        if isequal( x_new, region_offset(:,ii(2)) )
            % the intersection happens at a vertex of omega, no other move
            % is possible
            return;
        else
            edge = region_offset(:, ii(2)+1) - region_offset(:, ii(2));
            move_vector = projv(move_vector, edge);

            % check if the new move vector is still inside the polygon
            x_temp = x_new + move_vector;
            % this check isnt always correct
            if inpolygon(x_temp(1), x_temp(2), region_offset(1,:), region_offset(2,:) )
                x_new = x_temp;
                return;
            else
                % find the vertex of omega the node must move to
                [xi, yi] = polyxpoly([x_temp(1) x_new(1)], [x_temp(2) x_new(2)],...
                    region_offset(1,:), region_offset(2,:) );
                % one of the two vertices returned will be x_new and the
                % other one the desired
                if isempty(xi)
                    % x_temp is on the boundary of region_offset and
                    % inpolygon isnt accurate enough
                    x_new = x_temp;
                    return;
                elseif isequal( [xi(1) ; yi(1)] , x_new) || length(xi) == 1
                    x_new = [xi(1) ; yi(1)];
                else
                    x_new = [xi(2) ; yi(2)];
                end
            end
        end
        
        
    end
    
    
end

