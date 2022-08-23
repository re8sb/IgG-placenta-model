function [dx_dt_trans_comp] = dx_dt_trans_comp(t,x,p)
%Author: Remziye Erdogan
%Date: 11/14/2021
%This is a transfer model that calls dx_dt_comp to determine transfer by
%using the steady state values from dx_dt_comp
%x(1) is the pool of unbound receptor
%x(2) is the pool of complexed receptor and 1 subclass of IgG
%x(3) is the pool of complexed receptor and the other subclass of IgG
%t is time
%p is a data structure containing parameters (in this case, kon and koff
%for each antibody, and the initial concentrations of each antibody)

%solve subroutine ODE at this time step
layer = 'syn'; parameter_setup_main;
x0_syn = [p.fcrn; 0; 0; 0; 0; x(5); x(6); x(7); x(8)]; 
tspan = [0 1]; 
clear sol_sub_syn
%synctiotrophoblast subroutine
sol_sub_syn = ode15s(@(t,x) dx_dt_comp(t,x,p), tspan, x0_syn);
C1_syn_ss = sol_sub_syn.y(2,end);
C2_syn_ss = sol_sub_syn.y(3,end);
C3_syn_ss = sol_sub_syn.y(4,end);
C4_syn_ss = sol_sub_syn.y(5,end);

layer = 'endo'; parameter_setup_main;
x0_endo = [p.fcgr2b; 0; 0; 0; 0; x(9); x(10); x(11); x(12)]; 
% x0_endo = [p.fcgr2b; 0; 0; 0; 0; x(13); x(14); x(15); x(16)]; %This one is where FcgRIIb binding happens intracellularly.

%endothelial cell subroutine
tspan = [0 1]; 
clear sol_sub_endo
sol_sub_endo = ode15s(@(t,x) dx_dt_comp(t,x,p), tspan, x0_endo);
C1_endo_ss = sol_sub_endo.y(2,end);
C2_endo_ss = sol_sub_endo.y(3,end);
C3_endo_ss = sol_sub_endo.y(4,end);
C4_endo_ss = sol_sub_endo.y(5,end);

%initialize solution
dx_dt_trans_comp = zeros(20,1);

dx_dt_trans_comp(1) = -p.k_up*x(1)/p.v_m; %maternal blood
dx_dt_trans_comp(2) = -p.k_up*x(2)/p.v_m; %maternal blood
dx_dt_trans_comp(3) = -p.k_up*x(3)/p.v_m; %maternal blood
dx_dt_trans_comp(4) = -p.k_up*x(4)/p.v_m; %maternal blood

dx_dt_trans_comp(5) = (p.k_up*x(1) - p.k_t*C1_syn_ss - p.k_deg*x(5))/p.v_se; %STB endosomes
dx_dt_trans_comp(6) = (p.k_up*x(2) - p.k_t*C2_syn_ss - p.k_deg*x(6))/p.v_se; %STB endosomes
dx_dt_trans_comp(7) = (p.k_up*x(3) - p.k_t*C3_syn_ss - p.k_deg*x(7))/p.v_se; %STB endosomes
dx_dt_trans_comp(8) = (p.k_up*x(4) - p.k_t*C4_syn_ss - p.k_deg*x(8))/p.v_se; %STB endosomes

dx_dt_trans_comp(9) = (p.k_t*C1_syn_ss - p.k_up*C1_endo_ss)/p.v_s; %stroma
dx_dt_trans_comp(10) = (p.k_t*C2_syn_ss - p.k_up*C2_endo_ss)/p.v_s; %stroma
dx_dt_trans_comp(11) = (p.k_t*C3_syn_ss - p.k_up*C3_endo_ss)/p.v_s; %stroma
dx_dt_trans_comp(12) = (p.k_t*C4_syn_ss - p.k_up*C4_endo_ss)/p.v_s; %stroma

dx_dt_trans_comp(13) = (p.k_up*C1_endo_ss - p.k_t*x(13))/p.v_ee; %endothelial cells
dx_dt_trans_comp(14) = (p.k_up*C2_endo_ss - p.k_t*x(14))/p.v_ee; %endothelial cells
dx_dt_trans_comp(15) = (p.k_up*C3_endo_ss - p.k_t*x(15))/p.v_ee; %endothelial cells
dx_dt_trans_comp(16) = (p.k_up*C4_endo_ss - p.k_t*x(16))/p.v_ee; %endothelial cells

dx_dt_trans_comp(17) = (p.k_t*x(13))/p.v_f; %fetal blood
dx_dt_trans_comp(18) = (p.k_t*x(14))/p.v_f; %fetal blood
dx_dt_trans_comp(19) = (p.k_t*x(15))/p.v_f; %fetal blood
dx_dt_trans_comp(20) = (p.k_t*x(16))/p.v_f; %fetal blood

%These show FcgRIIb binding happening intracellularly.
% dx_dt_trans_comp(9) = (p.k_t*C1_syn_ss - p.k_up*x(9))/p.v_s; %stroma
% dx_dt_trans_comp(10) = (p.k_t*C2_syn_ss - p.k_up*x(10))/p.v_s; %stroma
% dx_dt_trans_comp(11) = (p.k_t*C3_syn_ss - p.k_up*x(11))/p.v_s; %stroma
% dx_dt_trans_comp(12) = (p.k_t*C4_syn_ss - p.k_up*x(12))/p.v_s; %stroma
% % 
% dx_dt_trans_comp(13) = (p.k_up*x(9) - p.k_t*C1_endo_ss)/p.v_ee; %endothelial cells
% dx_dt_trans_comp(14) = (p.k_up*x(10) - p.k_t*C2_endo_ss)/p.v_ee; %endothelial cells
% dx_dt_trans_comp(15) = (p.k_up*x(11) - p.k_t*C3_endo_ss)/p.v_ee; %endothelial cells
% dx_dt_trans_comp(16) = (p.k_up*x(12) - p.k_t*C4_endo_ss)/p.v_ee; %endothelial cells
% % 
% dx_dt_trans_comp(17) = (p.k_t*C1_endo_ss)/p.v_f; %fetal blood
% dx_dt_trans_comp(18) = (p.k_t*C2_endo_ss)/p.v_f; %fetal blood
% dx_dt_trans_comp(19) = (p.k_t*C3_endo_ss)/p.v_f; %fetal blood
% dx_dt_trans_comp(20) = (p.k_t*C4_endo_ss)/p.v_f; %fetal blood

end
