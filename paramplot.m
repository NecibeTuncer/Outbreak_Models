function range = paramplot(para_nom, order)
% set up grid of values for the contour plots of each model

global mymodel

    strp = para_nom{order};
if mymodel ==1
    if strcmp(strp, '\beta')
        range = [0 2];        
    elseif strcmp(strp, '\alpha')
        range = [0.1 1];              
    end
    
elseif mymodel == 2
    if strcmp(strp, '\mu')
%         beta_range = 0:0.0001:0.01;
        range = [0 0.1];       
    elseif  strcmp(strp, '\Lambda')
        range = [0 7];          
%         beta_range = 0:0.005:0.09;
    elseif strcmp(strp, '\beta')
        range = [0 3];        
    elseif strcmp(strp, '\alpha')
%         range = 0.2:0.025:1; 
        range = [0.2 1.8];
    else
        range = [0 2];           
    end
    
elseif mymodel == 3
    if strcmp(strp, '\mu')
        range = [0 0.3];       
    elseif  strcmp(strp, '\Lambda')
        range = [0 7];          
    elseif strcmp(strp, '\beta')
        range = [0.0 3];        
    elseif strcmp(strp, '\alpha')
        range = [0.15 1];       
    elseif strcmp(strp, '\eta')
        range = [0 2];           
    end
    
elseif mymodel == 4
    if strcmp(strp, '\mu')
%         beta_range = 0:0.0001:0.01;
        range = [0 0.3];       
    elseif  strcmp(strp, '\Lambda')
        range = [0 2];          
%         beta_range = 0:0.005:0.09;
    elseif strcmp(strp, '\beta')
        range = [0 3];        
    elseif strcmp(strp, '\alpha')
        range = [0.15 1];
    elseif strcmp(strp, '\gamma')
        range = [0 1];
    elseif strcmp(strp, '\eta')
        range = [0 3];  
    else
        range = [0 1.5];           
    end
end
end