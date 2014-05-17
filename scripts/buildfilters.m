function [HL1, HL2, HL3, HH1, HH2, HH3] = buildfilters( Fs )
%PASS2FILTER Builds and saves as .mat files one low-pass and one high-pass
%filter with pre-defined specifications.

% Low-Pass Filters
% Fc = 3597 Hz
d = fdesign.lowpass('Fp,Fst,Ap,Ast',3497,3697,0.5,50,Fs);
HL1 = design(d,'equiripple');

% Fc = 4200 Hz
d = fdesign.lowpass('Fp,Fst,Ap,Ast',4100,4300,0.5,50,Fs);
HL2 = design(d,'equiripple');

% Fc = 3597 Hz
d = fdesign.lowpass('Fp,Fst,Ap,Ast',3497,3697,0.5,50,Fs);
HL3 = design(d,'equiripple');

% High-Pass Filters
% Fc = 517 Hz
d = fdesign.highpass('Fst,Fp,Ast,Ap',417,617,100,0.5,Fs);
HH1 = design(d,'equiripple');

% Fc = 920 Hz
d = fdesign.highpass('Fst,Fp,Ast,Ap',820,1020,100,0.5,Fs);
HH2 = design(d,'equiripple');

% Fc = 686 Hz
d = fdesign.highpass('Fst,Fp,Ast,Ap',586,786,100,0.5,Fs);
HH3 = design(d,'equiripple');
   
save('filters.mat','HL1', 'HL2', 'HL3', 'HH1', 'HH2', 'HH3');
end

