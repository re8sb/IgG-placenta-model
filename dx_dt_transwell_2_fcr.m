function dx_dt_simple = dx_dt_simple(t,x,p,x0)

%%%%%%%%%%%%%%%%Assume 1 IgG and 2 FcRs%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dx_dt_simple = zeros(4,1);
% x0 = [IgG(0),FcR1(0),FcR2(0),0];

KM1 = (p.koff1 + p.kT)/p.kon1; 
KM2 = (p.koff2 + p.kT)/p.kon2;

C1 = x0(2)*x(1)/(KM1 + x(1)); %st.st. receptor-ligand complex 
C2 = x0(3)*x(1)/(KM2 + x(1)); %st.st. receptor-ligand complex

dx_dt_simple(1) = -p.kon1*x(1)*x(2) - p.kon2*x(1)*x(3) + p.koff1*C1 + p.koff2*C2; %unbound IgG1
dx_dt_simple(2) = -x(2)*p.kon1*x(1) + (p.koff1 + p.kT)*C1; %unbound FcR1
dx_dt_simple(3) = -x(3)*p.kon2*x(1) + (p.koff2 + p.kT)*C2; %unbound FcR2
dx_dt_simple(4) = p.kT*(C1 + C2); %transported IgG2, V2

%%%%%%%%%%%%%%%%Assume 1 IgG and 1 FcR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dx_dt_simple = zeros(3,1);
% % x0 = [IgG1(0),FcR(0),0];

% KM = (p.koff1 + p.kT)/p.kon1;

% C1 = x0(2)*x(1)/(KM + x(1));

% dx_dt_simple(1) = -p.kon1*x(1)*x(2) + p.koff1*C1; %unbound IgG1
% dx_dt_simple(2) = -p.kon1*x(1)*x(2) + (p.koff1+p.kT)*C1; %unbound FcR
% dx_dt_simple(3) = p.kT*C1; %transported IgG1

%%%%%%%%%%%%%%%%Assume 2 IgGs and 1 FcR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dx_dt_simple = zeros(5,1);
% % x0 = [IgG1(0),IgG2(0),FcR(0),0,0];
% 
% C1 = x0(3)*x(1)/(p.kd1*(1 + (x(1)/p.kd1) + (x(2)/p.kd2))); %st.st. receptor-ligand complex 
% C2 = x0(3)*x(2)/(p.kd2*(1 + (x(1)/p.kd1) + (x(2)/p.kd2))); %st.st. receptor-ligand complex
% 
% dx_dt_simple(1) = -p.kon1*x(1)*x(3) + p.koff1*C1; %unbound IgG1
% dx_dt_simple(2) = -p.kon2*x(2)*x(3) + p.koff2*C2; %unbound IgG2
% 
% dx_dt_simple(3) = -x(3)*(p.kon1*x(1) + p.kon2*x(2)) + (p.koff1+p.kT)*C1 + (p.koff1+p.kT)*C2; %unbound FcR
% dx_dt_simple(4) = p.kT*C1; %transported IgG1, V1
% dx_dt_simple(5) = p.kT*C2; %transported IgG2, V2

%Assume 2 IgGs and 2 FcRs

end

