function ex5_piecewise()
x1 = linspace(0,1,201);
f1 = x1.^2;

x2 = linspace(1,4,301);
f2 = x2.^(x2-1)./exp(2);

x3 = linspace(4,10,301);
f3 = exp(3/2).*sin(4*pi./x3);

figure; hold on;
plot(x1,f1,'b-','LineWidth',1.4);
plot(x2,f2,'r-','LineWidth',1.4);
plot(x3,f3,'g-','LineWidth',1.4);
hold off; grid on;
title('Piecewise function f(x)');
xlabel('x'); ylabel('f(x)');
legend('x^2 (0<=x<=1)','x^{x-1}/e^2 (1<=x<=4)','e^{3/2} sin(4\pi/x) (4<=x<=10)','Location','Best');
end
