function ex9_mobius()
% Plot a Möbius strip using parametric equations
u = linspace(0,2*pi,120);
v = linspace(-1,1,40);
[U,V] = meshgrid(u,v);

X = (1 + 0.5*V.*cos(U/2)).*cos(U);
Y = (1 + 0.5*V.*cos(U/2)).*sin(U);
Z = 0.5*V.*sin(U/2);

figure;
surf(X,Y,Z,'FaceColor','interp','EdgeColor','none');
colormap(jet); colorbar;
title('Möbius strip');
xlabel('x'); ylabel('y'); zlabel('z');
end
