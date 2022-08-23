function [dx_dt_trans_comp1121] = dx_dt_trans_comp1121(t,x,p)
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

%initialize solution
dx_dt_trans_comp1121 = zeros(20,1);

%solve subroutine ODE at this time step
tspan = [0 1]; layer = 'syn'; parameter_setup1121
x0_syn = [p.fcrn; 0; 0; 0; 0; x(5); x(6); x(7); x(8)]; clear sol_sub_syn
%synctiotrophoblast subroutine
% x0 = [p.fcrn; 0; x(2)]; clear sol_sub_syn
sol_sub_syn = ode15s(@(t,x) dx_dt_comp(t,x,p), tspan, x0_syn);
C1_syn_ss = sol_sub_syn.y(2,end);
C2_syn_ss = sol_sub_syn.y(3,end);
C3_syn_ss = sol_sub_syn.y(4,end);
C4_syn_ss = sol_sub_syn.y(5,end);

%endothelial cell subroutine
tspan = [0 1]; layer = 'endo'; parameter_setup1121
x0_endo = [p.fcgr2b; 0; 0; 0; 0; x(13); x(14); x(15); x(16)]; clear sol_sub_endo
% x0 = [p.fcgr2b; 0; x(4)]; clear sol_sub_endo
sol_sub_endo = ode15s(@(t,x) dx_dt_comp(t,x,p), tspan, x0_endo);
C1_endo_ss = sol_sub_endo.y(2,end);
C2_endo_ss = sol_sub_endo.y(3,end);
C3_endo_ss = sol_sub_endo.y(4,end);
C4_endo_ss = sol_sub_endo.y(5,end);

dx_dt_trans_comp1121(1) = -p.k_up*x(1)/v_m; %maternal blood
dx_dt_trans_comp1121(2) = -p.k_up*x(2)/v_m; %maternal blood
dx_dt_trans_comp1121(3) = -p.k_up*x(3)/v_m; %maternal blood
dx_dt_trans_comp1121(4) = -p.k_up*x(4)/v_m; %maternal blood

dx_dt_trans_comp1121(5) = (p.k_up*x(1) - p.k_trans*C1_syn_ss - p.k_deg*x(5))/v_se; %STB endosomes
dx_dt_trans_comp1121(6) = (p.k_up*x(2) - p.k_trans*C2_syn_ss - p.k_deg*x(6))/v_se; %STB endosomes
dx_dt_trans_comp1121(7) = (p.k_up*x(3) - p.k_trans*C3_syn_ss - p.k_deg*x(7))/v_se; %STB endosomes
dx_dt_trans_comp1121(8) = (p.k_up*x(4) - p.k_trans*C4_syn_ss - p.k_deg*x(8))/v_se; %STB endosomes

dx_dt_trans_comp1121(9) = (p.k_trans*C1_syn_ss - p.k_up*x(9))/v_s; %stroma
dx_dt_trans_comp1121(10) = (p.k_trans*C2_syn_ss - p.k_up*x(10))/v_s; %stroma
dx_dt_trans_comp1121(11) = (p.k_trans*C3_syn_ss - p.k_up*x(11))/v_s; %stroma
dx_dt_trans_comp1121(12) = (p.k_trans*C4_syn_ss - p.k_up*x(12))/v_s; %stroma

dx_dt_trans_comp1121(13) = (p.k_up*x(9) - p.k_trans*C1_endo_ss)/v_ee; %endothelial cells
dx_dt_trans_comp1121(14) = (p.k_up*x(10) - p.k_trans*C2_endo_ss)/v_ee; %endothelial cells
dx_dt_trans_comp1121(15) = (p.k_up*x(11) - p.k_trans*C3_endo_ss)/v_ee; %endothelial cells
dx_dt_trans_comp1121(16) = (p.k_up*x(12) - p.k_trans*C4_endo_ss)/v_ee; %endothelial cells

dx_dt_trans_comp1121(17) = (p.k_trans*C1_endo_ss)/v_f; %fetal blood
dx_dt_trans_comp1121(18) = (p.k_trans*C2_endo_ss)/v_f; %fetal blood
dx_dt_trans_comp1121(19) = (p.k_trans*C3_endo_ss)/v_f; %fetal blood
dx_dt_trans_comp1121(20) = (p.k_trans*C4_endo_ss)/v_f; %fetal blood

end
