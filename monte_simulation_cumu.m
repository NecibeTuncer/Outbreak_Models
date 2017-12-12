%contour_plot_errors
clear all
clf

global mymodel mymodelname tforward tmeasure initial_c iind Pdata true_params N
numiter = 1000;

mymodel = 1;
mymodelname = 'cumu1';
true_params = [4 1];
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
 
noisemags = [0, 0.01, 0.05, 0.1, 0.2, 0.3];
numnoise = numel(noisemags);
Xcomp = zeros(numnoise * numpar, numiter);

for noisei = 1:6
% for noisei = 4:5
noisemag = noisemags(noisei);


for i= 1:numiter
    i
      mynoise = noisemag*y_trp(tmeasure(:),iind)';
  Pdata = normrnd(y_trp(tmeasure(:),iind)', mynoise);
%  Pdata  = poissrnd((y_trp(tmeasure(:),iind)'));
%  Pdata = (noisemag*(y_trp(tmeasure(:),iind)')).*randn(1,size(tmeasure,2)) + y_trp(tmeasure(:),iind)'
 k= 0.1*ones(size(true_params)); 
%  k = true_params;
%  k = [0.4 0.01 0.05];
 lb = zeros(size(true_params));
%  [k,resnorm,~,exitflag] =  lsqcurvefit(@my_obj_fun, k, tmeasure, Pdata,lb,[],...
%     optimset('Disp','iter','TolX',10^(-8),'TolFun',10^(-8),'MaxFunEvals', 1e+5,'MaxIter',1e+5))
 [k,~,exitflag] = fminsearchbnd(@err_in_data_cumu,k,lb,[],optimset('Display','iter',...
                'TolX',10^(-8),'TolFun',10^(-8),'MaxFunEvals', 1e+5,'MaxIter',1e+5))  
 X(:,i) = k';
 AllData(:,i) = Pdata';
 conv(i) = exitflag;
end

Xcomp((2*noisei-1): (2*noisei), :) = X;

h2 = figure(2)
plot(tdata,Pdata,'o',tforward,y_trp(:,iind),'LineWidth',1.5)
title('Infected Individual Generated Data')
% saveas(h2, 'mod4dat05','pdf')

n = 3;
for i = 1:(length(true_params)-1)
    for j = (i+1):length(true_params)
        h = figure(n)
        plot(X(i,:), X(j,:),'.b','MarkerSize',20)
        hold on
        plot(true_params(i), true_params(j),'pr','MarkerSize',30,'MarkerFaceColor','r')
        set(gca, 'box', 'off')
        NumTicks = 3;
        set(gca,'XLim', [0 2*true_params(i)]);
%         set(gca,'XLim', [0 1]);
        L = get(gca,'XLim');
        set(gca,'XTick',linspace(L(1),L(2),NumTicks))
        set(gca,'YLim', [0 2*true_params(j)]);
%         set(gca,'YLim', [0 2]);
        Ly = get(gca,'YLim');
        set(gca,'YTick',linspace(Ly(1),Ly(2),NumTicks))
        set(gca,'FontSize',12,'FontName','Arial','linewidth',2,'FontWeight','Bold')
        
        xlabel(para_nom(i),'FontSize',20,'FontName','Tahoma');
        ylabel(para_nom(j),'FontSize',20,'FontName','Tahoma');
        title(strcat('noise magnitude = ', num2str(noisemag)...
            ),'FontSize',11,'FontName','Tahoma')
        hold off
        saveas(h,strcat('cumod',num2str(mymodel),num2str(n-2),'noise', num2str(noisemag*100), 'fms'),'fig')
        saveas(h,strcat('cumod',num2str(mymodel),num2str(n-2),'noise', num2str(noisemag*100), 'fms'),'pdf')
        n = n+1;
    end
end



% calculate AREs score:
num_para = length(true_params);
arescore = zeros(1,num_para);
    for i = 1:num_para
        arescore(i) = 100/numiter * sum(abs(true_params(i) - X(i,:)))/abs(true_params(i));
    end
    
    total_ARE(noisei,:) = arescore;

end

beep
export(dataset(Xcomp), 'file', 'estimates41cumu.txt')
export(dataset(total_ARE), 'file', 'ARE41cumu.txt')




% end