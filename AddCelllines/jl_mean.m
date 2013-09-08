function [out, gstd] = jl_mean(X, group)

out = zeros(length(unique(group)), size(X,2));
gstd = zeros(length(unique(group)), size(X,2));

for i = unique(group(:)')
    idx = group==i;
    out(i,:) = mean(X(idx,:),1);
    gstd(i,:) = std(X(idx,:), 0, 1);
end

