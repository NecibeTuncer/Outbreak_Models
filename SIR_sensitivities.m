function sir_sensitivities	
    clf               % clear any previous figures
    beta=1.0;
    alpha=1.0/5.0;    % five day infectious period	
    N=1000.0;
    pars=[beta,alpha,N];

    tspan=[0,50];	      % simulate for 50 days
    y0=[999;1;0;0;0;0];       % one initial infective
                              % four sensitivities are initially zero
                              
% recall : component 1 is S, component 2 is I
% component 3 is dS/dbeta, component 4 is dS/dalpha
% component 5 is dI/dbeta, component 6 is dI/dalpha

	[t,y]=ode45(@sir_sens_rhs,tspan,y0,[],pars);	
    
    figure(1)
    subplot(2,1,1);   % make a 2 panel plot 
    plot(t,y(:,2));   % plot prevalence of infection over time in upper panel

    subplot(2,1,2);   % move to lower panel
    hold on
    plot(t,y(:,5));         % plot dI/dbeta as blue curve
    plot(t,y(:,6),'-r');    % plot dI/dalpha as red curve
    hold off
end

function f = sir_sens_rhs(t,y,pars)
    f=zeros(6,1);
    
    beta=pars(1);
    alpha=pars(2);
    N=pars(3);
    S=y(1);
    I=y(2);
    
    f(1)=-beta*S*I/N;
    f(2)=beta*S*I/N-alpha*I;
    
    f(3)=-(beta*I/N)*y(3)-(beta*S/N)*y(5)-S*I/N;
    f(4)=-(beta*I/N)*y(4)-(beta*S/N)*y(6);
    
    f(5)=(beta*I/N)*y(3)+(beta*S/N-alpha)*y(5)+S*I/N;
    f(6)=(beta*I/N)*y(4)+(beta*S/N-alpha)*y(6)-I;
    
end
