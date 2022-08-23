function [dx_dt_vax] = dx_dt_vax(t,x,p)
%Author: Remziye Erdogan
%Date: 07/30/2022
%This is an adaptation of the QSSA total IgG transfer model. Here, there
%are two categories of IgG:  Total IgG subclasses, and vaccine-induced
%antigen-specific IgG subclasses. Here, we can ask questions about how the
%polarization of vaccine-induced IgG subclasses affects transfer
%efficiency.

%initialize solution
dx_dt_vax = zeros(40,1);
%x0 = [IgG10,IgG20,IgG30,IgG40,zeros(16,1),...
% IgG10vax,IgG20vax,IgG30vax,IgG40vax,zeros(16,1)];

%%%%%%%%%%%%%%%%%%%%%%% FcRn-IgG complexes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

x0_syn = [p.fcrn; 0; 0; 0; 0; x(5); x(6); x(7); x(8); 0; 0; 0; 0; x(25);...
    x(26); x(27); x(28)]; 
%STB cell subroutine
tspan = [0 1]; 
clear sol_sub_syn
sol_sub_syn = ode15s(@(t,x) dx_dt_fcr(t,x,p), tspan, x0_syn);
C1_syn = sol_sub_syn.y(2,end);
C2_syn = sol_sub_syn.y(3,end);
C3_syn = sol_sub_syn.y(4,end);
C4_syn = sol_sub_syn.y(5,end);

C1_syn_vax = sol_sub_syn.y(10,end);
C2_syn_vax = sol_sub_syn.y(11,end);
C3_syn_vax = sol_sub_syn.y(12,end);
C4_syn_vax = sol_sub_syn.y(13,end);

%%%%%%%%%%%%%%%%%%%%%%% FcgRIIb-IgG complexes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%IgG1
p.kon1 = 5.4e5; %(1/Ms)
p.koff1 = p.k_d_fcgr2b(1)*p.kon1; %(1.4 1/s)
% p.kon1 = 0; p.koff1 = 0;
% IgG2
p.kon2 = p.koff1/p.k_d_fcgr2b(2); %(1/Ms)
p.koff2 = p.k_d_fcgr2b(2)*p.kon2; %(1.4 1/s)
% p.kon2 = 0; p.koff2 = 0;
%IgG3
p.kon3 = p.koff1/p.k_d_fcgr2b(3); %(1/Ms)
p.koff3 = p.k_d_fcgr2b(3)*p.kon3; %(1/s)
% p.kon3 = 0; p.koff3 = 0;
%IgG4
p.kon4 = p.koff1/p.k_d_fcgr2b(4); %(1/Ms)
p.koff4 = p.k_d_fcgr2b(4)*p.kon4; %(1/s)
% p.kon4 = 0; p.koff4 = 0;

x0_endo = [p.fcgr2b; 0; 0; 0; 0; x(9); x(10); x(11); x(12); 0; 0; 0; 0; x(29);...
    x(30); x(31); x(32)]; 
%endothelial cell subroutine
tspan = [0 1]; 
clear sol_sub_endo
sol_sub_endo = ode15s(@(t,x) dx_dt_fcr(t,x,p), tspan, x0_endo);
C1_endo = sol_sub_endo.y(2,end);
C2_endo = sol_sub_endo.y(3,end);
C3_endo = sol_sub_endo.y(4,end);
C4_endo = sol_sub_endo.y(5,end);

C1_endo_vax = sol_sub_endo.y(10,end);
C2_endo_vax = sol_sub_endo.y(11,end);
C3_endo_vax = sol_sub_endo.y(12,end);
C4_endo_vax = sol_sub_endo.y(13,end);

%%%%%%%%%%%%%%%%%%% main ODEs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dx_dt_vax = zeros(40,1);

dx_dt_vax(1) = -p.k_up*x(1)/p.v_m; %maternal blood
dx_dt_vax(2) = -p.k_up*x(2)/p.v_m; %maternal blood
dx_dt_vax(3) = -p.k_up*x(3)/p.v_m; %maternal blood
dx_dt_vax(4) = -p.k_up*x(4)/p.v_m; %maternal blood

dx_dt_vax(5) = (p.k_up*x(1) - p.k_t*C1_syn - p.k_deg*x(5))/p.v_se; %STB endosomes
dx_dt_vax(6) = (p.k_up*x(2) - p.k_t*C2_syn - p.k_deg*x(6))/p.v_se; %STB endosomes
dx_dt_vax(7) = (p.k_up*x(3) - p.k_t*C3_syn - p.k_deg*x(7))/p.v_se; %STB endosomes
dx_dt_vax(8) = (p.k_up*x(4) - p.k_t*C4_syn - p.k_deg*x(8))/p.v_se; %STB endosomes

dx_dt_vax(9) = (p.k_t*C1_syn - p.k_up*C1_endo)/p.v_s; %stroma
dx_dt_vax(10) = (p.k_t*C2_syn - p.k_up*C2_endo)/p.v_s; %stroma
dx_dt_vax(11) = (p.k_t*C3_syn - p.k_up*C3_endo)/p.v_s; %stroma
dx_dt_vax(12) = (p.k_t*C4_syn - p.k_up*C4_endo)/p.v_s; %stroma

dx_dt_vax(13) = (p.k_up*C1_endo - p.k_t*x(13))/p.v_ee; %endothelial cells
dx_dt_vax(14) = (p.k_up*C2_endo - p.k_t*x(14))/p.v_ee; %endothelial cells
dx_dt_vax(15) = (p.k_up*C3_endo - p.k_t*x(15))/p.v_ee; %endothelial cells
dx_dt_vax(16) = (p.k_up*C4_endo - p.k_t*x(16))/p.v_ee; %endothelial cells

dx_dt_vax(17) = (p.k_t*x(13))/p.v_f; %fetal blood
dx_dt_vax(18) = (p.k_t*x(14))/p.v_f; %fetal blood
dx_dt_vax(19) = (p.k_t*x(15))/p.v_f; %fetal blood
dx_dt_vax(20) = (p.k_t*x(16))/p.v_f; %fetal blood

%%%%%%%%%%%%%%%%%%%%% Ag-specific IgG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dx_dt_vax(21) = -p.k_up*x(21)/p.v_m; %maternal blood
dx_dt_vax(22) = -p.k_up*x(22)/p.v_m; %maternal blood
dx_dt_vax(23) = -p.k_up*x(23)/p.v_m; %maternal blood
dx_dt_vax(24) = -p.k_up*x(24)/p.v_m; %maternal blood

dx_dt_vax(25) = (p.k_up*x(21) - p.k_t*C1_syn_vax - p.k_deg*x(25))/p.v_se; %STB endosomes
dx_dt_vax(26) = (p.k_up*x(22) - p.k_t*C2_syn_vax - p.k_deg*x(26))/p.v_se; %STB endosomes
dx_dt_vax(27) = (p.k_up*x(23) - p.k_t*C3_syn_vax - p.k_deg*x(27))/p.v_se; %STB endosomes
dx_dt_vax(28) = (p.k_up*x(24) - p.k_t*C4_syn_vax - p.k_deg*x(28))/p.v_se; %STB endosomes

dx_dt_vax(29) = (p.k_t*C1_syn_vax - p.k_up*C1_endo_vax)/p.v_s; %stroma
dx_dt_vax(30) = (p.k_t*C2_syn_vax - p.k_up*C2_endo_vax)/p.v_s; %stroma
dx_dt_vax(31) = (p.k_t*C3_syn_vax - p.k_up*C3_endo_vax)/p.v_s; %stroma
dx_dt_vax(32) = (p.k_t*C4_syn_vax - p.k_up*C4_endo_vax)/p.v_s; %stroma

dx_dt_vax(33) = (p.k_up*C1_endo_vax - p.k_t*x(33))/p.v_ee; %endothelial cells
dx_dt_vax(34) = (p.k_up*C2_endo_vax - p.k_t*x(34))/p.v_ee; %endothelial cells
dx_dt_vax(35) = (p.k_up*C3_endo_vax - p.k_t*x(35))/p.v_ee; %endothelial cells
dx_dt_vax(36) = (p.k_up*C4_endo_vax - p.k_t*x(36))/p.v_ee; %endothelial cells

dx_dt_vax(37) = (p.k_t*x(33))/p.v_f; %fetal blood
dx_dt_vax(38) = (p.k_t*x(34))/p.v_f; %fetal blood
dx_dt_vax(39) = (p.k_t*x(35))/p.v_f; %fetal blood
dx_dt_vax(40) = (p.k_t*x(36))/p.v_f; %fetal blood
end

