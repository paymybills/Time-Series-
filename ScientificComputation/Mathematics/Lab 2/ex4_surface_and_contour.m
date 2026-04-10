function ex4_surface_and_contour()

x = -2:0.05:2;
y = -2:0.05:2;

[X,Y] = meshgrid(x,y);
Z = exp(-(X.^2 + Y.^2));

figure

subplot(1,2,1)
surf(X,Y,Z)
title('surface plot')
xlabel('x')
ylabel('y')
zlabel('z')

subplot(1,2,2)
contourf(X,Y,Z)
title('contour plot')
xlabel('x')
ylabel('y')

end