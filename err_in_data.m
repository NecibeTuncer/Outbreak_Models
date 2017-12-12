function error_in_data = err_in_data(k)    % objective function
    global tforward tmeasure initial_c iind Pdata 
    [~,y] = ode45(@(t,y)(model_SIR(t,y,k)),tforward,initial_c);
    B = y(tmeasure(:),iind)';
    error_in_data = sum((B - Pdata).^2);
end

