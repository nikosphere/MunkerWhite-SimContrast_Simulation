A = 1;
B = 1;
C = 1;
dt = 0.1;
Gex = fspecial('gaussian', [1,40], 10);
Ginh = fspecial('gaussian', [1,100], 25);

x = zeros(100000,100);
dists = zeros(1,100000);

x1 = randi(100);
x2 = randi(100);
for t = 1:99999
    I = zeros(1,100);
    if mod(t,100)==0
        x1 = randi(100);
        x2 = randi(100);
    end
    dists(t) = abs(x2 - x1);
    I(x1) = 0.5;
    I(x2) = 0.5;
    x(t+1, :) = x(t, :) + dt*( ...
        -A*x(t,:) + (B-x(t,:)).*conv(I, Gex, 'same') - (C + x(t,:)) .* conv(I,Ginh, 'same')...
        );  
end

hits = zeros(1,100000);
for i=1:100000
    hits(i) = x(i,50);
end
%% Calculate Cross Correlations
cross_corr = [];
for i=1:100000
    if corr_test(i, hits)
        cross_corr = [cross_corr dists(i)];
    end
end
%% Calculate Cross Correlations with 50 unit delay
cross_corr = [];
for i=1:100000
    if corr_test(i, hits) && i>40
        cross_corr = [cross_corr dists(i)];
    end
end
%% Plot
figure('DefaultAxesFontSize',24, 'Position', [10 10 1000 800])
hist(cross_corr, 100)
title({"Second Order 1D Spike Triggered Cross Correlation", "Delay = 40 ms"})
xlabel("Distance Between Inputs Pairs")
ylabel("Number of Hits")
xlim([0,100])
%%
function b = corr_test(i, h)
    b = 10000 * h(i) > 1;
end