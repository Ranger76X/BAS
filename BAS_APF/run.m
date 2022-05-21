
clc;
clear all;
close all;
% 
% load 'Map1.mat'
map=int16(im2bw(imread('map8.bmp')));
map = ~map';

start_node = [430, 410];    % coordinate of the start node
dest_node  = [50, 50]; % coordinate of the destination node

figure;
imshow(~map);
MapSize = size(map);
axis xy;
axis on;
title ('Obstacle Map');
hold on;
plot(dest_node(1), dest_node(2), 'y.', 'MarkerSize', 25);
plot(start_node(1), start_node(2), 'g.', 'MarkerSize', 25);
hold off;

PotentialField = PotentialFieldGenerator(map, dest_node);
[route, plan_succeeded] = GradientPlanner_2(PotentialField, start_node, dest_node, 10000,map);
[route2, plan_succeeded] = GradientPlanner(PotentialField, start_node, dest_node, 10000);
if(plan_succeeded)
    disp('plan succeeded! ');
else
    disp('plan failed!');
end

figure;
m = mesh (PotentialField);
camlight('left');
axis equal;

[sx, sy, sz] = sphere(20);

scale = 20;
sx = scale*sx;
sy = scale*sy;
sz = scale*(sz+1);

% hold on;
% p = mesh(sx, sy, sz);
% p.FaceColor = 'red';
% p.EdgeColor = 'none';
% p.FaceLighting = 'gouraud';

% hold off;
% colormap cool;
% for i = 1:size(route,1)
%     P = round(route(i,:));
%     z = PotentialField(P(2), P(1));
%     
%     p.XData = sx + P(1);
%     p.YData = sy + P(2);
%     p.ZData = sz + PotentialField(P(2), P(1));  
%     drawnow; 
% end
