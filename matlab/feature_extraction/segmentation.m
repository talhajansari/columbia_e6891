function seg = segmentation(as, e, th, energy_th, window, wth)
base_prob = sum(as,1);

% th = .1;
base_est = base_prob < th;
base = major(base_est, window, wth);

seg = [];
t = 1;
left = 0;
right = 0;
base = [base, 1];
for b = 1:length(base)
    if base(b) ~= t
        t = base(b);
        if ~t
            left = b;
        else
            right = b-1;
            energy = sum(e(left:right));
            big = max(max(as(:,left:right)));
            if (energy > energy_th || big > .5) && right-left>=5  % tuneable params here
                seg = [seg; left, right];
            end
        end
    end
end


plot(base_prob, 'r');
if length(seg) > 0
    for i = 1:length(seg(:,1))
        line([seg(i,1),seg(i,1)], [0,1])
        line([seg(i,2),seg(i,2)], [0,1])
    end
end