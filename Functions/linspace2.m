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

% returns a vector with two differently linearly spaced portions
% fracl [0,1] defines how large the first portion will be compared to
% the total vector length
% fracp [0,1] defines what part of the total points the first portion will
% contain
function x = linspace2(a, b, N, fracl, fracp)

% point defining the two portions [a,c] [c,b]
c = a + fracl*(b-a);

% points in the first portion
N1 = ceil( fracp*N );
N2 = N-N1;

x1 = linspace(a, c, N1);
x2 = linspace(c, b, N2+1);
% N2+1 because point c on x2 will be removed afterwards

x = [x1 x2(2:end)];

