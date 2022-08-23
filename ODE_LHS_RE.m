function dydt=IgGmodel(t,x,LHSmatrix,n,runs)
%% PARAMETERS %%
Parameter_settings_LHS;

p.k_up = LHSmatrix(n,1);
p.k_deg = LHSmatrix(n,2);
p.k_t = LHSmatrix(n,3);
% p.k_d_fcrn = LHSmatrix(n,4);
% p.k_d_fcgr2b = LHSmatrix(n,5);
p.fcrn = LHSmatrix(n,4);
p.fcgr2b = LHSmatrix(n,5);
p.v_m = LHSmatrix(n,6);
p.v_se = LHSmatrix(n,7);
p.v_s = LHSmatrix(n,8);
p.v_ee = LHSmatrix(n,9);
p.v_f = LHSmatrix(n,10);

layer = 'syn'; x0_syn = [p.fcrn; 0; 0; 0; 0; x(5); x(6); x(7); x(8)]; 
% end
tspan = [0 1]; 
clear sol_sub_syn
%synctiotrophoblast subroutine
sol_sub_syn = ode15s(@(t,x) dx_dt_comp(t,x,p), tspan, x0_syn);
C1_syn_ss = sol_sub_syn.y(2,end);
C2_syn_ss = sol_sub_syn.y(3,end);
C3_syn_ss = sol_sub_syn.y(4,end);
C4_syn_ss = sol_sub_syn.y(5,end);

layer = 'endo';x0_endo = [p.fcgr2b; 0; 0; 0; 0; x(9); x(10); x(11); x(12)]; 
% layer = 'endo';x0_endo = [p.fcgr2b; 0; 0; 0; 0; x(13); x(14); x(15);
% x(16)]; %This one is where FcgRIIb binding happens intracellularly.

%endothelial cell subroutine
tspan = [0 1]; 
clear sol_sub_endo
sol_sub_endo = ode15s(@(t,x) dx_dt_comp(t,x,p), tspan, x0_endo);
C1_endo_ss = sol_sub_endo.y(2,end);
C2_endo_ss = sol_sub_endo.y(3,end);
C3_endo_ss = sol_sub_endo.y(4,end);
C4_endo_ss = sol_sub_endo.y(5,end);

%initialize solution
dydt = zeros(20,1);

dydt(1) = -p.k_up*x(1)/p.v_m; %maternal blood
dydt(2) = -p.k_up*x(2)/p.v_m; %maternal blood
dydt(3) = -p.k_up*x(3)/p.v_m; %maternal blood
dydt(4) = -p.k_up*x(4)/p.v_m; %maternal blood

dydt(5) = (p.k_up*x(1) - p.k_t*C1_syn_ss - p.k_deg*x(5))/p.v_se; %STB endosomes
dydt(6) = (p.k_up*x(2) - p.k_t*C2_syn_ss - p.k_deg*x(6))/p.v_se; %STB endosomes
dydt(7) = (p.k_up*x(3) - p.k_t*C3_syn_ss - p.k_deg*x(7))/p.v_se; %STB endosomes
dydt(8) = (p.k_up*x(4) - p.k_t*C4_syn_ss - p.k_deg*x(8))/p.v_se; %STB endosomes

dydt(9) = (p.k_t*C1_syn_ss - p.k_up*C1_endo_ss)/p.v_s; %stroma
dydt(10) = (p.k_t*C2_syn_ss - p.k_up*C2_endo_ss)/p.v_s; %stroma
dydt(11) = (p.k_t*C3_syn_ss - p.k_up*C3_endo_ss)/p.v_s; %stroma
dydt(12) = (p.k_t*C4_syn_ss - p.k_up*C4_endo_ss)/p.v_s; %stroma

dydt(13) = (p.k_up*C1_endo_ss - p.k_t*x(13))/p.v_ee; %endothelial cells
dydt(14) = (p.k_up*C2_endo_ss - p.k_t*x(14))/p.v_ee; %endothelial cells
dydt(15) = (p.k_up*C3_endo_ss - p.k_t*x(15))/p.v_ee; %endothelial cells
dydt(16) = (p.k_up*C4_endo_ss - p.k_t*x(16))/p.v_ee; %endothelial cells

dydt(17) = (p.k_t*x(13))/p.v_f; %fetal blood
dydt(18) = (p.k_t*x(14))/p.v_f; %fetal blood
dydt(19) = (p.k_t*x(15))/p.v_f; %fetal blood
dydt(20) = (p.k_t*x(16))/p.v_f; %fetal blood

%These show FcgRIIb binding happening intracellularly.
% dydt(9) = (p.k_t*C1_syn_ss - p.k_up*x(9))/p.v_s; %stroma
% dydt(10) = (p.k_t*C2_syn_ss - p.k_up*x(10))/p.v_s; %stroma
% dydt(11) = (p.k_t*C3_syn_ss - p.k_up*x(11))/p.v_s; %stroma
% dydt(12) = (p.k_t*C4_syn_ss - p.k_up*x(12))/p.v_s; %stroma
% 
% dydt(13) = (p.k_up*x(9) - p.k_t*C1_endo_ss)/p.v_ee; %endothelial cells
% dydt(14) = (p.k_up*x(10) - p.k_t*C2_endo_ss)/p.v_ee; %endothelial cells
% dydt(15) = (p.k_up*x(11) - p.k_t*C3_endo_ss)/p.v_ee; %endothelial cells
% dydt(16) = (p.k_up*x(12) - p.k_t*C4_endo_ss)/p.v_ee; %endothelial cells

% dydt(17) = (p.k_t*C1_endo_ss)/p.v_f; %fetal blood
% dydt(18) = (p.k_t*C2_endo_ss)/p.v_f; %fetal blood
% dydt(19) = (p.k_t*C3_endo_ss)/p.v_f; %fetal blood
% dydt(20) = (p.k_t*C4_endo_ss)/p.v_f; %fetal blood

