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

% plot NaN delimited polygons
function h = plot_poly( P , colorspec )
if isempty(P)
    return
end

a = ishold;

if nargin == 1
    colorspec = 'b';
end
% if the last vertex is not the same as the last, add the first vertex to
% the end
% if ~isequal( P(:,1), P(:,end) )
%     P = [P P(:,1)];
% end

x = P(1,:);
y = P(2,:);

nan_indices = find( isnan(P(1,:)) ); % The indices are the same for x and y
indices = [ 0 nan_indices length(x)+1 ];

h = [];

for i=1:length( nan_indices )+1

    ht = plot(   [x( indices(i) + 1 : indices(i+1) - 1 ) x(indices(i) + 1)] , ...
            [y( indices(i) + 1 : indices(i+1) - 1 ) y(indices(i) + 1)] , ...
            colorspec );

    h = [h ht];
    hold on;

end

% Keep the previous hold state
if a
    hold on
else
    hold off
end
