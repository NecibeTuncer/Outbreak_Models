
clear all
close all
% X = importdata('estimates41.txt');
X = importdata('estimates41cumu.txt');

beta = 4;
alpha = 1;
R0 = beta/alpha;
sig0s = [0 0.01 0.05 0.1 0.2 0.3];

numi = length(sig0s);
sens_res = zeros(5*numi, 2);


for i = 1: numi
% i = 1
    sig0 = sig0s(i);
    beta_est = X.data(2*i-1,:);
    alpha_est = X.data(2*i,:);

    varmat = cov(beta_est, alpha_est);
    beta_var = varmat(1,1);
    alpha_var = varmat(2,2);
    covar = varmat(1,2);
    R0_var = R0^2*(beta_var/beta^2 + alpha_var/alpha^2 - 2*covar/beta/alpha);
        
    rho_est = covar/sqrt(beta_var*alpha_var);
    beta_CV = sqrt(beta_var)/beta;
    alpha_CV = sqrt(alpha_var)/alpha;    
    R0_CV = sqrt(R0_var)/R0;
    format short
    sens_res((5*i-4):5*i,1:2) = [sig0 sig0;
    beta beta_CV;
    alpha alpha_CV;
    R0 R0_CV;
    rho_est rho_est]
end


% ARE = importdata('ARE41.txt');
ARE = importdata('ARE41cumu.txt');
AREtab = ARE.data;