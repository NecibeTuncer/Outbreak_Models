    
function f = sir_sens_rhs(t,y,pars)
    global N
    
    f=zeros(6,1);
    
    beta=pars(1);
    alpha=pars(2);
    S=y(1);
    I=y(2);
    R = y(3);
    
    f(1)=-beta*S*I/N;
    f(2)=beta*S*I/N-alpha*I;
    f(3) = alpha * I;
    
    f(4)=-(beta*I/N)*y(4)-(beta*S/N)*y(6)-S*I/N;
    f(5)=-(beta*I/N)*y(5)-(beta*S/N)*y(7);
     
    f(6)=(beta*I/N)*y(4)+(beta*S/N-alpha)*y(6)+S*I/N;
    f(7)=(beta*I/N)*y(5)+(beta*S/N-alpha)*y(7)-I;
    
    f(8) = alpha*y(6);
    f(9) = alpha*y(7) + I;
    
    
end