clf               % clear any previous figures
global N % so that we're not estimating N
% beta=1.0;
% alpha=1.0/5.0;    % five day infectious period	
% betas = [2.5 3 5 8 10];
% betas = [2.5 3 5];
betas = [2 4 8];
% betas = [4];
alpha = 1;
N=101.0;

sig0s = [0 0.01 0.05 0.1 0.2 0.3];
numi = length(sig0s);
% numi = length(betas);
sens_res = zeros(5*numi, 2);



mymodel = 1;
mymodelname = 'cumu1';
true_params = [4 1];
numpar = length(true_params);           % number of parameters
initial_c = [100 1 0 1];
iind = 4;
para_nom = {'\beta','\alpha'}; 
mylegend = {'S','I','R','C'};
N = sum(initial_c(1:3));

datasize = 51;                  % number of data points
intervs = datasize -1;          % number of intervals
inc = 100; % 100-time-finer time points - does not make any difference
endpt = 20;
% tdata = linspace(0,endpt, datasize);                % plotting purpose 
tforward = linspace(0, endpt, intervs*inc+1);   % solve the ode's at 10-time-finer time points
[~,y_trp] =ode45(@(t,y)(model_SIR_cumu(t,y,true_params)),tforward,initial_c);


myI =  y_trp(:,iind);
endpt = sum(myI >= 1)*endpt/(intervs*inc);
tdata = linspace(0,endpt, datasize);                % plotting purpose 
inc = 1;
tforward = linspace(0, endpt +  1/(datasize*inc), datasize*inc);   
tmeasure = 1+ inc * (0:(datasize-1));
[~,y_trp] =ode45(@(t,y)(model_SIR_cumu(t,y,true_params)),tforward,initial_c);



% tspan=[0,10];	      % simulate for 50 days
y0=[100;1;0;1;0;0;0;0;0;0;0;0];       % one initial infective
                          % six sensitivities are initially zero

% xi = 0; % absolute error
% xi = 1/2; % poisson error
xi = 1; % relative error

for i = 1:numi

% beta = betas(i);
% sig0 = 0.1;

sig0 = sig0s(i);
beta = betas(2);

R0 = beta/alpha;
pars=[beta,alpha];

[t,y]=ode45(@sir_sens_rhs_cumu, tforward, y0, [], pars);	


figure(1)
subplot(2,numi,i+numi);   % make a 2 panel plot 
plot(t,y(:,4));   % plot prevalence of infection over time in upper panel
title('Cumulative Time Curve')
subplot(2,numi,i);   % move to lower panel
hold on
plot(t,y(:,11), '-b', t, y(:,12), '-r'); 
legend('beta', 'alpha');
title('Sensitivities of C(t)')
hold off



y_true = y(:,4); % true cumulative
% 
% w = 1./(y_true.^(2*xi));
% W = diag(w);
W = eye(datasize);

%  Pdata = (sig0*(y_trp(tmeasure(:),iind)')^xi).*randn(1,size(tmeasure,2)) + y_trp(tmeasure(:),iind)';
%  k= 0.1*ones(size(true_params)); 
%  lb = zeros(size(true_params));
%  [k,~,exitflag] = fminsearchbnd(@err_in_data,k,lb,[],optimset('Display','iter',...
%                 'TolX',10^(-8),'TolFun',10^(-8),'MaxFunEvals', 1e+5,'MaxIter',1e+5));  


y_sens = y(:,11:12); % sensitivities from y
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
cov_mat(1,2) == cov_mat(2,1)
rho = cov_mat(1,2)/sqrt(var_beta*var_alpha);
var_R0 = (beta/alpha)^2*(var_beta/beta^2 + var_alpha/alpha^2 - 2*cov_mat(1,2)/(beta*alpha));
CV_R0 = sqrt(var_R0)/R0;

format short

sens_res((5*i-4):5*i,1:2) = [sig0 sig0;
beta CV_beta;
alpha CV_alpha;
R0 CV_R0;
rho rho]



end


% 
% 
% saveas(h,'sensitivities_cumu','pdf')
% saveas(h,'sensitivities_cumu','fig')
% 

















    
    
    
   
