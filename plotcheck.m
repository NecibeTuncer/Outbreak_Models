% scatter plot the estimates of beta and alpha 
% 6 noise levels

clear all


X = importdata('estimates41cumu.txt');
Xdat = X.data;
true_params = [4 1];
numpars = length(true_params);
noisemags = [0, 0.01, 0.05, 0.1, 0.2, 0.3];
mymodel = 1;
para_nom = {'\beta','\alpha'}; 
n = 3;


for k = 1:6; % noise level; e.g. k = 1 means sigma = 0;
    noisemag = noisemags(k);
    X = Xdat((numpars*(k-1)+1):(numpars*k),:);
    for i = 1:(length(true_params)-1)
        for j = (i+1):length(true_params)
            h = figure(n)
            plot(X(i,:), X(j,:),'.b','MarkerSize',20)
            hold on
            plot(true_params(i), true_params(j),'pr','MarkerSize',30,'MarkerFaceColor','r')
            set(gca, 'box', 'off')
            NumTicks = 3;
            set(gca,'XLim', [0 2*true_params(i)]);
            L = get(gca,'XLim');
            set(gca,'XTick',linspace(L(1),L(2),NumTicks))
            set(gca,'YLim', [0 2*true_params(j)]);
            Ly = get(gca,'YLim');
            set(gca,'YTick',linspace(Ly(1),Ly(2),NumTicks))
            set(gca,'FontSize',12,'FontName','Arial','linewidth',2,'FontWeight','Bold')

            xlabel(para_nom(i),'FontSize',20,'FontName','Tahoma');
            ylabel(para_nom(j),'FontSize',20,'FontName','Tahoma');

    %         hold on
    %         plot(X(i,:), X(j,:),'.b','MarkerSize',20)
    
            hold off
            filename = strcat('/plots/41cumod',num2str(mymodel),num2str(n-2),'noise', num2str(noisemag*100));
            saveas(figure(h),[pwd strcat(filename, '.fig')])
            saveas(figure(h),[pwd strcat(filename, '.pdf')])
            n = n + 1;
        end
    end

end