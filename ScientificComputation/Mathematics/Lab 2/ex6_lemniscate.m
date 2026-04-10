function ex6_lemniscate()
t = linspace(0,2*pi,800);
x = cos(t)./(1 + sin(t).^2);
y = cos(t).*sin(t)./(1 + sin(t).^2);
figure;
plot(x,y,'k-','LineWidth',1.25);
axis equal; grid on;
title('Lemniscate of Bernoulli');
xlabel('x'); ylabel('y');
end
