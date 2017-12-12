function range = paramrange(para_nom, order)
% set up grid of values for the contour plots of each model
global mymodelname
    strp = para_nom{order};
    if  strcmp(mymodelname, 'cumu1')
%         if strcmp(strp, '\beta')
%             range = 0:0.05:9;        
%         elseif strcmp(strp, '\alpha')
%             range = 0:0.05:7;              
%         end
%         if strcmp(strp, '\beta')
%             range = 2.2:0.025:3.8;        
%         elseif strcmp(strp, '\alpha')
%             range = 1.2:0.025:2.8;              
%         end    
        if strcmp(strp, '\beta')
%             range = 7.5:0.01:8.5;  
%             range = 3.5:0.01:4.5;
            range = 1.5:0.01:2.5;
        elseif strcmp(strp, '\alpha')
            range = 0.5:0.01:1.5;              
        end    
%     elseif strcmp(mymodelname, 'pre1')
%         if strcmp(strp, '\beta')
%             range = 3.2:0.025:4.8;        
%         elseif strcmp(strp, '\alpha')
%             range = 1.2:0.025:2.8;              
%         end
    elseif strcmp(mymodelname, 'pre1')
        if strcmp(strp, '\beta')
%             range = 9.5:0.025:10.5; 
%             range = 1:0.01:2;
            range = 3.5:0.01:4.5;
%             range = 11.5:0.01:12.5;
                
        elseif strcmp(strp, '\alpha')
            range = 0.5:0.025:1.5;              
        end
%     elseif strcmp(mymodelname, 'pre1')
%         if strcmp(strp, '\beta')
%             range = 2.2:0.25:3.8;        
%         elseif strcmp(strp, '\alpha')
%             range = 1.2:0.25:2.8;              
%         end    
%     end


end