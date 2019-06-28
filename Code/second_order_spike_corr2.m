A = 1;
B = 1;
C = 1;
dt = 0.1;
Gex = fspecial('gaussian', [40,40], 10);
Ginh = fspecial('gaussian', [100,100], 25);

x = zeros(10000,100,100);
dists = zeros(1,10000);

x1 = randi(100);
y1 = randi(100);
x2 = randi(100);
y2 = randi(100);
for t = 1:9999
    I = zeros(100,100);
    if mod(t,100)==0
        x1 = randi(100);
        y1 = randi(100);
        x2 = randi(100);
        y2 = randi(100);
    end
    dists(t) = pdist([x1 y1; x2 y2]);
    I(x1, y1) = 0.5;
    I(x2, y2) = 0.5;
    x(t+1, :, :) = x(t, :, :) + dt*( ...
        -A*x(t,:, :) + (B-x(t,:, :)).*reshape(conv2(I, Gex, 'same'),[1 100 100]) - (C + x(t,:, :)) .* reshape(conv2(I,Ginh, 'same'),[1 100 100])...
        );
end
hits = zeros(1,10000);
for i=1:10000
    hits(i) = x(i,50,50);
end
%% Calculate Cross Correlations
cross_corr = [];
for i=1:10000
    if corr_test(i, hits)
        cross_corr = [cross_corr dists(i)];
    end
end
%% Calculate Cross Correlations with 50 unit delay
cross_corr = [];
for i=1:10000
    if corr_test(i, hits) && i>50
        cross_corr = [cross_corr dists(i)];
    end
end
%% Plot
figure('DefaultAxesFontSize',24, 'Position', [10 10 1000 800])
hist(cross_corr, 40)
title({"Second Order 2D Spike Triggered Cross Correlation", "Delay = 50 ms"})
xlabel("Distance Between Inputs Pairs")
ylabel("Number of Hits")
xlim([0,141])
%%
function b = corr_test(i, h)
    b = 10000 * h(i) > 1;
end