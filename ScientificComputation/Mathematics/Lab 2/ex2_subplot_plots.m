function ex2_subplot_plots()

x = -2:0.01:2;   

figure

subplot(3,1,1)
plot(x,x.^2)
title('x square')
xlabel('x')
ylabel('y')
legend('x^2')

subplot(3,1,2)
plot(x,x.^3)
title('x cube')
xlabel('x')
ylabel('y')
legend('x^3')

subplot(3,1,3)
plot(x,sin(x)+cos(x))
title('sin x + cos x')
xlabel('x')
ylabel('y')
legend('sin(x)+cos(x)')

end