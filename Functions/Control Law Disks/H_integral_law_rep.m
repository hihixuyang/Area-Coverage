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

function move_vector = H_integral_law_rep( Xi, uradiusi, GVcelli, sradiusi, ...
    Xj, uradiusj, GVcellj, sradiusj )
% Calculate the integral over Hij, Hji and return the move vector


% Translate and rotate Xi and Xj so that the hyperbola is East-West
XXi = Xi - (Xi+Xj)/2;
XXj = Xj - (Xi+Xj)/2;
theta = -atan2( Xj(2)-Xi(2), Xj(1)-Xi(1) );
XXi = rot(XXi, theta);
XXj = rot(XXj, theta);



% Hyperbola parameters
a = (uradiusi + uradiusj) / 2;
c = norm( Xi-Xj ) / 2;
b = sqrt(c^2 - a^2);
% Error tolerance
e = 10^-10;

move_vector = zeros(2,1);




% Integral over Hij
% Loop over all vertices of GVi (the rotated and translated cell, as if
% produced by an East-West hyperbola). For each vertex check if it
% satisfies the East-West hyperbola equation. If it does find t and
% integrate
if ~isempty(GVcelli)
    % Translate and rotate the cell
    GVi = bsxfun(@minus, GVcelli, (Xi+Xj)/2);
    for k=1:length( GVi(1,:) )
        GVi(:,k) = rot( GVi(:,k), theta );
    end
    
    for k=1:length( GVi(1,:) )
        % Check if it satisfies the hyperbola equation
        if abs(GVi(1,k)^2/a^2 - GVi(2,k)^2/b^2 - 1) <= e
            % Check if it's inside the sensing circle
            if norm( GVi(:,k)-XXi ) <= sradiusi           
                % Find the t parameter
                t = asinh( GVi(2,k)/b );

                % Substitute the symbolic expressions
                xi = XXi(1);
                yi = XXi(2);
                xj = XXj(1);
                yj = XXj(2);

                uni = FJni_rep(a,t,xi,xj,yi,yj);

                % Rotate back to the correct orientation
                uni = rot( uni, -theta );

                % Find the length of the arc (half the distance from each adjacent vertex)
                % Cases for first and last vertices
                if k == 1
                    d = norm(GVi(:,k)-GVi(:,end)) / 2 + ...
                        norm(GVi(:,k)-GVi(:,k+1)) / 2;
                elseif k == length( GVi(1,:) )
                    d = norm(GVi(:,k)-GVi(:,k-1)) / 2 + ...
                        norm(GVi(:,k)-GVi(:,1)) / 2;
                else
                    d = norm(GVi(:,k)-GVi(:,k-1)) / 2 + ...
                        norm(GVi(:,k)-GVi(:,k+1)) / 2;
                end
                % Add to the move vector
                move_vector = move_vector + d*uni;
                %%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
%                 plot(GVcelli(1,k), GVcelli(2,k), 'g.');
%                 hold on
%                 plot([GVcelli(1,k) GVcelli(1,k)+d*uni(1)], ...
%                      [GVcelli(2,k) GVcelli(2,k)+d*uni(2)], 'g');
%                 hold on
                %%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
            end
        end
    end
end




% Integral over Hji
% Loop over all vertices of GVj (the rotated and translated cell, as if
% produced by an East-West hyperbola). For each vertex check if it
% satisfies the East-West hyperbola equation. If it does find t and
% integrate
if ~isempty(GVcellj)
    % Translate and rotate the cell
    GVj = bsxfun(@minus, GVcellj, (Xi+Xj)/2);
    for k=1:length( GVj(1,:) )
        GVj(:,k) = rot( GVj(:,k), theta );
    end
    
    for k=1:length( GVj(1,:) )
        % Check if it satisfies the hyperbola equation
        if abs(GVj(1,k)^2/a^2 - GVj(2,k)^2/b^2 - 1) <= e
            % Check if it's inside the sensing circle
            if norm( GVj(:,k)-XXj ) <= sradiusj
                % Find the t parameter
                t = asinh( GVj(2,k)/b );
                if imag(t) ~= 0
                    disp('imaginary t j')
                end

                % Substitute the symbolic expressions
                xi = XXi(1);
                yi = XXi(2);
                xj = XXj(1);
                yj = XXj(2);

                unj = FJnj_rep(a,t,xi,xj,yi,yj);

                % Rotate back to the correct orientation
                unj = rot( unj, -theta );

                % Find the length of the arc (half the distance from each adjacent vertex)
                % Cases for first and last vertices
                if k == 1
                    d = norm(GVj(:,k)-GVj(:,end)) / 2 + ...
                        norm(GVj(:,k)-GVj(:,k+1)) / 2;
                elseif k == length( GVj(1,:) )
                    d = norm(GVj(:,k)-GVj(:,k-1)) / 2 + ...
                        norm(GVj(:,k)-GVj(:,1)) / 2;
                else
                    d = norm(GVj(:,k)-GVj(:,k-1)) / 2 + ...
                        norm(GVj(:,k)-GVj(:,k+1)) / 2;
                end
                % Add to the move vector
                move_vector = move_vector + d*unj;
                %%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
%                 plot(GVcellj(1,k), GVcellj(2,k), 'm.');
%                 hold on
%                 plot([GVcellj(1,k) GVcellj(1,k)+d*unj(1)], ...
%                      [GVcellj(2,k) GVcellj(2,k)+d*unj(2)], 'm');
%                 hold on
                %%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%
            end
        end
    end
end
