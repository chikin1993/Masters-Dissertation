% A script to generate a network and plot the degree distributions
[alpha, beta] = GRmod_rand(10000, 10, 5, 0.5, 0.5);

% Create vectors for the degrees
alphadeg = sum(alpha);
betadeg = sum(beta);

% Display this on a histogram to show the degree distribution
histogram(alphadeg,'Normalization','probability')
hold on
histogram(betadeg, 'Normalization','probability')
legend
title('Degree distributions of the Random Grow-Reinforce Model')
xlabel('Degree of node')
ylabel('Probability of occurrence')
hold off