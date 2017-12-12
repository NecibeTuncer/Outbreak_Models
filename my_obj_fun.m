    function myobj = my_obj_fun(k,tdata)     
        global initial_c tforward tmeasure iind
        [T,Y] = ode45(@(t,y)(model_SIR(t,y,k)),tforward,initial_c);
        % respectively, initial value for x1,x2,x3,x4
        myobj = Y(tmeasure(:),iind)';  
        % myobj is the value of the population we're trying to fit   
        % either, S, or I, or R, or other class' population
    end  