% PARAMETER BASELINE VALUES

%MY VERSION RE
%% NEW 07/25/2022
%% optimized using genetica algorithm.
% p.k_up = 7.5e-4; 
% p.k_deg = 0.03; 
% p.k_t = 0.0331; 
% p.fcrn = 5e-4; 
% p.fcgr2b = 2e-4;

p.k_up = 0.02; p.k_deg = 0.015; p.k_t = 0.01; p.fcrn =1e-4; p.fcgr2b =3e-5;
p.k_d_fcrn = 1./[8e7 5e7 3e7 2e7]; %Bruhns et al (2009)
p.k_d_fcgr2b = 1./[1.2e5,2e4,1.7e5,2e5]; %Bruhns et al (2009)
% p.k_d_fcgr2b = [3.1e-6 6.8e-6 1.3e-6 1.7e-6]; %Patel et al

p.mass_igg = 1.5e5; %molar mass of IgG (1 kDa = 1 g/mol)

PRCC_var={'k_{up}', 'k_{deg}', 'k_{t}','FcRn','FcyRIIb','v_m','v_{STB}',...
    'v_{STR}','v_{EC}','v_{f}'};% 

p.v_m = 4; %volume of plasma in mom (L)(Aguree 2019 review)... had previously been using 4 L (total blood vol)
p.v_se = 0.005*5.2e-5*1000;
p.v_s = 0.3; %volume of villi (L) (Abdalla et al 2016)
p.v_ee = 0.005*5.2e-5*1000;
p.v_f = 0.07; %volume of blood in fetus (L) (Lin and Tran, 2013)

%PARAMETERS THAT WORK WITH FIG 2F
% p.k_up = 0.06; p.k_deg = 0.4; p.k_t = 0.017; p.fcrn = 1.6e-5; p.fcgr2b = 1.6e-5;% 
% % p.k_up = 0.09; p.k_deg = 0.1; p.k_t = 0.017; p.fcrn =1.6e-4; p.fcgr2b =1.6e-5; %p.fcrn =1e-4; %p.fcgr2b =3e-5;
% p.v_m = 4; %volume of plasma in mom (L)(Aguree 2019 review)... had previously been using 4 L (total blood vol)
% p.v_se = 0.017;
% p.v_s = 0.3; %volume of villi (L) (Abdalla et al 2016)
% p.v_ee = 0.044;
% p.v_f = 0.07; %volume of blood in fetus (L) (Lin and Tran, 2013)

%% TIME SPAN OF THE SIMULATION

%MY VERSION
t_end=40; % length of the simulations
tspan=(10:1:t_end);   % time points where the output is calculated
time_points=linspace(1,t_end-1,100); % time points of interest for the US analysis

p.mass_igg = 1.5e5; %molar mass of IgG (1 kDa = 1 g/mol)

p.igg1 = 5.67/p.mass_igg; %IgG1 concentration (M)
p.igg2 = 2.71/p.mass_igg; %IgG2 concentration (M)
p.igg3 = 0.4/(p.mass_igg+2e4); %IgG3 has a higher molar mass (M).
p.igg4 = 0.34/p.mass_igg; %IgG4 concentration (M)

% y0 = [p.igg1,p.igg2,p.igg3,p.igg4,zeros(1,4),p.fcrn,zeros(1,4),p.fcgr2b,zeros(1,4)];
y0 = [p.igg1,p.igg2,p.igg3,p.igg4,zeros(1,16)];
x0_syn = [p.fcrn;zeros(8,1)];
x0_endo = [p.fcgr2b;zeros(8,1)];

% Variables Labels
y_var_label={'x_{fet.}'};


%%%%%%%%%%%%%%%%%%%%%%% FcRn Binding Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
%IgG1
p.kon1 = 5.4e5; %(1/Ms)
p.koff1 = p.k_d_fcrn(1)*p.kon1; %(1.4 1/s)
%IgG2
p.kon2 = p.koff1/p.k_d_fcrn(2); %(1/Ms)
p.koff2 = p.k_d_fcrn(2)*p.kon2; %(1.4 1/s)
%IgG3
p.kon3 = p.koff1/p.k_d_fcrn(3); %(1/Ms)
p.koff3 = p.k_d_fcrn(3)*p.kon3; %(1/s)
%IgG4
p.kon4 = p.koff1/p.k_d_fcrn(4); %(1/Ms)
p.koff4 = p.k_d_fcrn(4)*p.kon4; %(1/s)

%%%%%%%%%%%%%%%%%%%%%%% FcgRIIb Binding Parameters %%%%%%%%%%%%%%%%%%%%%%%%
%IgG1
p.kon1b = 5.4e5; %(1/Ms)
p.koff1b = p.k_d_fcgr2b(1)*p.kon1b; %(1.4 1/s)
%IgG2
p.kon2b = p.koff1b/p.k_d_fcgr2b(2); %(1/Ms)
p.koff2b = p.k_d_fcgr2b(2)*p.kon2b; %(1.4 1/s)
%IgG3
p.kon3b = p.koff1b/p.k_d_fcgr2b(3); %(1/Ms)
p.koff3b = p.k_d_fcgr2b(3)*p.kon3b; %(1/s)
%IgG4
p.kon4b = p.koff1b/p.k_d_fcgr2b(4); %(1/Ms)
p.koff4b = p.k_d_fcgr2b(4)*p.kon4b; %(1/s)

%%%%%%%%%%%%%%%%%%%% Michealis Menten Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%

p.KM1 = (p.koff1 + p.k_t)/p.kon1; %IgG1 and FcRn
p.KM2 = (p.koff2 + p.k_t)/p.kon2; %IgG2 and FcRn
p.KM3 = (p.koff3 + p.k_t)/p.kon3; %IgG3 and FcRn
p.KM4 = (p.koff4 + p.k_t)/p.kon4; %IgG4 and FcRn

p.KM1b = (p.koff1b + p.k_up)/p.kon1b; %IgG1 and FcgRIIb
p.KM2b = (p.koff2b + p.k_up)/p.kon2b; %IgG2 and FcgRIIb
p.KM3b = (p.koff3b + p.k_up)/p.kon3b; %IgG3 and FcgRIIb
p.KM4b = (p.koff4b + p.k_up)/p.kon4b; %IgG4 and FcgRIIb

time_points=linspace(10,t_end-1,100); % time points of interest for the US analysis
