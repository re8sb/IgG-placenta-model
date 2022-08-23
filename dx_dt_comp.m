function [dx_dt_comp] = dx_dt_comp(t,x,p)
%Author: Remziye Erdogan
%Date: 11/10/2021
%This is a toy model to represent competition between different IgG
%subclasses for binding to an Fc receptor.
%The effect of competition can be explored here (e.g., does an excess amount of
%IgG1 limit the binding of IgG3 and IgG4 to FcyRIIb?) and the goal is to
%integrate this model into larger simulations of antibody transfer, IgG
%effector functions, etc.

%x(1) is the pool of unbound receptor
%x(2) is the pool of complexed receptor and 1 subclass of IgG
%x(3) is the pool of complexed receptor and the other subclass of IgG
%t is time
%p is a data structure containing parameters (in this case, kon and koff
%for each antibody, and the initial concentrations of each antibody)

%initialize solution
% dx_dt_comp = zeros(3,1);
dx_dt_comp = zeros(9,1);

%unbound receptor
dx_dt_comp(1) = -p.kon1*x(1)*x(6) + p.koff1*x(2) -p.kon2*x(1)*x(7) + p.koff2*x(3) ...
     - p.kon3*x(1)*x(8) + p.koff3*x(4) - p.kon4*x(1)*x(9) + p.koff4*x(5); %concentration of FcyRIIb

%bound IgG subclasses
dx_dt_comp(2) = -p.koff1*x(2) + p.kon1*x(6)*x(1); %concentration of FcyRIIb-IgG1 complex
dx_dt_comp(3) = -p.koff2*x(3) + p.kon2*x(7)*x(1); %concentration of FcyRIIb-IgG2 complex
dx_dt_comp(4) = -p.koff3*x(4) + p.kon3*x(8)*x(1); %concentration of FcyRIIb-IgG3 complex
dx_dt_comp(5) = -p.koff4*x(5) + p.kon4*x(9)*x(1); %concentration of FcyRIIb-IgG4 complex

%unbound IgG subclasses
dx_dt_comp(6) = p.koff1*x(2) - p.kon1*x(6)*x(1); %concentration of IgG1 
dx_dt_comp(7) = p.koff2*x(3) - p.kon2*x(7)*x(1); %concentration of IgG2
dx_dt_comp(8) = p.koff3*x(4) - p.kon3*x(8)*x(1); %concentration of IgG3 
dx_dt_comp(9) = p.koff4*x(5) - p.kon4*x(9)*x(1); %concentration of IgG4

end

