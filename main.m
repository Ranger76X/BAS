clear all;
close all;
clc;

% load 'Map1.mat'
map=int16(im2bw(imread('map8.bmp')));
map = ~map;

 
% start_node = [550, 550];    % coordinate of the start node
start_node = [430, 410];    % coordinate of the start node
% start_node = [460, 320];    % coordinate of the start node
dest_node  = [50, 50];      % coordinate of the destination node
[PotentialField,repp,actp] = PotentialFieldGenerator(map, dest_node, start_node);
[gx, gy] = gradient (-PotentialField');
Size = size(PotentialField');
[x, y] = meshgrid (1:Size(1), 1:Size(2));

figure;
skip = 5;
xidx = 1:skip:Size(2);
yidx = 1:skip:Size(1);
q = quiver(x(yidx,xidx), y(yidx,xidx), gx(yidx,xidx), gy(yidx,xidx), 1.2);
q.LineWidth = 1;

% 初始化部分
eta = 1;
c = 1;% 步进和d0之间的比率
step = 10;% 初始步骤设置为最大输入范围
n = 500;% 迭代器
k = 2;% 空间维数
xbest = start_node;
coorent_node = start_node;

fbest = PotentialField(start_node(1),start_node(2));% f为目标函数
fbest_store=fbest;
x_store=[0;coorent_node';fbest];% 用于存储路径

% while (coorent_node ~= dest_node)
for i = 1:n
    
    d0=step/c;% d0表示质点与须之间的长度
    dir=rands(k,1); % 随机方向向量
    dir=dir/(eps+norm(dir));% 归一化
    
    if dir(1) < 0.5 && dir(1) >= 0 || (dir(1) < 0 && dir(1) > -0.5)
        dir(1) = 0;
    end
    if dir(1) >= 0.5
        dir(1) = 1;
    end
    if dir(1) <= -0.5
        dir(1) = -1;
    end
    
    if dir(2) < 0.5 && dir(2) >= 0 || (dir(2) < 0 && dir(2) > -0.5)
        dir(2) = 0;
    end
    if dir(2) >= 0.5
        dir(2) = -1;
    end
    if dir(2) <= -0.5
        dir(2) = -1;
    end
    
    
    xleft=coorent_node+dir'*d0;% 左须
    fleft=PotentialField(xleft(1),xleft(2));

    xright=coorent_node-dir'*d0;% 左须
    fright=PotentialField(xright(1),xright(2));    
    coorent_node = coorent_node - round(step * dir') * sign(fleft-fright);% 判优
     
    flag=PotentialField(coorent_node(1),coorent_node(2));     
    if flag<fbest
        xbest=coorent_node;
        fbest=flag;
    end         
    x_store=cat(2, x_store, [i;coorent_node';fbest]);
    route(:,i) = xbest;
    fbest_store = [fbest_store; fbest];
    
    display([num2str(i),':xbest=[',num2str(xbest),'],fbest=',num2str(fbest)]);
    step=step*eta;    
end


hold on;
plot(start_node(1), start_node(2), 'g.', 'MarkerSize', 30)
plot(dest_node(1), dest_node(2), 'y.', 'MarkerSize', 30);
plot (route(1,:), route(2,:), 'r', 'LineWidth', 2);
hold on;

A = unique(route','rows');
% A = A';
B = A;
figure;
plot(B(:,1),B(:,2),'ro');
hold on;
X = rels(A, 3, 1, 1, 0);

ANS = polyfit(A(:,1),A(:,2),6);
x0=50:420;
y0=ANS(1)*x0.^6; 
for num=2:1:7     
    y0=y0+ANS(num)*x0.^(7-num);
end
Y = [y0;x0];
plot(Y(1,:),Y(2,:),'r','LineWidth', 1);