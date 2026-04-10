function ex3_surface_hyperbolic()
% Surface z = x^2 - y^2
[X,Y] = meshgrid(-3:0.1:3,-3:0.1:3);
Z = X.^2 - Y.^2;
figure;
surf(X,Y,Z);
shading interp;
colorbar;
title('Surface z = x^2 - y^2');
xlabel('x'); ylabel('y'); zlabel('z');
end
