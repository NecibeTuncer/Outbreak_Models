clf               % clear any previous figures
global N % so that we're not estimating N
% beta=1.0;
% alpha=1.0/5.0;    % five day infectious period	
% betas = [1.5 2 3 4 5 8 10];
% betas = [2.5 3 5]
betas = [2 4 8];

alpha = 1;
N=101.0;
numi = length(betas);

sens_res = zeros(4*3, 2)

for i = 1:numi

beta = betas(i);
R0 = beta/alpha;
pars=[beta,alpha];

datasize = 50;                  % number of data points
endpt = 10;
% inc = 10; % 10-time-finer time points
inc = 1; % no refinement yet
tdata = linspace(0,endpt, datasize);                % plotting purpose 
tforward = linspace(0, endpt, datasize*inc);   % solve the ode's at 10-time-finer time points
tmeasure = 1+ inc * (0:(datasize-1));


% tspan=[0,10];	      % simulate for 50 days
y0=[100;1;0;0;0;0;0;0;0];       % one initial infective
                          % six sensitivities are initially zero

% recall : comp 1 is S, comp 2 is I, comp 3 is R
% component 4 is dS/dbeta, component 5 is dS/dalpha
% component 6 is dI/dbeta, component 7 is dI/dalpha
% component 8 is dR/dbeta, component 9 is dR/dalpha

[t,y]=ode45(@sir_sens_rhs, tforward, y0, [], pars);	


h = figure(1)
subplot(2,numi,i+numi);   % make a 2 panel plot 
plot(t,y(:,2));   % plot prevalence of infection over time in upper panel
title('Prevalence Curve I(t)')
subplot(2,numi,i);   % move to lower panel
hold on
% plot(t,y(:,6));         % plot dI/dbeta as blue curve
% plot(t,y(:,7),'-r');    % plot dI/dalpha as red curve
plot(t,y(:,6), '-b', t, y(:,7), '-r'); 
legend('beta', 'alpha');
title('Sensitivities of I(t)')
hold off



y_true = y(:,2); % true prevalence 
sig0 = 0.1; % noise standard deviation/noisemag = 10%
% xi = 0; % absolute error
% xi = 1/2; % poisson error
xi = 1; % relative error
w = 1./(y_true.^(2*xi));
W = diag(w);
% W = eye(datasize);

%  Pdata = (sig0*(y_trp(tmeasure(:),iind)')^xi).*randn(1,size(tmeasure,2)) + y_trp(tmeasure(:),iind)';
%  k= 0.1*ones(size(true_params)); 
%  lb = zeros(size(true_params));
%  [k,~,exitflag] = fminsearchbnd(@err_in_data,k,lb,[],optimset('Display','iter',...
%                 'TolX',10^(-8),'TolFun',10^(-8),'MaxFunEvals', 1e+5,'MaxIter',1e+5));  


y_sens = y(:,6:7); % sensitivities from y
% sens_mat = reshape(y_sens, 2, 3*datasize)'; % sensitivity matrix: 
% [
% y4(t1) y5(t1);
% y6(t1) y7(t1);
% y8(t1) y9(t1);
% ...
% y4(t50) y5(t50);
% y6(t50) y7(t50);
% y8(t50) y9(t50);
% ]

sens_mat = y_sens;
cov_mat = (sig0^2).*inv(sens_mat'*W*sens_mat); % should be a 2x2 matrix


% coefficient of variation
var_beta = cov_mat(1,1);
var_alpha = cov_mat(2,2);
CV_beta = sqrt(var_beta)/beta; % sd of beta divided by the beta0
CV_alpha = sqrt(var_alpha)/alpha; % sd of alpha divided by the alpha0
rho = cov_mat(1,2)/sqrt(var_beta*var_alpha);
var_R0 = (beta/alpha)*(var_beta/beta^2 + var_alpha/alpha^2 - 2*cov_mat(1,2)/(beta*alpha));
CV_R0 = sqrt(var_R0)/R0;

format short
sens_res((4*i-3):4*i,1:2) = [beta CV_beta;
alpha CV_alpha;
R0 CV_R0;
rho NaN]



end


% 
% 
% saveas(h,'sensitivities_pre','pdf')
% saveas(h,'sensitivities_pre','fig')
% 









    
    
    
   
