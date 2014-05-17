function x = dexpand(y)
r = 5;
%y = (log10(x+10^(-r))+r)/(log10(1+10^(-r))+r);
x = 10.^(y*(log10(1+10^(-r))+r) -r)-10^(-r);
