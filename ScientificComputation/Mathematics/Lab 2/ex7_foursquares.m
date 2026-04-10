function ex7_foursquares()
% EX7_FOUR SQUARES  Create a 2x2 subplot layout:
% Top-left:  y = x^2
% Top-right: y = sqrt(x)
% Bottom-left: y = exp(x)
% Bottom-right: y = ln(x)

% Domains
x_all = -10:0.1:10;           % for x^2 (allows negatives)
x_pos  = 0:0.1:10;             % for sqrt and ln (non-negative)

y1 = x_all.^2;
y2 = sqrt(x_pos);
y3 = exp(x_pos);
y4 = log(x_pos);

figure;

subplot(2,2,1);
plot(x_all,y1,'b-','LineWidth',1.2);
title('y = x^2'); xlabel('x'); ylabel('y'); grid on;

subplot(2,2,2);
plot(x_pos,y2,'r-','LineWidth',1.2);
title('y = sqrt(x)'); xlabel('x'); ylabel('y'); grid on;

subplot(2,2,3);
plot(x_pos,y3,'g-','LineWidth',1.2);
title('y = e^{x}'); xlabel('x'); ylabel('y'); grid on;

subplot(2,2,4);
plot(x_pos,y4,'m-','LineWidth',1.2);
title('y = ln(x)'); xlabel('x'); ylabel('y'); grid on;

sgtitle('Four related plots');
end
