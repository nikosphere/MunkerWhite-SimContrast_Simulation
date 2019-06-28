A = 1;
B = 1;
C = 1;
dt = 0.1;
Gex = fspecial('gaussian', [1,40], 10);
Ginh = fspecial('gaussian', [1,100], 25);

x = zeros(10000,100);
locs = zeros(1,10000);

c = randi(100);
for t = 1:9999
    I = zeros(1,100);
    if mod(t,100)==0
        c = randi(100);
    end
    locs(t) = c;
    I(c) = 0.5;
    x(t+1, :) = x(t, :) + dt*( ...
        -A*x(t,:) + (B-x(t,:)).*conv(I, Gex, 'same') - (C + x(t,:)) .* conv(I,Ginh, 'same')...
        );  
end
hits = zeros(1,10000);
for i=1:10000
    hits(i) = x(i,50);
end
%% Calculate Cross Correlations
cross_corr = [];
for i=1:10000
    if corr_test(i, hits)
        cross_corr = [cross_corr locs(i)];
    end
end
%% Calculate Cross Correlations with 50 unit delay
cross_corr = [];
for i=1:10000
    if corr_test(i, hits) && i>45
        cross_corr = [cross_corr locs(:,i-50)];
    end
end
%% Plot
figure('DefaultAxesFontSize',24, 'Position', [10 10 1000 800])
hist(cross_corr)
title({"1D Spike Triggered Cross Correlation", "Delay = 45 ms"})
xlabel("Neuron Position")
ylabel("Spike Count")
xlim([0,100])
%%
function b = corr_test(i, h)
    b = 10000 * h(i) > 1;
end
