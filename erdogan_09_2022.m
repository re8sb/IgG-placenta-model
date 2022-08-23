%% full manuscript analysis
clear; close all; clc
ColorOrder = [140,43,219;24,214,219;29,145,64;201,108,214]/255;
addpath(genpath('C:\Users\re8sb\Box\Remziye Erdogan share\Data and Analysis\MATLAB scripts\general scripts'))
addpath(genpath('C:\Users\re8sb\Box\Dolatshahi Lab Share\Code Share'))
addpath(genpath('C:\Users\re8sb\Box\Data and Analysis\Teichmann sc mat-fet interface'))
addpath(genpath('C:\Users\re8sb\Box\Data and Analysis\Tsang et al scRNAseq placenta'))
addpath(genpath('C:\Users\re8sb\Box\Data and Analysis\ELGAN'))

%% Figure 1 analysis. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fig 1B-C.
Model_LHS
%% Figure 2 analysis. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fig 2A. (ELGAN data)
elgan_data_analysis_fcgr
%% Fig 2B. (Tsang data)
tsang_data_analysis_fcgr
%% Fig 2C. (Vento-Tormo data)
vento_tormo_data_analysis_fcgr
%% Fig 2D.
% plot with varying FcRn. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layer = 'endo'; parameter_setup_main_fcrn_endo;
p.fcrn =1.6e-5; p.fcgr2b =1.6e-5;
p.k_d_fcgr2b = k_d_fcrn; p.k_d_fcrn = k_d_fcrn;

x0_syn = [p.fcrn;zeros(8,1)];
x0_endo = [p.fcgr2b;zeros(8,1)];
tspan = [10 40];

fcrn = logspace(-7,-4,30); 
clear ratio; 
for i = 1:length(fcrn)
    p.fcgr2b = fcrn(i);
    x0_endo = [p.fcgr2b;zeros(8,1)];
    sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
%         sol = ode15s(@(t,x) dx_dt_trans_comp1121(t,x,p), tspan, x0);
    ratio(:,i) = sol.y(17:20,end)./sol.y(1:4,end);
    i
end

figure; subplot(1,2,1)
semilogx(fcrn,ratio(1,:),'-','color',ColorOrder(1,:),'linewidth',2); hold on
semilogx(fcrn,ratio(2,:),'-','color',ColorOrder(2,:),'linewidth',2); 
semilogx(fcrn,ratio(3,:),'-','color',ColorOrder(3,:),'linewidth',2); 
semilogx(fcrn,ratio(4,:),'-','color',ColorOrder(4,:),'linewidth',2);
ylabel('Transfer Ratio')
xlabel('FcRn_{EC} (M)')
legend('IgG1','IgG2','IgG3','IgG4','location','best')

% plot with varying FcgRIIb. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layer = 'endo'; parameter_setup_main;%parameter_setup_main;
p.fcrn =1.6e-5; p.fcgr2b =1.6e-5;
p.k_d_fcgr2b = k_d_fcgr2b; p.k_d_fcrn = k_d_fcrn;

x0_syn = [p.fcrn;zeros(8,1)];
x0_endo = [p.fcgr2b;zeros(8,1)];

fcgr2b = logspace(-7,-4,30); 

clear ratio; 
for i = 1:length(fcgr2b)
    p.fcgr2b = fcgr2b(i);
    x0_endo = [p.fcgr2b;zeros(8,1)];
    sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
    ratio(:,i) = sol.y(17:20,end)./sol.y(1:4,end);
    i
end

subplot(1,2,2)
semilogx(fcgr2b,ratio(1,:),'-','color',ColorOrder(1,:),'linewidth',2); hold on
semilogx(fcgr2b,ratio(2,:),'-','color',ColorOrder(2,:),'linewidth',2); 
semilogx(fcgr2b,ratio(3,:),'-','color',ColorOrder(3,:),'linewidth',2); 
semilogx(fcgr2b,ratio(4,:),'-','color',ColorOrder(4,:),'linewidth',2);
ylabel('Transfer Ratio')
xlabel('Fc\gammaRIIb_{EC} (M)')
legend('IgG1','IgG2','IgG3','IgG4','location','best')
% parameter_setup_main; xline(p.fcgr2b,'k--','handlevisibility','off')

%% Fig 2F.
parameter_setup_transwell_2_fcr;
FcR20 = [0 1e-7];
kon1 = [5.4e5 3.3e5 2.02e5 1.35e5];
koff1 = [0.0068 0.0068 0.0068 0.0068];
kon2 = [5.4e5 9e4 7.65e5 9e5];
koff2 = [4.5 4.5 4.5 4.5];

for j = 1:4
    p.kon1 = kon1(j); p.koff1 = koff1(j); p.kon2 = kon2(j); p.koff2 = koff2(j);
    for i = 1:length(FcR20)
        x0(3) = FcR20(i);
        sol = ode23s(@(t,x) dx_dt_transwell_2_fcr(t,x,p,x0), tspan, x0);
        igg1t(i,:,j) = sol.y(end,:)*1e9;    
    end
end

figure; ax = gca;
semilogx(sol.x/60,igg1t(2,:,1),'color',ColorOrder(1,:),'linewidth',2); hold on
semilogx(sol.x/60,igg1t(2,:,2),'color',ColorOrder(2,:),'linewidth',2); 
semilogx(sol.x/60,igg1t(2,:,3),'color',ColorOrder(3,:),'linewidth',2); 
semilogx(sol.x/60,igg1t(2,:,4),'color',ColorOrder(4,:),'linewidth',2);
semilogx(sol.x/60,igg1t(1,:,1),'--','color',ColorOrder(1,:),'linewidth',2); hold on
semilogx(sol.x/60,igg1t(1,:,2),'--','color',ColorOrder(2,:),'linewidth',2,'HandleVisibility','off'); 
semilogx(sol.x/60,igg1t(1,:,3),'--','color',ColorOrder(3,:),'linewidth',2,'HandleVisibility','off'); 
semilogx(sol.x/60,igg1t(1,:,4),'--','color',ColorOrder(4,:),'linewidth',2,'HandleVisibility','off'); 
xlabel('Time (hr)'); xticks([0:6]); xticklabels({'0','1','2','3','4','5','6'})
legend('IgG1 (FcRn + Fc\gammaRIIb)','IgG2','IgG3','IgG4','FcRn only','location','eastoutside'); ylabel('Transcytosed IgG (nM)')
ax.FontSize = 14; title('IgG EC transcytosis')

%% Figure 3 analysis. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Fig 3A. - effect of subclass mixing in physiological model.
layer='syn';parameter_setup_main; p.fcrn =1.6e-5; p.fcgr2b =7e-6;
tspan = [10 40];
x0 = [p.igg1,0,0,0,zeros(1,16)];
sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
igg1_ratio = sol.y(17,end)/sol.y(1,end);

x0 = [0,p.igg2,0,0,zeros(1,16)];
sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
igg2_ratio = sol.y(18,end)/sol.y(2,end);

x0 = [0,0,p.igg3,0,zeros(1,16)];
sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
igg3_ratio = sol.y(19,end)/sol.y(3,end);

x0 = [0,0,0,p.igg4,zeros(1,16)];
sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
igg4_ratio = sol.y(20,end)/sol.y(4,end);

x0 = [p.igg1,p.igg2,p.igg3,p.igg4,zeros(1,16)];
sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
igg1_ratio_comp = sol.y(17,end)/sol.y(1,end);
igg2_ratio_comp = sol.y(18,end)/sol.y(2,end);
igg3_ratio_comp = sol.y(19,end)/sol.y(3,end);
igg4_ratio_comp = sol.y(20,end)/sol.y(4,end);

figure; ax = gca;
bar([igg1_ratio igg1_ratio_comp; igg2_ratio igg2_ratio_comp;...
    igg3_ratio igg3_ratio_comp; igg4_ratio igg4_ratio_comp])
ylabel('Transfer Ratio'); xticklabels({'IgG1','IgG2','IgG3','IgG4'})
legend('Isolation','Competition','location','eastoutside'); ax.FontSize = 14;
hold on; yline(1,'--','handlevisibility','off')

[igg1_ratio igg1_ratio_comp; igg2_ratio igg2_ratio_comp;...
    igg3_ratio igg3_ratio_comp; igg4_ratio igg4_ratio_comp]

% sol.y(9,15) + sol.y(10,15) + sol.y(11,15) + sol.y(12,15)
% sol.y(12,15)/sol.y(9,15)

%% Fig 3A. Alternate.
layer='syn';parameter_setup_main; p.fcrn =1.6e-5; %p.fcgr2b =1.6e-6;
tspan = [10 40];

x0_syn = [p.fcrn;zeros(8,1)];
x0_endo = [p.fcgr2b;zeros(8,1)];

fcgr2b = logspace(-7,-4,30); 

for i = 1:length(fcgr2b)
    p.fcgr2b = fcgr2b(i);
    x0_endo = [p.fcgr2b;zeros(8,1)];

    x0 = [p.igg1,0,0,0,zeros(1,16)];
    sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
    igg1_ratio(i) = sol.y(17,end)/sol.y(1,end);
    
    x0 = [0,p.igg2,0,0,zeros(1,16)];
    sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
    igg2_ratio(i) = sol.y(18,end)/sol.y(2,end);
    
    x0 = [0,0,p.igg3,0,zeros(1,16)];
    sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
    igg3_ratio(i) = sol.y(19,end)/sol.y(3,end);
    
    x0 = [0,0,0,p.igg4,zeros(1,16)];
    sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
    igg4_ratio(i) = sol.y(20,end)/sol.y(4,end);
    
    x0 = [p.igg1,p.igg2,p.igg3,p.igg4,zeros(1,16)];
    sol = ode15s(@(t,x) dx_dt_trans_comp(t,x,p), tspan, x0);
    igg1_ratio_comp(i) = sol.y(17,end)/sol.y(1,end);
    igg2_ratio_comp(i) = sol.y(18,end)/sol.y(2,end);
    igg3_ratio_comp(i) = sol.y(19,end)/sol.y(3,end);
    igg4_ratio_comp(i) = sol.y(20,end)/sol.y(4,end);

    i
end

figure
semilogx(fcgr2b,igg1_ratio,'--','color',ColorOrder(1,:),'linewidth',2); hold on
semilogx(fcgr2b,igg2_ratio,'--','color',ColorOrder(2,:),'linewidth',2); 
semilogx(fcgr2b,igg3_ratio,'--','color',ColorOrder(3,:),'linewidth',2); 
semilogx(fcgr2b,igg4_ratio,'--','color',ColorOrder(4,:),'linewidth',2);
semilogx(fcgr2b,igg1_ratio_comp,'-','color',ColorOrder(1,:),'linewidth',2); 
semilogx(fcgr2b,igg2_ratio_comp,'-','color',ColorOrder(2,:),'linewidth',2); 
semilogx(fcgr2b,igg3_ratio_comp,'-','color',ColorOrder(3,:),'linewidth',2); 
semilogx(fcgr2b,igg4_ratio_comp,'-','color',ColorOrder(4,:),'linewidth',2);
ylabel('Transfer Ratio')
xlabel('Fc\gammaRIIb_{EC} (M)')
legend('IgG1','IgG2','IgG3','IgG4','location','best')

% sol.y(9,15) + sol.y(10,15) + sol.y(11,15) + sol.y(12,15)
% sol.y(12,15)/sol.y(9,15)
%% Fig 3C. - in silico competition experiment compared to experimental data.
clear
parameter_setup_transwell_2_igg
tspan = [0,6*60];
% import experimental data
load('06012022processed.mat')

% parameter_setup
IgG = logspace(-7,-5,25);
KD = logspace(-7,-9,25);

for i = 1:length(IgG)
    x0(2) = IgG(i);
    for j = 1:length(IgG)
        p.koff2 = KD(j)*p.kon2; p.kd2 = KD(j);
        sol = ode23s(@(t,x) dx_dt_transwell_2_igg(t,x,p,x0), tspan, x0);
        V1max(i,j) = max(p.kT*x0(3)*sol.y(1,:)./(p.kd1*(1 + (sol.y(1,:)/p.kd1) + (sol.y(2,:)/p.kd2))))*1e12; %maximum transcytosis rate, nM/min
        igg1t(i,j) = sol.y(4,end)*1e12; igg2t(i,j) = sol.y(5,end)*1e12;
    end
end

figure; subplot(1,2,1)
contourf(log(IgG./x0(1)),log(KD./p.kd1),V1max,'linestyle','none')
ylabel('log(K_{D4}/K_{D1})'); xlabel('log(IgG4_{0}/IgG1_{0})')
c = colorbar('northoutside'); c.Label.String = 'V1_{max} (pM/min)';
subplot(1,2,2)
contourf(log(IgG./x0(1)),log(KD./p.kd1),igg1t,'linestyle','none')
ylabel('log(K_{D4}/K_{D1})'); xlabel('log(IgG4_{0}/IgG1_{0})')
c = colorbar('northoutside'); c.Label.String = 'IgG1_{trans} (pM)'; colormap(copper)

%% Fig 3D.
figure; ax = gca;
expratio = log([0.1,1.25/3.75,2.5/2.5,3.75/1.25,6]);
plot(log(IgG./x0(1)),igg1t(:,5)/1e1,'color',ColorOrder(1,:),'linewidth',2); hold on
plot(log(IgG./x0(1)),igg2t(:,5)/1e1,'color',ColorOrder(4,:),'linewidth',2)
errorbar(expratio,igg1Mean,[igg1SD 0],'k','handlevisibility','off','linestyle','none');
errorbar(expratio,igg4Mean,[0 igg4SD],'k','handlevisibility','off','linestyle','none')
plot(expratio,igg1Mean,'o','markerfacecolor',ColorOrder(1,:),'markeredgecolor','k','color','k')
plot(expratio,igg4Mean,'o','markerfacecolor',ColorOrder(4,:),'markeredgecolor','k','color','k')
xlabel('log(IgG4_0/IgG1_0)')
ylabel('Total IgG transcytosis (ng/ml)')
ax.FontSize = 14; legend('IgG1','IgG4')

%% Figure 4 analysis. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fig 4A-B.

igg_subclass_estimation;
%% Fig 4C.
load('preterm_term_subclass_est_081222.mat')
parameter_setup_vax
time_points = linspace(10,40); tspan = [10 40];
sol = ode15s(@(t,x) dx_dt_vax(t,x,p), tspan, x0);

clear fraction igg1vax_fetal igg2vax_fetal igg3vax_fetal igg4vax_fetal datplot ...
    igg1vax igg2vax igg3vax igg4vax
fraction = linspace(0,1,21); 

for i = 1:length(fraction)
    parameter_setup_vax;
    other_frac(i) = (1-fraction(i))/3;

    p.igg1vax = fraction(i)*p.igg1vax; igg1vax(i) = p.igg1vax;
    p.igg2vax = other_frac(i)*p.igg2vax; igg2vax(i) = p.igg2vax;
    p.igg3vax = other_frac(i)*p.igg3vax; igg3vax(i) = p.igg3vax;
    p.igg4vax = other_frac(i)*p.igg4vax; igg4vax(i) = p.igg4vax;

    x0(21:24) = [p.igg1vax,p.igg2vax,p.igg3vax,p.igg4vax];
    sol = ode15s(@(t,x) dx_dt_vax(t,x,p), tspan, x0);
    igg1vax_fetal(i) = (sol.y(37,end)/p.igg1vax);
    igg2vax_fetal(i) = (sol.y(38,end)/p.igg2vax);
    igg3vax_fetal(i) = (sol.y(39,end)/p.igg3vax);
    igg4vax_fetal(i) = (sol.y(40,end)/p.igg4vax);
    
end

figure;
plot(fraction*100,log2(igg1vax_fetal),'linewidth',2,'color',ColorOrder(1,:)); hold on
plot(fraction*100,log2(igg2vax_fetal),'linewidth',2,'color',ColorOrder(2,:)); 
plot(fraction*100,log2(igg3vax_fetal),'linewidth',2,'color',ColorOrder(3,:)); 
plot(fraction*100,log2(igg4vax_fetal),'linewidth',2,'color',ColorOrder(4,:)); 
ylabel('IgG Transfer Ratio'); xlabel('Proportion of Ag-specific pool (%)')

figure;
subplot(2,2,1)
plot(fraction*100,log2(igg1vax_fetal),'linewidth',2,'color',ColorOrder(1,:)); hold on
scatter(frac.mom.igg1*100,log2(ratio.igg1(:,goodagidx)),50,'.','markeredgecolor',ColorOrder(1,:)); hold on
xlim([0 100]); xlabel('Mat. Subclass Abundance (%)'); ylabel('Log2(Ratio)'); legend('IgG1')
subplot(2,2,2)
plot(fraction*100,log2(igg2vax_fetal),'linewidth',2,'color',ColorOrder(2,:)); hold on
scatter(frac.mom.igg2*100,log2(ratio.igg2(:,goodagidx)),50,'.','markeredgecolor',ColorOrder(2,:)); hold on
xlim([0 100]); xlabel('Mat. Subclass Abundance (%)'); ylabel('Log2(Ratio)'); legend('IgG2')
subplot(2,2,3)
plot(fraction*100,log2(igg3vax_fetal),'linewidth',2,'color',ColorOrder(3,:)); hold on
scatter(frac.mom.igg3*100,log2(ratio.igg3(:,goodagidx)),50,'.','markeredgecolor',ColorOrder(3,:)); hold on
xlim([0 100]); xlabel('Mat. Subclass Abundance (%)'); ylabel('Log2(Ratio)'); legend('IgG3')
subplot(2,2,4)
plot(fraction*100,log2(igg4vax_fetal),'linewidth',2,'color',ColorOrder(4,:)); hold on
scatter(frac.mom.igg4*100,log2(ratio.igg4(:,goodagidx)),50,'.','markeredgecolor',ColorOrder(4,:)); hold on
xlim([0 100]); xlabel('Mat. Subclass Abundance (%)'); ylabel('Log2(Ratio)'); legend('IgG4')

%% Supplemental figures. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%