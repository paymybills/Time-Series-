function ex8_mesh_sinc()
% Create meshgrid for x,y in [-5,5] and plot z = sin(sqrt(x^2+y^2))
[X,Y] = meshgrid(-5:0.25:5,-5:0.25:5);
R = sqrt(X.^2 + Y.^2);
Z = sin(R);

figure;
subplot(1,2,1);
mesh(X,Y,Z);
title('mesh: sin(sqrt(x^2+y^2))');
xlabel('x'); ylabel('y'); zlabel('z');

subplot(1,2,2);
surf(X,Y,Z);
shading interp; colorbar;
title('surf: sin(sqrt(x^2+y^2))');
xlabel('x'); ylabel('y'); zlabel('z');
end
