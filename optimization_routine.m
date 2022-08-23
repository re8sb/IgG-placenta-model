%% Optimization routine using genetic algorithm.
clc; close all
parameter_setup;

nParm = 5; 
lb = zeros(1,nParm); ub = ones(1,nParm); 
A = -eye(nParm); b = zeros(nParm,1);
tspan = [0 40];
pSize = 100; %population size
% LHS MATRIX %
k_up_LHS = LHS_Call(1e-3, p.k_up, 1, 1e-1 ,pSize,'unif',1e2); 
k_deg_LHS = LHS_Call(1e-3, p.k_deg, 1, 1e-1,pSize,'unif',1e2); 
k_t_LHS = LHS_Call(1e-3, p.k_t, 1, 1e-1, pSize,'unif',1e2); 
fcrn_LHS = LHS_Call(1e-6, p.fcrn, 1e-3,1e-1, pSize,'unif',1e2); 
fcgr2b_LHS = LHS_Call(1e-6, p.fcgr2b, 1e-3,1e-1, pSize,'unif',1e2); 

LHS_matrix = [k_up_LHS k_deg_LHS k_t_LHS fcrn_LHS fcgr2b_LHS];

%data from Malek 1996 to fit model
tdata = [19.5,25,30,34.5,39]';
xCB.x1 = [0.93,2.12,3.7,5.65,10.43]/p.mass_igg; xCB.x2 = [0.31,0.74,0.93,1.19,1.56]/p.mass_igg;
xCB.x3 = [0.05,0.15,0.19,0.26,0.41]/(p.mass_igg+2e4); xCB.x4 = [0.04,0.13,0.21,0.25,0.47]/p.mass_igg;
data_f = [xCB.x1;xCB.x2;xCB.x3;xCB.x4];

options = optimoptions(@ga,'InitialPopulationMatrix',LHS_matrix,'Generations',100,'PopulationSize',pSize);

tic
[parms_opt,error_opt] = ga(@(parms) error_opt_subclass(parms,x0,data_f,tdata,p,tspan),...
    nParm,A,b,[],[],lb,ub,[],options);
toc