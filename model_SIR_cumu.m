function dy = model_SIR_cumu(t,y,k)
% SIR cumulative models
    global N
        dy = zeros(3,1);
        dy(1) = - k(1)*y(1)*y(2)/N;
        dy(2) = k(1)*y(1)*y(2)/N - k(2)*y(2);
        dy(3) = k(2)*y(2);
        dy(4) = k(1)*y(1)*y(2)/N;

end