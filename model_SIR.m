function dy = model_SIR(t,y,k)
    global N
%     if ~ismember(mymodel,[2,6])
        dy = zeros(3,1);
        dy(1) =  - k(1)*y(1)*y(2)/N ;
        dy(2) = k(1)*y(1)*y(2)/N - (k(2))*y(2);
        dy(3) = k(2)*y(2) ;


end