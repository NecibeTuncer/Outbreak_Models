%contour_plot_errors
clear all
clf

global mymodel mymodelname tforward tmeasure initial_c iind Pdata true_params N

mymodel = 1;
mymodelname = 'cumu1';
true_params = [2 1];
numpar = length(true_params);           % number of parameters
initial_c = [100 1 0 1];
iind = 4;
para_nom = {'\beta','\alpha'}; 
mylegend = {'S','I','R'};
N = sum(initial_c(1:3));

datasize = 51;                  % number of data points
intervs = datasize -1;          % number of intervals
inc = 100; % 10-time-finer time points - does not make any difference
endpt = 20;
tdata = linspace(0,endpt, datasize);                % plotting purpose 
tforward = linspace(0, endpt, intervs*inc+1);   % solve the ode's at 10-time-finer time points
[~,y_trp] =ode45(@(t,y)(model_SIR_cumu(t,y,true_params)),tforward,initial_c);


% This is to make sure t_n occurs at the first time the infected class
% population gets below 1
myI =  y_trp(:,2);
endpt = sum(myI >= 1)*endpt/(intervs*inc);
tdata = linspace(0,endpt, datasize);                % plotting purpose 
inc = 1;
tforward = linspace(0, endpt +  1/(datasize*inc), datasize*inc);   
tmeasure = 1+ inc * (0:(datasize-1));
[~,y_trp] =ode45(@(t,y)(model_SIR_cumu(t,y,true_params)),tforward,initial_c);


Pdata = y_trp(tmeasure(:),iind)';
h = figure(1)
plot(tforward,y_trp,'LineWidth',1.5)
% legend('S','I','R')
legend(mylegend)
title(strcat('trueparam = [',num2str(true_params),'], iniSIR = [',num2str(initial_c),']'))
 saveas(h,strcat('mod',num2str(mymodel),'ana'),'pdf')
 
 
z = 1;
for p1 = 1:numpar - 1                   % p1: index of 1st varied parameter
    % set up grid of values 
%     p1 = 2;
%     p2 = 3;
    beta_range = paramrange(para_nom, p1);
    for p2 = (p1+1):numpar              % p2: index of 2nd varied parameter
        alpha_range = paramrange(para_nom, p2);
        [ALPHA,BETA]=meshgrid(alpha_range,beta_range); 
        maxi = numel(beta_range);
        maxj = numel(alpha_range);
        ED = zeros(maxi,maxj);
        k = true_params;
        % can we improve performance by not using for loop?
        for i=1:maxi
            for j=1:maxj
                k(p1) = BETA(i,j);
                k(p2) = ALPHA(i,j);
                ED(i,j) = err_in_data_cumu(k);
            end
        end     
        z = z + 1;
        h = figure(z)
%         contour(BETA,ALPHA,ED,20)
        [C,g] = contour(BETA,ALPHA,ED,[250 500 1000 2000 4000 8000 16000 32000 64000])
        clabel(C,g,'LabelSpacing',72*5)
        hold on
        plot(true_params(1), true_params(2),'pr','MarkerSize',20,'MarkerFaceColor','r')
        hold off
        xlabel(para_nom(p1),'FontSize',20,'FontName','Tahoma');
        ylabel(para_nom(p2),'FontSize',20,'FontName','Tahoma');
        saveas(h,strcat('cumod',num2str(mymodel),'cont21',num2str(z)),'fig')
        saveas(h,strcat('cumod',num2str(mymodel),'cont21',num2str(z)),'pdf')
    %     figure(2)
    %     surf(ALPHA,BETA,ED)
    end
end 
    
      
beep




