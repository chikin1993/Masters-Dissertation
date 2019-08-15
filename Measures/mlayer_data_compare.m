% A script to create a plot of the node activity across different layers of
% the M-Layer model compared to an observed dataset

data = [170397,116986,65983,35717,19934,10979,6081,3360,1758,684];
modelpoint55 = [170397,93448,51187,28171,15482,8564,4718,2555,1404,783];
modelpoint6 = [170397,102020,61211,36795,22169,13475,7989,4739,2874,1737];

plot(data);
hold on
plot(modelpoint55);
plot(modelpoint6);
title('Layer activity in the M-Layer model and APS collaboration net')
xlabel('Network layer')
ylabel('Layer Activity')
hold off