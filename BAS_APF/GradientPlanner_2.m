function [route, plan_succeeded] = GradientPlanner_2(potential_field, start_coordinate, dest_coordinate, max_iteration,map)
[gx, gy] = gradient (-potential_field);
Size = size(potential_field);
[x, y] = meshgrid (1:Size(1), 1:Size(2));

figure;
skip = 5;
xidx = 1:skip:Size(2);
yidx = 1:skip:Size(1);
q = quiver(x(yidx,xidx), y(yidx,xidx), gx(yidx,xidx), gy(yidx,xidx), 1.2);
q.LineWidth = 1;

route = [start_coordinate(1),start_coordinate(2)];
currunt_coordinate = start_coordinate;
plan_succeeded = 0;
for i = 2:max_iteration+1
    if((currunt_coordinate(1)-dest_coordinate(1))^2 + (currunt_coordinate(2)-dest_coordinate(2))^2 > 1) 
        a = [gx(currunt_coordinate(2),currunt_coordinate(1));gy(currunt_coordinate(2),currunt_coordinate(1))];
        step = a/norm(a);
%         Step(i-1,:) = step;
        
        if i > 10
            if (route((i-10),1)-route((i-1),1)<=1) && (route((i-10),2)-route((i-1),2)<=1)
                route(i,:) = BAS_plan(route(i-1,:),dest_coordinate,map);
            else
                route(i,1) = route((i-1),1)+step(1);
                route(i,2) = route((i-1),2)+step(2);
            end
        else
            route(i,1) = route((i-1),1)+step(1);
            route(i,2) = route((i-1),2)+step(2);
        end
        
        currunt_coordinate = [round(route(i,1)),round(route(i,2))];
    else
        plan_succeeded = 1;
        break;
    end
end

hold on;
plot(start_coordinate(1), start_coordinate(2), 'g.', 'MarkerSize', 30)
plot(dest_coordinate(1), dest_coordinate(2), 'y.', 'MarkerSize', 30);
plot (route(:,1), route(:,2), 'r', 'LineWidth', 2);
title('梯度下降混合BAS导航');
end

