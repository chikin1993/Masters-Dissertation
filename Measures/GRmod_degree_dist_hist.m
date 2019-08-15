% A script to generate a network and plot the degree distributions
[alpha, beta] = GRmod(10000, 10, 5, 0.5, 0.5);

% Create vectors for the degrees
alphadeg = sum(alpha);
betadeg = sum(beta);

% Display this on a histogram to show the degree distribution
histogram(alphadeg)
hold on
histogram(betadeg)
legend
title('Degree distributions of GRmod')
xlabel('Degree Of Node')
ylabel('Number of Occurrences')
hold off