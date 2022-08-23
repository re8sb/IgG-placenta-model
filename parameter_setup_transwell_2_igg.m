%% set up external parameters

%% IgG1 binding parameters
%%%Fcrn binding parameters from Ferl et al, 2005%%%
p.kon1 = 2.4e5; %ml/(minmol) -> 1/(Mmin)
p.koff1 = 0.003; %1/min
p.kd1 = p.koff1/p.kon1; %M
%%%FcgRIIb binding parameters%%%
p.kon2 = 5.4e5; %ml/(minmol) -> 1/(Mmin)
p.koff2 = 4.5; %1/min
p.kd2 = p.koff2/p.kon2; %M

p.kT = 5e-3;
vol = 0.1; %volume of apical chamber, L
avo = 6.022e23;
g2kda = 6.022e20; %1 g = 6.02e20 kDa
FcR_MW = 31; %FcRn = 31 kDa, FcgRIIb = 36 kDa
IgG_MW = 150;
IgG10 = 0.1*vol*g2kda/(1000*IgG_MW*avo*vol*1e-3); %mg/ml -> mg -> kDa -> number of particles -> mol -> mol/L (M)
IgG20 = 0.1*vol*g2kda/(1000*IgG_MW*avo*vol*1e-3); %mg/ml -> mg -> kDa -> number of particles -> mol -> mol/L (M)
FcR10 = 2e-4*vol*g2kda/(1000*FcR_MW*avo*vol*1e-3); %mg/ml -> mg -> kDa -> number of particles -> mol -> mol/L (M)
FcR20 = 2e-4*vol*g2kda/(1000*FcR_MW*avo*vol*1e-3); %mg/ml -> mg -> kDa -> number of particles -> mol -> mol/L (M)

% x0 = [IgG10,FcR10,FcR20,0];
x0 = [IgG10,IgG20,FcR10,0,0];

