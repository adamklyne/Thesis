% Test online k means
% This was to find an appropriate value for K
% Was tested using datasets of 1e2,1e3,1e4,1e5 and 1e6 datapoints
clear all
close all
clc
V = [10 100 1000 10000];
elapse_time=[];
tot_error=[];
max_val = 255;
min_val = 0;
numData = 1e6;
dim = 3;
data = (min_val + (max_val-min_val).*rand(dim, numData));
R = data(1,:,:);
G = data(2,:,:);
B = data(3,:,:);
eta = 0.25;

for idx = 1:length(V)
    
    k = V(idx);
    weights = (min_val + (max_val-min_val).*rand(dim,k));
    old_weights = weights;
    label = zeros(1,numData);
    error = 0;
    tic
    for i = 1:numData
        dist = zeros(k,1);
        for K = 1:k
            for j = 1:dim
                dist(K,:) = dist(K,:) +  sqrt((data(j,i) - weights(j,K))^2);
            end
        end
        [~,winner] = min(dist);
        weights(:,winner) = weights(:,winner) + eta*(data(:,i) - weights(:,winner));
        label(i) = winner; 
    end
    
    elapse_time(idx) = toc
    for j = 1:numData
            error = error + pdist2(data(:,j)',weights(:,label(j))','euclidean');
    end
    tot_error(idx) = error/numData;
    
end


output = weights;
figure('units','normalized','outerposition',[0 0 1 1]);
plot(elapse_time, tot_error, '*-', 'LineWidth',2)
text(elapse_time+0.01, tot_error+2, cellstr({'K = 10','K = 100', 'K = 1000', 'K = 10000'}))
xlabel('Elapsed time [s]')
ylabel('Clustering Error')
ylim([0 max(tot_error + 10)])
title('Clustering Error as a function of the number of output nodes - 1\times 10^6 data points')
print -depsc2 -r600 error_v_time_1000000.eps

save '1000000.mat'
% plot3(R,G,B,'o');drawnow;
% figure(2)
% hold on
% plot3(output(1,:,:), output(2,:,:), output(3,:,:), 'rx', 'MarkerSize', 20, 'LineWidth',2)
% plot3(old_weights(1,:,:), old_weights(2,:,:), old_weights(3,:,:), 'gx', 'MarkerSize', 20, 'LineWidth',2)
