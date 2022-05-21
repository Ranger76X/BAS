function [potential_field] = PotentialFieldGenerator_BAS(map, dest_coordinate)
MapSize = size(map);
[x, y] = meshgrid (1:MapSize(1), 1:MapSize(2));

a_scale = 1/1000;
attractive_potential = a_scale*((x-dest_coordinate(1)).^2+(y-dest_coordinate(2)).^2);

rho = (bwdist(map)/100)+1;
n = 0;
a = 0;
b = 0;

[n,in]=max(attractive_potential(:));
[a,b] = ind2sub(size(attractive_potential),in);


influence = 1.3;
r_scale = 1000;
repulsive_potential = r_scale*((1./rho - 1/influence).^2);
repulsive_potential (rho > influence) = 0;

for i = 1:MapSize(1)
    for j = 1:MapSize(2)
        if repulsive_potential(i,j) >= 53
            potential_field(i,j) = attractive_potential(a,b);
        else
            potential_field(i,j) = attractive_potential(i,j) + repulsive_potential(i,j);
        end
    end
end

potential_field = attractive_potential + repulsive_potential;
end

