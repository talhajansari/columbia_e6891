function base_maj = major(est, window, th)
% old segmentation, not used for now
N = floor(window/2);
wrap = [1:N, N+1, N:-1:1];
est = double(est);
yy = [ones(1,N), est, ones(1,N)];
for i = 1:length(est)
    j = N+((i-N):(i+N));
    est(i) = (yy(j)*2-1)*wrap';
end
base_maj = est >= th;
