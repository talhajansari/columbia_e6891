function y = expand(x, r)
if nargin < 2
    r = 5;
end
y = (log10(x+10^(-r))+r)/(log10(1+10^(-r))+r);

% y = (x-0.2)/(1-0.2);
% y = sin((y)*pi/2);
% y(y>0) = y(y>0).^.2;
% y(y<0) = -(-y(y<0)).^.2;
% mm = min(y(:));
% y = (y-mm)/(1-mm);
