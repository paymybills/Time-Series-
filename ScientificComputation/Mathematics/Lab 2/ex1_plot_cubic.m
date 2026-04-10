function ex1_plot_cubic()
x = linspace(-3,3,601);
y = x.^3 - 3.*x + 1;
tp_x = [-1, 1];
tp_y = tp_x.^3 - 3.*tp_x + 1;
figure;
plot(x,y,'b-','LineWidth',1.5);
hold on;
plot(tp_x,tp_y,'ro','MarkerSize',8,'LineWidth',1.5);
hold off;
grid on;
title('y = x^3 - 3x + 1');
xlabel('x');
ylabel('y');
legend('y','Turning points','Location','Best');
axis tight;
end
