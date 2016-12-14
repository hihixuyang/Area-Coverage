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

% offsets polygon P inward so that the distance between the edges is r
% P = [Px ; Py]
function G = offset(P, r, dir)

if nargin < 3
    dir = 'in';
end

% if strcmp(dir, 'out')
% 	dir = 'in';
% else
% 	dir = 'out';
% end

% Check if the last vertex is the same as the first
% If not add it
if ~isequal( P(:,1), P(:,end) )
    P = [P P(:,1)];
end

[Gx , Gy] = bufferm(P(1,:), P(2,:), r, dir);

% the points until the nan are the new polygon ?
nan_index = find( isnan(Gx) );

G = [Gx(1:nan_index-1)' ; Gy(1:nan_index-1)'];

