%% Initialize parameters for model using vaccine simulation.

%% set up external parameters
%IgG1 kinetic constants taken from Maenaka et al (2001)
%IgG4 kinetic constants adjusted accordingly based on known differences in
%Kd
p.k_d_fcgr2b = 1./[1.2e5,2e4,1.7e5,2e5]; %Bruhns et al (2009)
p.k_d_fcrn = 1./[8e7 5e7 3e7 2e7]; %Bruhns et al (2009)

%%%%%%%%%%%%%% General Model Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p.k_up = 0.02; p.k_deg = 0.015; p.k_t = 0.01; p.fcrn =1e-4; p.fcgr2b =3e-5;

p.mass_igg = 1.5e5; %molar mass of IgG (1 kDa = 1 g/mol)

p.igg1 = 5.67/p.mass_igg; %IgG1 concentration (M)
p.igg2 = 2.71/p.mass_igg; %IgG2 concentration (M)
p.igg3 = 0.4/(p.mass_igg+2e4); %IgG3 has a higher molar mass (M).
p.igg4 = 0.34/p.mass_igg; %IgG4 concentration (M)
% 
p.igg1vax =  0.01*9/p.mass_igg; %IgG1 concentration (M)
p.igg2vax =  0.01*9/p.mass_igg; %IgG2 concentration (M)
p.igg3vax =  0.01*9/(p.mass_igg+2e4); %IgG3 has a higher molar mass (M).
p.igg4vax =  0.01*9/p.mass_igg; %IgG4 concentration (M)

%%%%%%%%%%%%%%%%%%%%%%% Initial values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Bulk IgG model
% x0 = [(p.igg1+p.igg2+p.igg3+p.igg4),0,p.fcrn,0,p.fcgr2b,0];

%IgG subclass model
x0 = [p.igg1,p.igg2,p.igg3,p.igg4,zeros(1,16),...
p.igg1vax,p.igg2vax,p.igg3vax,p.igg4vax,zeros(1,16)];

%% Volumes
p.v_m = 4; %volume of plasma in mom (L)(Aguree 2019 review)... had previously been using 4 L (total blood vol)
p.v_se = 0.005*5.2e-5*1000;
p.v_s = 0.3; %volume of villi (L) (Abdalla et al 2016)
p.v_ee = 0.005*5.2e-5*1000;
p.v_f = 0.07; %volume of blood in fetus (L) (Lin and Tran, 2013)

%%%%%%%%%%%%%%%%%%%%%%% FcRn Binding Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
% if strcmp(layer,'syn')
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
% elseif strcmp(layer,'endo')
%%%%%%%%%%%%%%%%%%%%%%% FcgRIIb Binding Parameters %%%%%%%%%%%%%%%%%%%%%%%%
%IgG1
p.kon1 = 5.4e5; %(1/Ms)
p.koff1 = p.k_d_fcgr2b(1)*p.kon1; %(1.4 1/s)
%IgG2
p.kon2 = p.koff1/p.k_d_fcgr2b(2); %(1/Ms)
p.koff2 = p.k_d_fcgr2b(2)*p.kon2; %(1.4 1/s)
%IgG3
p.kon3 = p.koff1/p.k_d_fcgr2b(3); %(1/Ms)
p.koff3 = p.k_d_fcgr2b(3)*p.kon3; %(1/s)
%IgG4
p.kon4 = p.koff1/p.k_d_fcgr2b(4); %(1/Ms)
p.koff4 = p.k_d_fcgr2b(4)*p.kon4; %(1/s)
% end

