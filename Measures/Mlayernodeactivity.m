% A script to create a plot of the node activity across different layers of
% the M-Layer model.
plot(point20);
hold on
plot(point40);
plot(point60);
plot(point80);
title('Layer activity in the M-Layer model')
xlabel('Network layer')
ylabel('Layer Activity')
hold off