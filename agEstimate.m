function agEstimate(baby,mom,Rsq_thresh,ag)
% This function takes antigen-specific luminex antibody measurements and
% estimates the ag-specific isotype proportions using a least squares
% approximation.
% Plots generate strive to answer the question:  Are over-abundant antibody
% isotypes transfered more efficiently?

%Inputs:
%ag = list of antigen-specificities
%baby = data structure of cord blood samples
%mom = data structure of mom data

addpath(genpath('C:\Users\remzi\Box\Dolatshahi Lab Share\Code Share'))
addpath(genpath('C:\Users\remzi\Box\Remziye Erdogan share\Data and Analysis\MATLAB scripts\general scripts'))

%concatenate maternal and cord blood data
allsamples.totigg = [mom.totigg;baby.totigg];
allsamples.igg1 = [mom.igg1;baby.igg1];
allsamples.igg2 = [mom.igg2;baby.igg2];
allsamples.igg3 = [mom.igg3;baby.igg3];
allsamples.igg4 = [mom.igg4;baby.igg4];

ratio.total = baby.totigg./mom.totigg; ratio.total(isinf(ratio.total)|isnan(ratio.total))=0;
ratio.igg1 = baby.igg1./mom.igg1; ratio.igg1(isinf(ratio.igg1)|isnan(ratio.igg1))=0;
ratio.igg2 = baby.igg2./mom.igg2; ratio.igg2(isinf(ratio.igg2)|isnan(ratio.igg2))=0;
ratio.igg3 = baby.igg3./mom.igg3; ratio.igg3(isinf(ratio.igg3)|isnan(ratio.igg3))=0;
ratio.igg4 = baby.igg4./mom.igg4; ratio.igg4(isinf(ratio.igg4)|isnan(ratio.igg4))=0;

ratio.combined = [median(ratio.igg1,'omitnan')' median(ratio.igg2,'omitnan')'...
    median(ratio.igg3,'omitnan')' median(ratio.igg4,'omitnan')' median(ratio.total,'omitnan')'];

%% build LSQ model
%% add a constraint that alpha > 0 
fun = @(x,A) A*x; lb = [0 0 0 0]'; x0 = [1 1 1 1]';
figure(1); 
lsqopts.FunctionTolerance=1e-10;
lsqopts.Diagnostic='on';
close all
b = zeros(length(allsamples.igg1(:,1)),1);
%loop through antigens
for j = 1:length(ag)
    clear Atrain Atest A b b_fit
    b_fit = zeros(1,length(allsamples.igg1(:,1))); 
%input data for linear model
    A = [allsamples.igg1(:,j) allsamples.igg2(:,j) allsamples.igg3(:,j) allsamples.igg4(:,j)];
    b = allsamples.totigg(:,j); %output - estimating total Igg
%estimate alphas        
    alpha_all(:,j) = lsqcurvefit(fun,x0,A,b,lb,[],lsqopts);
%predict total IgG given alphas
    b_fit = (A*alpha_all(:,j));
% compute correlation coefficient and R^2
    [rho,p] = corrcoef([b_fit b]); rho_sq = rho.*rho; R_sq(j) = rho_sq(1,2);
    figure(1); subplot(4,6,j)
    %subplot(ceil(length(ag)/2),floor(length(ag)/2),j)
    plot(linspace(0,max(b)),linspace(0,max(b)),'b-','handlevisibility','off','linewidth',1.5); hold on
    plot(b(1:17),b_fit(1:17),'kx','linewidth',1.5); plot(b(18:end),b_fit(18:end),'ko','linewidth',1.5);
    xlabel('Total IgG'); ylabel('Total IgG (fit)')
    title(append(string(ag(j)),':  R^2 = ',string(round(10^2*R_sq(j))/10^2))); %lsline;
    pval(j) = p(1,2);
    stdev(j) = std(b_fit);
end

legend('Maternal','Cord')
% goodagidx = [2,4,5:9,12:19,21:24];

[~,~,goodagidx] = intersect(ag(R_sq>Rsq_thresh),ag);
goodag = ag(goodagidx);
% goodag = ag;
% goodagidx = 1:24;
%% estimation of subclass proportions and transfer ratios given alpha
frac.mom.igg1 = alpha_all(1,goodagidx).*mom.igg1(:,goodagidx)./mom.totigg(:,goodagidx);
frac.mom.igg2 = alpha_all(2,goodagidx).*mom.igg2(:,goodagidx)./mom.totigg(:,goodagidx);
frac.mom.igg3 = alpha_all(3,goodagidx).*mom.igg3(:,goodagidx)./mom.totigg(:,goodagidx);
frac.mom.igg4 = alpha_all(4,goodagidx).*mom.igg4(:,goodagidx)./mom.totigg(:,goodagidx);
% 
frac.baby.igg1 = alpha_all(1,goodagidx).*baby.igg1(:,goodagidx)./baby.totigg(:,goodagidx);
frac.baby.igg2 = alpha_all(2,goodagidx).*baby.igg2(:,goodagidx)./baby.totigg(:,goodagidx);
frac.baby.igg3 = alpha_all(3,goodagidx).*baby.igg3(:,goodagidx)./baby.totigg(:,goodagidx);
frac.baby.igg4 = alpha_all(4,goodagidx).*baby.igg4(:,goodagidx)./baby.totigg(:,goodagidx);

%% bar plots
frac.mom.combined = [median(frac.mom.igg1,'omitnan')' median(frac.mom.igg2,'omitnan')'...
    median(frac.mom.igg3,'omitnan')' median(frac.mom.igg4,'omitnan')'];

frac.baby.combined = [median(frac.baby.igg1,'omitnan')' median(frac.baby.igg2,'omitnan')'...
    median(frac.baby.igg3,'omitnan')' median(frac.baby.igg4,'omitnan')'];

for i = 1:height(frac.baby.combined)
 frac.baby.combined(i,:) = frac.baby.combined(i,:) / sum(frac.baby.combined(i,:));
end

for i = 1:height(frac.mom.combined)
 frac.mom.combined(i,:) = frac.mom.combined(i,:) / sum(frac.mom.combined(i,:));
end

frac.ratio = frac.baby.combined./frac.mom.combined;

figure(2); %subplot(2,1,1)
b = bar(frac.mom.combined,'stacked','facecolor','flat')
b(1).CData = [0.5 0.11 0.8];b(2).CData =  [0.22 0.81 0.90];
b(3).CData = [0.086 0.6 0.086];b(4).CData =  [0.82 0.427 0.82];
ylim([0 1.25]); legend('IgG1','IgG2','IgG3','IgG4','location','eastoutside'); ylabel('Estimated Proportion')
xticks([1:length(goodag)]); xticklabels(goodag); xtickangle(45); title('Maternal IgG Subclasses')
% subplot(2,1,2)
% b = bar(frac.baby.combined,'stacked','facecolor','flat')
% b(1).CData = [0.5 0.11 0.8]; b(2).CData =  [0.22 0.81 0.90];
% b(3).CData = [0.086 0.6 0.086]; b(4).CData =  [0.82 0.427 0.82];
% ylim([0 1.25]); legend('IgG1','IgG2','IgG3','IgG4','location','eastoutside'); ylabel('Estimated Proportion')
% xticks([1:length(goodag)]); xticklabels(goodag); xtickangle(45); title('Cord IgG Subclasses')

%% plot the log2 transformed transfer ratios as violin plots (goodagidx)
log2ratio.igg1 = log2(baby.igg1(:,goodagidx)./mom.igg1(:,goodagidx)); log2ratio.igg1(isinf(log2ratio.igg1)|isnan(log2ratio.igg1))=0;
log2ratio.igg2 = log2(baby.igg2(:,goodagidx)./mom.igg2(:,goodagidx)); log2ratio.igg2(isinf(log2ratio.igg2)|isnan(log2ratio.igg2))=0;
log2ratio.igg3 = log2(baby.igg3(:,goodagidx)./mom.igg3(:,goodagidx)); log2ratio.igg3(isinf(log2ratio.igg3)|isnan(log2ratio.igg3))=0;
log2ratio.igg4 = log2(baby.igg4(:,goodagidx)./mom.igg4(:,goodagidx)); log2ratio.igg4(isinf(log2ratio.igg4)|isnan(log2ratio.igg4))=0;

figure(3); 
Mycolor = [0.5 0.11 0.8;0.22 0.81 0.90;0.086 0.6 0.086;0.82 0.427 0.82]';
for n = 1:length(goodagidx)
subplot(length(goodag)/2,2,n) 
vs = violinplot_SD([log2ratio.igg1(:,n) log2ratio.igg2(:,n) log2ratio.igg3(:,n) log2ratio.igg4(:,n)],...
    goodag,'ViolinColor',Mycolor'); 
hold on; yline(0,'--'); ylabel('Log_2(Transfer Ratio)'); ylim([-3 3]); xlim([0 5])
title(goodag(n))
end

%% plot transfer ratios for all ag, all patients , per subclass
%% HERE
figure(4)

subplot(2,2,1)
scatter(frac.mom.igg1,ratio.igg1(:,goodagidx),'.','markeredgecolor',[0.5 0.11 0.8]); hold on
subplot(2,2,2)
scatter(frac.mom.igg2,ratio.igg2(:,goodagidx),'.','markeredgecolor',[0.22 0.81 0.90])
subplot(2,2,3)
scatter(frac.mom.igg3,ratio.igg3(:,goodagidx),'.','markeredgecolor',[0.086 0.6 0.086])
subplot(2,2,4)
scatter(frac.mom.igg4,ratio.igg4(:,goodagidx),'.','markeredgecolor',[0.82 0.427 0.82])

%% plot estimated maternal subclass proportion vs. estimated transfer ratio
figure(5)

for i = 1:length(goodag)
% subplot(ceil(length(goodag)/2),floor(length(goodag)/2),i)
subplot(length(goodag)/2,2,i)
scatter(frac.mom.igg1(:,i)*100,ratio.igg1(:,i),'.','markeredgecolor',[0.5 0.11 0.8]); hold on
scatter(frac.mom.igg2(:,i)*100,ratio.igg2(:,i),'.','markeredgecolor',[0.22 0.81 0.90]);
scatter(frac.mom.igg3(:,i)*100,ratio.igg3(:,i),'.','markeredgecolor', [0.086 0.6 0.086]);
scatter(frac.mom.igg4(:,i)*100,ratio.igg4(:,i),'.','markeredgecolor',[0.82 0.427 0.82]);
% p= polyfit([frac.mom.igg1(:,i); frac.mom.igg2(:,i); frac.mom.igg3(:,i); frac.mom.igg4(:,i)],...
%     [ratio.igg1(:,i); ratio.igg2(:,i); ratio.igg3(:,i); ratio.igg4(:,i)],1);
% line(linspace(0,100),linspace(0,100)*p(1)+p(2),'color','k','handlevisibility','off')
% p= polyfit(frac.mom.igg1(:,i)*100,ratio.igg1(:,i),1);
% line(linspace(0,100),linspace(0,100)*p(1)+p(2),'color',[0.5 0.11 0.8],'handlevisibility','off'); hold on
% p= polyfit(frac.mom.igg2(:,i)*100,ratio.igg2(:,i),1);
% line(linspace(0,100),linspace(0,100)*p(1)+p(2),'color',[0.22 0.81 0.90],'handlevisibility','off'); hold on
% p= polyfit(frac.mom.igg3(:,i)*100,ratio.igg3(:,i),1);
% line(linspace(0,100),linspace(0,100)*p(1)+p(2),'color',[0.086 0.6 0.086],'handlevisibility','off'); hold on
% p= polyfit(frac.mom.igg4(:,i)*100,ratio.igg4(:,i),1);
% line(linspace(0,100),linspace(0,100)*p(1)+p(2),'color','k','handlevisibility','off'); hold on
% scatter(frac.mom.combined(i,1)*100,median(ratio.igg1(:,i)),50,'o','markerfacecolor',[0.5 0.11 0.8],'markeredgecolor','k'); 
% scatter(frac.mom.combined(i,2)*100,median(ratio.igg2(:,i)),50,'o','markerfacecolor',[0.22 0.81 0.90],'markeredgecolor','k');
% scatter(frac.mom.combined(i,3)*100,median(ratio.igg3(:,i)),50,'o','markerfacecolor',[0.086 0.6 0.086],'markeredgecolor','k');
% scatter(frac.mom.combined(i,4)*100,median(ratio.igg4(:,i)),50,'o','markerfacecolor',[0.82 0.427 0.82],'markeredgecolor','k');
% xticks([25:25:100])
ylabel('Transfer ratio'); xlabel('Estimated Maternal Abundance (%)'); title(goodag(i)); ylim([0 5]); xlim([0 100])
[rho,p] = corrcoef([frac.mom.igg1(:,i); frac.mom.igg2(:,i); frac.mom.igg3(:,i); frac.mom.igg4(:,i)],...
    [ratio.igg1(:,i); ratio.igg2(:,i); ratio.igg3(:,i); ratio.igg4(:,i)]); rho_sq = rho.*rho; R_sq(j) = rho_sq(1,2);
title(append(string(goodag(i)),':  R^2 = ',string(round(10^2*R_sq(j))/10^2))); %lsline;
end
% legend('IgG1','IgG2','IgG3','IgG4')

%% plot estimated maternal subclass proportion vs. estimated cord subclass proportion
figure(5)
for i = 1:length(goodag)
% subplot(ceil(length(goodag)/2),floor(length(goodag)/2),i)
subplot(length(goodag)/2,2,i)
scatter(frac.mom.igg1(:,i)*100,frac.baby.igg1(:,i)*100,'.','markeredgecolor',[0.5 0.11 0.8]); hold on
scatter(frac.mom.igg2(:,i)*100,frac.baby.igg2(:,i)*100,'.','markeredgecolor',[0.22 0.81 0.90]);
scatter(frac.mom.igg3(:,i)*100,frac.baby.igg3(:,i)*100,'.','markeredgecolor', [0.086 0.6 0.086]);
scatter(frac.mom.igg4(:,i)*100,frac.baby.igg4(:,i)*100,'.','markeredgecolor',[0.82 0.427 0.82]);
% p = polyfit(frac.mom.combined(i,:)*100,frac.baby.combined(i,:)*100,1);
% line(linspace(0,100),linspace(0,100)*p(1)+p(2),'color','k','handlevisibility','off'); hold on
line(linspace(0,100),linspace(0,100),'color',[0.5 0.5 0.5],'linestyle',':','handlevisibility','off'); hold on

scatter(frac.mom.combined(i,1)*100,frac.baby.combined(i,1)*100,50,'o','markerfacecolor',[0.5 0.11 0.8],'markeredgecolor','k'); 
scatter(frac.mom.combined(i,2)*100,frac.baby.combined(i,2)*100,50,'o','markerfacecolor',[0.22 0.81 0.90],'markeredgecolor','k');
scatter(frac.mom.combined(i,3)*100,frac.baby.combined(i,3)*100,50,'o','markerfacecolor',[0.086 0.6 0.086],'markeredgecolor','k');
scatter(frac.mom.combined(i,4)*100,frac.baby.combined(i,4)*100,50,'o','markerfacecolor',[0.82 0.427 0.82],'markeredgecolor','k');
% xticks([25:25:100])
ylabel('Estimated Cord Abundance (%)'); xlabel('Estimated Maternal Abundance (%)'); title(goodag(i)); ylim([0 100]); xlim([0 100])
xticks([0 50 100]); yticks([0 50 100])
% [rho,p] = corrcoef(frac.mom.combined(i,:)*100,frac.baby.combined(i,:)*100); rho_sq = rho.*rho; R_sq(j) = rho_sq(1,2);
[rho,p] = corrcoef([frac.mom.igg1(:,i)*100; frac.mom.igg2(:,i)*100; frac.mom.igg3(:,i)*100; frac.mom.igg4(:,i)*100]...
    ,[frac.baby.igg1(:,i)*100; frac.baby.igg2(:,i)*100; frac.baby.igg3(:,i)*100; frac.baby.igg4(:,i)*100]); 
rho_sq = rho.*rho; R_sq(j) = rho_sq(1,2);
title(append(string(goodag(i)),':  R^2 = ',string(round(10^2*R_sq(j))/10^2))); %lsline;
end
legend('IgG1','IgG2','IgG3','IgG4')

% %% plot the log2 transformed transfer ratios as violin plots (goodagidx)
% log2ratio.igg1 = log2(baby.igg1(:,goodagidx)./mom.igg1(:,goodagidx)); log2ratio.igg1(isinf(log2ratio.igg1)|isnan(log2ratio.igg1))=0;
% log2ratio.igg2 = log2(baby.igg2(:,goodagidx)./mom.igg2(:,goodagidx)); log2ratio.igg2(isinf(log2ratio.igg2)|isnan(log2ratio.igg2))=0;
% log2ratio.igg3 = log2(baby.igg3(:,goodagidx)./mom.igg3(:,goodagidx)); log2ratio.igg3(isinf(log2ratio.igg3)|isnan(log2ratio.igg3))=0;
% log2ratio.igg4 = log2(baby.igg4(:,goodagidx)./mom.igg4(:,goodagidx)); log2ratio.igg4(isinf(log2ratio.igg4)|isnan(log2ratio.igg4))=0;
% 
% figure(3); subplot(2,2,1); Mycolor = [0.5 0.11 0.8];
% Color = repmat(Mycolor',1,length(goodag));
% vs = violinplot_SD(log2ratio.igg1,goodag,'ViolinColor',Color'); xtickangle(45)
% hold on; yline(0,'--'); ylabel('Log_2(Transfer Ratio)'); ylim([-3 3]); xlim([0 length(goodag)+1])
% subplot(2,2,2); Mycolor = [0.22 0.81 0.90];
% Color = repmat(Mycolor',1,length(goodag));
% vs = violinplot_SD(log2ratio.igg2,goodag,'ViolinColor',Color'); xtickangle(45)
% hold on; yline(0,'--'); ylabel('Log_2(Transfer Ratio)'); ylim([-3 3]); xlim([0 length(goodag)+1])
% subplot(2,2,3); Mycolor = [0.086 0.6 0.086];
% Color = repmat(Mycolor',1,length(goodag));
% vs = violinplot_SD(log2ratio.igg3,goodag,'ViolinColor',Color'); xtickangle(45)
% hold on; yline(0,'--'); ylabel('Log_2(Transfer Ratio)'); ylim([-3 3]); xlim([0 length(goodag)+1])
% subplot(2,2,4); Mycolor =  [0.82 0.427 0.82];
% Color = repmat(Mycolor',1,length(goodag));
% vs = violinplot_SD(log2ratio.igg4,goodag,'ViolinColor',Color'); xtickangle(45)
% hold on; yline(0,'--'); ylabel('Log_2(Transfer Ratio)'); ylim([-3 3]); xlim([0 length(goodag)+1])

%% compute estimated transfer ratios, plot vs actual transfer ratios
%% this doesn't make sense because should multiply top and bottom by alpha
% ratio.estigg1 = alpha_all(1,goodagidx).*baby.igg1(:,goodagidx)./mom.igg1(:,goodagidx); ratio.estigg1(isinf(ratio.estigg1)|isnan(ratio.estigg1))=0;
% ratio.estigg2 = alpha_all(2,goodagidx).*baby.igg2(:,goodagidx)./mom.igg2(:,goodagidx); ratio.estigg2(isinf(ratio.igg2)|isnan(ratio.estigg2))=0;
% ratio.estigg3 = alpha_all(3,goodagidx).*baby.igg3(:,goodagidx)./mom.igg3(:,goodagidx); ratio.estigg3(isinf(ratio.estigg3)|isnan(ratio.estigg3))=0;
% ratio.estigg4 = alpha_all(4,goodagidx).*baby.igg4(:,goodagidx)./mom.igg4(:,goodagidx); ratio.estigg4(isinf(ratio.estigg4)|isnan(ratio.estigg4))=0;
% 
% close figure 6;figure(6)
% for i = 1:length(goodag)
%     subplot(ceil(length(goodag)/2),floor(length(goodag)/2),i)
% scatter(ratio.igg1(:,i),ratio.estigg1(:,i)); hold on
% scatter(ratio.igg2(:,i),ratio.estigg2(:,i))
% scatter(ratio.igg3(:,i),ratio.estigg3(:,i))
% scatter(ratio.igg4(:,i),ratio.estigg4(:,i))
% line(linspace(0,10),linspace(0,10),'color','k','handlevisibility','off')
% ylabel('Estimated ratio');xlabel('Ratio')
% end
%% plot averages
% [a,idx]=sort(median(frac.mom.igg1+frac.mom.igg2+frac.mom.igg3+frac.mom.igg4),2,'descend');
% 
% figure
% plot(frac.mom.igg1(:,idx)'+4,'-','color','#801CCC'); hold on; grid on; plot(median(frac.mom.igg1(:,idx))'+4,'k-','linewidth',2)
% plot(frac.mom.igg2(:,idx)'+3,'-','color','#38CEE6'); plot(median(frac.mom.igg2(:,idx))'+3,'k-','linewidth',2)
% plot(frac.mom.igg3(:,idx)'+2,'-','color','#169916'); plot(median(frac.mom.igg3(:,idx))'+2,'k-','linewidth',2)
% plot(frac.mom.igg4(:,idx)'+1,'-','color','#D16DD1'); plot(median(frac.mom.igg4(:,idx))'+1,'k-','linewidth',2)
% yticks([1:4]); yticklabels(['IgG4';'IgG3';'IgG2';'IgG1']); xtickangle(30);ylim([1 6])
% xticks([1:19]); xticklabels(goodag(idx)); title('Least squares estimate of maternal IgG subclass proportions')
% ax = gca; ax.FontSize = 14;
% 
% figure
% plot(frac.baby.igg1(:,idx)'+4,'-','color','#801CCC'); hold on; grid on; plot(median(frac.baby.igg1(:,idx))'+4,'k-','linewidth',2)
% plot(frac.baby.igg2(:,idx)'+3,'-','color','#38CEE6'); plot(median(frac.baby.igg2(:,idx))'+3,'k-','linewidth',2)
% plot(frac.baby.igg3(:,idx)'+2,'-','color','#169916'); plot(median(frac.baby.igg3(:,idx))'+2,'k-','linewidth',2)
% plot(frac.baby.igg4(:,idx)'+1,'-','color','#D16DD1'); plot(median(frac.baby.igg4(:,idx))'+1,'k-','linewidth',2)
% yticks([1:4]); yticklabels(['IgG4';'IgG3';'IgG2';'IgG1']); xtickangle(30);ylim([1 6])
% xticks([1:19]); xticklabels(goodag(idx)); title('Least squares estimate of cord blood IgG subclass proportions')
% ax = gca; ax.FontSize = 14;
% 
% figure
% plot(median(log2(ratio.igg1(:,idx)))','-o','linewidth',2,'color','#801CCC'); hold on; grid on; %plot(ratio.igg1(:,idx)'+4,'c-'); 
% plot(median(log2(ratio.igg2(:,idx)))','-o','linewidth',2,'color','#38CEE6');  %plot(ratio.igg2(:,idx)'+3,'r-'); 
% plot(median(log2(ratio.igg3(:,idx)))','-o','linewidth',2,'color','#169916'); %plot(ratio.igg3(:,idx)'+2,'g-'); 
% plot(median(log2(ratio.igg4(:,idx)))','-o','linewidth',2,'color','#D16DD1'); %plot(ratio.igg4(:,idx)'+1,'m-'); 
% ylabel('Log_2(IgG Transfer Ratio)')% yticks([1:4]); yticklabels(['IgG4';'IgG3';'IgG2';'IgG1'])
% xticks([1:19]); xticklabels(goodag(idx)); xtickangle(30); title('Least squares estimate of IgG Transfer Ratios')
% ax = gca; ax.FontSize = 14; legend('IgG1','IgG2','IgG3','IgG4')
end

