    
function f = sir_sens_rhs_cumu(t,y,pars)
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
    f(4) = beta*S*I/N;
    
    % f(5): dS/dbeta; f(6): dS/dalpha
    f(5)=-(beta*I/N)*y(5)-(beta*S/N)*y(7)-S*I/N;
    f(6)=-(beta*I/N)*y(6)-(beta*S/N)*y(8);
    
    % f(7): dI/dbeta; f(8): dI/dalpha
    f(7)=(beta*I/N)*y(5)+(beta*S/N-alpha)*y(7)+S*I/N;
    f(8)=(beta*I/N)*y(6)+(beta*S/N-alpha)*y(8)-I;
    
    % f(9): dR/dbeta; f(10): dR/dalpha
    f(9) = alpha*y(7);
    f(10) = alpha*y(8) + I;
    
    % f(11): dC/dbeta; f(12): dC/alpha
    f(11) = beta*I/N*y(5) + (beta*S/N)*y(7) + S*I/N;
    f(12) = (beta*I/N)*y(6) + (beta*S/N)*y(8);
    
end