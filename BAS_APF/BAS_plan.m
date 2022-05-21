function route = BAS_plan(start_node,dest_node,map)
% 初始化部分
PotentialField = PotentialFieldGenerator_BAS(map, dest_node);
eta = 1;
c = 1;% 步进和d0之间的比率
step = 1;% 初始步骤设置为最大输入范围
n = 1;% 迭代器
k = 2;% 空间维数

start_node = round(start_node);
xbest = start_node;
coorent_node = start_node;

fbest = PotentialField(start_node(1),start_node(2));% f为目标函数
fbest_store=fbest;
x_store=[0;coorent_node';fbest];% 用于存储路径

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
    route(1,:) = xbest;
    fbest_store = [fbest_store; fbest];
%     Route(1,:) = xbest;
%     display([num2str(i),':xbest=[',num2str(xbest),'],fbest=',num2str(fbest)]);
    step=step*eta;    
end
end