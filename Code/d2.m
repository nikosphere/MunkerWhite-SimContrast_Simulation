%% Load Model Parameters
A = 1;
B = 1;
C = 1;
dt = 0.01;
Gex = fspecial('gaussian', [12 12], 3);
Ginh = fspecial('gaussian', [20 20], 5);
tG = [repelem(0.0000, 48) fspecial('gaussian', [1, 48], 12)];
x = zeros(1000,100,100);
%% Line
I = [zeros(10,100); reshape(repelem([zeros(1,49) 0.5 zeros(1,50)], 50), [50,100]); zeros(40,100)];
%% Wide Line
I = [zeros(10,100); reshape(repelem([zeros(1,45) repelem(0.5, 10) zeros(1,45)], 50), [50,100]); zeros(40,100)];
%% Very Wide Line
I = [zeros(10,100); reshape(repelem([zeros(1,40) repelem(0.5, 20) zeros(1,40)], 50), [50,100]); zeros(40,100)];
%% Munker-White
dark = [zeros(10,60) repelem(0.5, 10, 20) zeros(10,20)];
light = [ones(10,20) repelem(0.5, 10, 20) ones(10,60)];
I = [dark; light; dark; light; dark; light; dark; light; dark; light];
%% Simultaneous Contrast
I = [zeros(100,50) ones(100,50)];
square = repelem(0.5, 50, 30);
I(25:74, 10:39) = square;
I(25:74, 60:89) = square;
%% Apply Model With Noise
x(1,:,:) = randn([1 100 100])/100;
for t = 1:99
    x(t+1, :, :) = x(t, :, :) + dt*(-A*x(t,:, :) + (B-x(t,:, :)).*reshape(conv2(I, Gex, 'same'),[1 100 100]) - (C + x(t,:, :)) .* reshape(conv2(I,Ginh, 'same'),[1 100 100])+ randn([1 100 100])/100);
end
%% Apply Model Without Noise
for t = 1:99
    x(t+1,:, :) = x(t, :, :) + dt*(-A*x(t,:, :) + (B-x(t,: , :)).*reshape(conv2(I, Gex, 'same'),[1 100 100]) - (C + x(t,:, :)) .* reshape(conv2(I,Ginh, 'same'),[1 100 100]));
end
%% Apply Temporal Gaussian Filter to Model
for t=1:10000
    neural_response = x(:, t);
    new_response = conv(neural_response, tG, 'same');
    x(:, t) = new_response;
end
%% Render Video
F(100) = struct('cdata',[],'colormap',[]);
figure('DefaultAxesFontSize',18, 'Position', [10 10 1000 800])
for i=1:100
    heatmap(reshape(x(i,:,:), [100, 100]));
    caxis(gca,[-0.1 0.1]);
    colormap jet
    colorbar
    title({"Thin Line"})
    xlabel("neurons")
    ylabel("neurons")
    F(i) = getframe(gcf);
end
%% Save Video
v = VideoWriter('test.mp4', 'MPEG-4');
open(v)
writeVideo(v,F)
close(v)