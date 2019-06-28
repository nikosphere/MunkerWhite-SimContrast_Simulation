%% Load Model Paramters
A = 1;
B = 1;
C = 1;
dt = 0.01;
Gex = fspecial('gaussian', [1 12], 3);
Ginh = fspecial('gaussian', [1 20], 5);
%% Line
x = zeros(1000,100);
I = [zeros(1,50) repelem(0.5,50)];
%% Wide Line
x = zeros(1000,100);
I = [zeros(1,45) repelem(0.5,10) zeros(1,45)];
%% Very Wide Line
x = zeros(1000,100);
I = [zeros(1,40) repelem(0.5,20) zeros(1,40)];
%% Apply Model
for t = 1:999
    x(t+1, :) = x(t, :) + dt.*( ...
        -A*x(t,:) + (B-x(t,:)).*conv(I, Gex, 'same') - conv(I,Ginh, 'same')...
        );  
end 
%% Plot
figure('DefaultAxesFontSize',24, 'Position', [10 10 1000 800])
title({"100 On Center/Off Surround Neurons", "Line Width = 10 Neurons"})
yyaxis left
xlabel("Position")
plot(x(1000,:),'LineWidth',2)
ylabel('Activity')
ylim([-0.1 0.2])
hold on
yyaxis right
ylim([-0.3 0.6])
ylabel('Input')
plot(I,'LineWidth',2)
%% Render Video
F(100) = struct('cdata',[],'colormap',[]);
figure('DefaultAxesFontSize',24, 'Position', [10 10 1000 800])
for i=1:100
    title({"100 On Center/Off Surround Neurons", "Line Width = 10 Neurons"})
    yyaxis left
    xlabel("Position")
    plot(x(i,:),'LineWidth',2)
    ylabel('Activity')
    ylim([-0.1 0.2])
    hold on
    yyaxis right
    ylim([-0.3 0.6])
    ylabel('Input')
    plot(I,'-r','LineWidth',2)
    hold off
    F(i) = getframe(gcf);
end
%% Save video
v = VideoWriter('test.mp4', 'MPEG-4');
open(v)
writeVideo(v,F)
close(v)
