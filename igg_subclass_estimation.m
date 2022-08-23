%% Estimating composition of IgG subclasses for different Ag-specific IgG

%% load data 
close all
clear
addpath(genpath('C:\Users\remzi\Box\Remziye Erdogan share\Data and Analysis\Alter lab Data\Preterm_Fullterm_Swedish cohort'))
addpath(genpath('C:\Users\remzi\Box\Dolatshahi Lab Share\Code Share'))

opts = spreadsheetImportOptions("NumVariables", 648);

% Specify sheet and range
opts.Sheet = "Sheet2"; %sheet 3 has PBS subtracted already
opts.DataRange = "B5:XY101";

% Specify column names and types
opts.VariableNames = ["VarName2", "timepoint", "ADCP", "ADCP1", "ADCP2", "ADCP3", "ADCP4", "ADCP5", "ADCP6", "ADCP7", "ADCP8", "ADCP9", "ADNP", "ADNP1", "ADNP2", "ADNP3", "ADNP4", "ADNP5", "ADNP6", "ADNP7", "ADNP8", "ADNP9", "ADNP10", "ADNP11", "TotalIgG", "TotalIgG1", "TotalIgG2", "TotalIgG3", "TotalIgG4", "TotalIgG5", "TotalIgG6", "TotalIgG7", "TotalIgG8", "TotalIgG9", "TotalIgG10", "TotalIgG11", "TotalIgG12", "TotalIgG13", "TotalIgG14", "TotalIgG15", "TotalIgG16", "TotalIgG17", "TotalIgG18", "TotalIgG19", "TotalIgG20", "TotalIgG21", "TotalIgG22", "TotalIgG23", "TotalIgG24", "TotalIgG25", "TotalIgG26", "TotalIgG27", "TotalIgG28", "TotalIgG29", "TotalIgG30", "TotalIgG31", "TotalIgG32", "TotalIgG33", "TotalIgG34", "TotalIgG35", "TotalIgG36", "TotalIgG37", "TotalIgG38", "TotalIgG39", "TotalIgG40", "TotalIgG41", "TotalIgG42", "TotalIgG43", "TotalIgG44", "TotalIgG45", "TotalIgG46", "TotalIgG47", "IgM", "IgM1", "IgM2", "IgM3", "IgM4", "IgM5", "IgM6", "IgM7", "IgM8", "IgM9", "IgM10", "IgM11", "IgM12", "IgM13", "IgM14", "IgM15", "IgM16", "IgM17", "IgM18", "IgM19", "IgM20", "IgM21", "IgM22", "IgM23", "IgM24", "IgM25", "IgM26", "IgM27", "IgM28", "IgM29", "IgM30", "IgM31", "IgM32", "IgM33", "IgM34", "IgM35", "IgM36", "IgM37", "IgM38", "IgM39", "IgM40", "IgM41", "IgM42", "IgM43", "IgM44", "IgM45", "IgM46", "IgM47", "IgA1", "IgA2", "IgA3", "IgA4", "IgA5", "IgA6", "IgA7", "IgA8", "IgA9", "IgA10", "IgA11", "IgA12", "IgA13", "IgA14", "IgA15", "IgA16", "IgA17", "IgA18", "IgA19", "IgA20", "IgA21", "IgA22", "IgA23", "IgA24", "IgA25", "IgA26", "IgA27", "IgA28", "IgA29", "IgA30", "IgA31", "IgA32", "IgA33", "IgA34", "IgA35", "IgA36", "IgA37", "IgA38", "IgA39", "IgA40", "IgA41", "IgA42", "IgA43", "IgA44", "IgA45", "IgA46", "IgA47", "IgA48", "IgA49", "IgA50", "IgA51", "IgA52", "IgA53", "IgA54", "IgA55", "IgA56", "IgA57", "IgA58", "IgA59", "IgA60", "IgA61", "IgA62", "IgA63", "IgA64", "IgA65", "IgA66", "IgA67", "IgA68", "IgA69", "IgA70", "IgA71", "IgA72", "IgA73", "IgA74", "IgA75", "IgA76", "IgA77", "IgA78", "IgA79", "IgA80", "IgA81", "IgA82", "IgA83", "IgA84", "IgA85", "IgA86", "IgA87", "IgA88", "IgA89", "IgA90", "IgA91", "IgA92", "IgA93", "IgA94", "IgA95", "IgA96", "IgG1", "IgG2", "IgG3", "IgG4", "IgG5", "IgG6", "IgG7", "IgG8", "IgG9", "IgG10", "IgG11", "IgG12", "IgG13", "IgG14", "IgG15", "IgG16", "IgG17", "IgG18", "IgG19", "IgG20", "IgG21", "IgG22", "IgG23", "IgG24", "IgG25", "IgG26", "IgG27", "IgG28", "IgG29", "IgG30", "IgG31", "IgG32", "IgG33", "IgG34", "IgG35", "IgG36", "IgG37", "IgG38", "IgG39", "IgG40", "IgG41", "IgG42", "IgG43", "IgG44", "IgG45", "IgG46", "IgG47", "IgG48", "IgG49", "IgG50", "IgG51", "IgG52", "IgG53", "IgG54", "IgG55", "IgG56", "IgG57", "IgG58", "IgG59", "IgG60", "IgG61", "IgG62", "IgG63", "IgG64", "IgG65", "IgG66", "IgG67", "IgG68", "IgG69", "IgG70", "IgG71", "IgG72", "IgG73", "IgG74", "IgG75", "IgG76", "IgG77", "IgG78", "IgG79", "IgG80", "IgG81", "IgG82", "IgG83", "IgG84", "IgG85", "IgG86", "IgG87", "IgG88", "IgG89", "IgG90", "IgG91", "IgG92", "IgG93", "IgG94", "IgG95", "IgG96", "IgG97", "IgG98", "IgG99", "IgG100", "IgG101", "IgG102", "IgG103", "IgG104", "IgG105", "IgG106", "IgG107", "IgG108", "IgG109", "IgG110", "IgG111", "IgG112", "IgG113", "IgG114", "IgG115", "IgG116", "IgG117", "IgG118", "IgG119", "IgG120", "IgG121", "IgG122", "IgG123", "IgG124", "IgG125", "IgG126", "IgG127", "IgG128", "IgG129", "IgG130", "IgG131", "IgG132", "IgG133", "IgG134", "IgG135", "IgG136", "IgG137", "IgG138", "IgG139", "IgG140", "IgG141", "IgG142", "IgG143", "IgG144", "IgG145", "IgG146", "IgG147", "IgG148", "IgG149", "IgG150", "IgG151", "IgG152", "IgG153", "IgG154", "IgG155", "IgG156", "IgG157", "IgG158", "IgG159", "IgG160", "IgG161", "IgG162", "IgG163", "IgG164", "IgG165", "IgG166", "IgG167", "IgG168", "IgG169", "IgG170", "IgG171", "IgG172", "IgG173", "IgG174", "IgG175", "IgG176", "IgG177", "IgG178", "IgG179", "IgG180", "IgG181", "IgG182", "IgG183", "IgG184", "IgG185", "IgG186", "IgG187", "IgG188", "IgG189", "IgG190", "IgG191", "IgG192", "FcRn", "FcRn1", "FcRn2", "FcRn3", "FcRn4", "FcRn5", "FcRn6", "FcRn7", "FcRn8", "FcRn9", "FcRn10", "FcRn11", "FcRn12", "FcRn13", "FcRn14", "FcRn15", "FcRn16", "FcRn17", "FcRn18", "FcRn19", "FcRn20", "FcRn21", "FcRn22", "FcRn23", "FcRn24", "FcRn25", "FcRn26", "FcRn27", "FcRn28", "FcRn29", "FcRn30", "FcRn31", "FcRn32", "FcRn33", "FcRn34", "FcRn35", "FcRn36", "FcRn37", "FcRn38", "FcRn39", "FcRn40", "FcRn41", "FcRn42", "FcRn43", "FcRn44", "FcRn45", "FcRn46", "FcRn47", "FcgR3A", "FcgR3A1", "FcgR3A2", "FcgR3A3", "FcgR3A4", "FcgR3A5", "FcgR3A6", "FcgR3A7", "FcgR3A8", "FcgR3A9", "FcgR3A10", "FcgR3A11", "FcgR3A12", "FcgR3A13", "FcgR3A14", "FcgR3A15", "FcgR3A16", "FcgR3A17", "FcgR3A18", "FcgR3A19", "FcgR3A20", "FcgR3A21", "FcgR3A22", "FcgR3A23", "FcgR3A24", "FcgR3A25", "FcgR3A26", "FcgR3A27", "FcgR3A28", "FcgR3A29", "FcgR3A30", "FcgR3A31", "FcgR3A32", "FcgR3A33", "FcgR3A34", "FcgR3A35", "FcgR3A36", "FcgR3A37", "FcgR3A38", "FcgR3A39", "FcgR3A40", "FcgR3A41", "FcgR3A42", "FcgR3A43", "FcgR3A44", "FcgR3A45", "FcgR3A46", "FcgR3A47", "FcgR3b", "FcgR3b1", "FcgR3b2", "FcgR3b3", "FcgR3b4", "FcgR3b5", "FcgR3b6", "FcgR3b7", "FcgR3b8", "FcgR3b9", "FcgR3b10", "FcgR3b11", "FcgR3b12", "FcgR3b13", "FcgR3b14", "FcgR3b15", "FcgR3b16", "FcgR3b17", "FcgR3b18", "FcgR3b19", "FcgR3b20", "FcgR3b21", "FcgR3b22", "FcgR3b23", "FcgR3b24", "FcgR3b25", "FcgR3b26", "FcgR3b27", "FcgR3b28", "FcgR3b29", "FcgR3b30", "FcgR3b31", "FcgR3b32", "FcgR3b33", "FcgR3b34", "FcgR3b35", "FcgR3b36", "FcgR3b37", "FcgR3b38", "FcgR3b39", "FcgR3b40", "FcgR3b41", "FcgR3b42", "FcgR3b43", "FcgR3b44", "FcgR3b45", "FcgR3b46", "FcgR3b47", "FcgR2A", "FcgR2A1", "FcgR2A2", "FcgR2A3", "FcgR2A4", "FcgR2A5", "FcgR2A6", "FcgR2A7", "FcgR2A8", "FcgR2A9", "FcgR2A10", "FcgR2A11", "FcgR2A12", "FcgR2A13", "FcgR2A14", "FcgR2A15", "FcgR2A16", "FcgR2A17", "FcgR2A18", "FcgR2A19", "FcgR2A20", "FcgR2A21", "FcgR2A22", "FcgR2A23", "FcgR2A24", "FcgR2A25", "FcgR2A26", "FcgR2A27", "FcgR2A28", "FcgR2A29", "FcgR2A30", "FcgR2A31", "FcgR2A32", "FcgR2A33", "FcgR2A34", "FcgR2A35", "FcgR2A36", "FcgR2A37", "FcgR2A38", "FcgR2A39", "FcgR2A40", "FcgR2A41", "FcgR2A42", "FcgR2A43", "FcgR2A44", "FcgR2A45", "FcgR2A46", "FcgR2A47", "FcgR2b", "FcgR2b1", "FcgR2b2", "FcgR2b3", "FcgR2b4", "FcgR2b5", "FcgR2b6", "FcgR2b7", "FcgR2b8", "FcgR2b9", "FcgR2b10", "FcgR2b11", "FcgR2b12", "FcgR2b13", "FcgR2b14", "FcgR2b15", "FcgR2b16", "FcgR2b17", "FcgR2b18", "FcgR2b19", "FcgR2b20", "FcgR2b21", "FcgR2b22", "FcgR2b23", "FcgR2b24", "FcgR2b25", "FcgR2b26", "FcgR2b27", "FcgR2b28", "FcgR2b29", "FcgR2b30", "FcgR2b31", "FcgR2b32", "FcgR2b33", "FcgR2b34", "FcgR2b35", "FcgR2b36", "FcgR2b37", "FcgR2b38", "FcgR2b39", "FcgR2b40", "FcgR2b41", "FcgR2b42", "FcgR2b43", "FcgR2b44", "FcgR2b45", "FcgR2b46", "FcgR2b47"];
opts.VariableTypes = ["string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify variable properties
% opts = setvaropts(opts, ["VarName2", "timepoint"], "WhitespaceRule", "preserve");
% opts = setvaropts(opts, ["VarName2", "timepoint"], "EmptyFieldRule", "auto");

pbdata = readtable("190203 Petter Brodin data file_SD_corrected.xlsx",opts);
pbdata(1:96,3:end) = array2table(table2array(pbdata(1:96,3:end)) - table2array(pbdata(97,3:end)));
pbdata_array = table2array(pbdata(:,3:end)); pbdata_array = max(pbdata_array,0);
pbdata(:,3:end) = array2table(pbdata_array);

ag = ["measles","mumps","rubella","pertussis toxin","influenza","VZV","polio","HepA","pneumo","Adeno T5","Adeno T40",...
    "Norovirus","Parvo VP2","tetanus","Diptheria","HSV 1","HSV 2","CMV","EBV","RSV","Human Histone H3","nArah2","nBosd8","nBetv1"];	
%prepare timepoints
times = regexprep(table2array(pbdata(:,1:2)),{'w'},{''});
times_baby = [times(strcmp(times(:,2),'0'),:);times(strcmp(times(:,2),'1'),:);times(strcmp(times(:,2),'4'),:);times(strcmp(times(:,2),'12'),:)];
times_mom = [times(strcmp(times(:,2),'mother(0)'),:);times(strcmp(times(:,2),'mother(12)'),:)];

%% %% extract mom cord w0

mom.total = sortrows(pbdata(strcmp(pbdata.timepoint,'mother(w0)'),:),'VarName2');
baby.total = sortrows(pbdata(strcmp(pbdata.timepoint,'w0'),:),'VarName2');
[Atrain,I]=intersect(mom.total.VarName2,baby.total.VarName2);
% I = I([1:13,15:18]); %take out outlier sample
mom.totigg_old = mom.total(I,[1,2,25:72]);
baby.totigg_old = baby.total(:,[1,2,25:72]);
mom.igg1_old = mom.total(I,[1,2,217:264]);
baby.igg1_old = baby.total(:,[1,2,217:264]);
mom.igg2_old = mom.total(I,[1,2,265:312]);
baby.igg2_old = baby.total(:,[1,2,265:312]);
mom.igg3_old = mom.total(I,[1,2,313:360]);
baby.igg3_old = baby.total(:,[1,2,313:360]);
mom.igg4_old = mom.total(I,[1,2,361:408]);
baby.igg4_old = baby.total(:,[1,2,361:408]);

clear mom.totigg baby.totigg mom.igg1 baby.igg1 mom.igg2 baby.igg2 mom.igg3 baby.igg3 mom.igg4 baby.igg4
% Average technical duplicates
for i = 3:2:width(mom.totigg_old)
mom.totigg(:,i) = mean(table2array(mom.totigg_old(:,[i i+1])),2);
baby.totigg(:,i) = mean(table2array(baby.totigg_old(:,[i i+1])),2);
mom.igg1(:,i) = mean(table2array(mom.igg1_old(:,[i i+1])),2);
baby.igg1(:,i) = mean(table2array(baby.igg1_old(:,[i i+1])),2);
mom.igg2(:,i) = mean(table2array(mom.igg2_old(:,[i i+1])),2);
baby.igg2(:,i) = mean(table2array(baby.igg2_old(:,[i i+1])),2);
mom.igg3(:,i) = mean(table2array(mom.igg3_old(:,[i i+1])),2);
baby.igg3(:,i) = mean(table2array(baby.igg3_old(:,[i i+1])),2);
mom.igg4(:,i) = mean(table2array(mom.igg4_old(:,[i i+1])),2);
baby.igg4(:,i) = mean(table2array(baby.igg4_old(:,[i i+1])),2);
end
%[1:13,15:18]
mom.totigg = mom.totigg(:,any(mom.totigg,1));
baby.totigg = baby.totigg(:,any(baby.totigg,1));

mom.igg1 = mom.igg1(:,any(mom.igg1,1));
baby.igg1 = baby.igg1(:,any(baby.igg1,1));

mom.igg2 = mom.igg2(:,any(mom.igg2,1));
baby.igg2 = baby.igg2(:,any(baby.igg2,1));

mom.igg3 = mom.igg3(:,any(mom.igg3,1));
baby.igg3 = baby.igg3(:,any(baby.igg3,1));

mom.igg4 = mom.igg4(:,any(mom.igg4,1));
baby.igg4 = baby.igg4(:,any(baby.igg4,1));

allsamples.totigg = [mom.totigg;baby.totigg];
allsamples.igg1 = [mom.igg1;baby.igg1];
allsamples.igg2 = [mom.igg2;baby.igg2];
allsamples.igg3 = [mom.igg3;baby.igg3];
allsamples.igg4 = [mom.igg4;baby.igg4];

%% call ag estimate
cd('C:\Users\remzi\Box\Remziye Erdogan share\Data and Analysis\MATLAB scripts\general scripts')
agEstimate(baby,mom,0.6,ag)
return
%% build LSQ model
%% add a constraint that alpha > 0 
fun = @(x,A) A*x; lb = [0 0 0 0]'; x0 = [1 1 1 1]';
figure(1); figure(2);
lsqopts.FunctionTolerance=1e-10;
lsqopts.Diagnostic='on';
 close all
 b = zeros(length(allsamples.igg1(:,1)),1);
CVP = cvpartition(length(b),'LeaveOut');
for j = 1:length(ag)
    clear Atrain Atest A b b_fit
    b_fit = zeros(1,length(allsamples.igg1(:,1))); 
%     for i = 1:CVP.NumTestSets
%         train = CVP.training(i); test = CVP.test(i);

%         Atrain = [allsamples.igg1(train,j) allsamples.igg2(train,j) allsamples.igg3(train,j) allsamples.igg4(train,j)];
%         Atest = [allsamples.igg1(test,j) allsamples.igg2(test,j) allsamples.igg3(test,j) allsamples.igg4(test,j)];
        A = [allsamples.igg1(:,j) allsamples.igg2(:,j) allsamples.igg3(:,j) allsamples.igg4(:,j)];
        b = allsamples.totigg(:,j);
%         alpha_all(:,j) = lsqcurvefit(fun,x0,A,b,lb,[],lsqopts);
%         b_fit(test) = (Atest*alpha_all(:,j));
%     end
%         A = [baby.igg1(:,j) baby.igg2(:,j) baby.igg3(:,j) baby.igg4(:,j)];
%         b = baby.totigg(:,j);
        
    alpha_all(:,j) = lsqcurvefit(fun,x0,A,b,lb,[],lsqopts);
    b_fit = (A*alpha_all(:,j));
%
    [rho,p] = corrcoef([b_fit b]); rho_sq = rho.*rho; R_sq(j) = rho_sq(1,2);
    figure(1); subplot(4,6,j); 
    plot(linspace(0,max(b)),linspace(0,max(b)),'b-','handlevisibility','off','linewidth',1.5); hold on
    plot(b(1:17),b_fit(1:17),'kx','linewidth',1.5); plot(b(18:end),b_fit(18:end),'ko','linewidth',1.5);
    xlabel('Total IgG'); ylabel('Total IgG (fit)')
    title(append(string(ag(j)),':  R^2 = ',string(round(10^2*R_sq(j))/10^2))); %lsline;
    pval(j) = p(1,2);
    stdev(j) = std(b_fit);
end

legend('Maternal','Cord')
% goodagidx = [2,4,5:9,12:19,21:24];
% goodag = ag(goodagidx);

goodag = ag(R_sq>0.6);
[~,~,goodagidx] = intersect(goodag,ag,'stable');
% goodag = ag;
% goodagidx = 1:24;
%% estimation of subclass proportions and transfer ratios given alpha
frac.mom.igg1 = alpha_all(1,goodagidx).*mom.igg1(:,goodagidx)./mom.totigg(:,goodagidx);
frac.mom.igg2 = alpha_all(2,goodagidx).*mom.igg2(:,goodagidx)./mom.totigg(:,goodagidx);
frac.mom.igg3 = alpha_all(3,goodagidx).*mom.igg3(:,goodagidx)./mom.totigg(:,goodagidx);
frac.mom.igg4 = alpha_all(4,goodagidx).*mom.igg4(:,goodagidx)./mom.totigg(:,goodagidx);
% 
frac.baby.igg1 = alpha_all(1,goodagidx).*baby.igg1(:,goodagidx)./baby.totigg(:,goodagidx);
frac.baby.igg2 = alpha_all(2,goodagidx).*baby.igg2(:,goodagidx)./baby.totigg(:,goodagidx);
frac.baby.igg3 = alpha_all(3,goodagidx).*baby.igg3(:,goodagidx)./baby.totigg(:,goodagidx);
frac.baby.igg4 = alpha_all(4,goodagidx).*baby.igg4(:,goodagidx)./baby.totigg(:,goodagidx);

ratio.igg1 = alpha_all(1,goodagidx).*baby.igg1(:,goodagidx)./mom.igg1(:,goodagidx); ratio.igg1(isinf(ratio.igg1)|isnan(ratio.igg1))=0;
ratio.igg2 = alpha_all(1,goodagidx).*baby.igg2(:,goodagidx)./mom.igg2(:,goodagidx); ratio.igg2(isinf(ratio.igg2)|isnan(ratio.igg2))=0;
ratio.igg3 = alpha_all(1,goodagidx).*baby.igg3(:,goodagidx)./mom.igg3(:,goodagidx); ratio.igg3(isinf(ratio.igg3)|isnan(ratio.igg3))=0;
ratio.igg4 = alpha_all(1,goodagidx).*baby.igg4(:,goodagidx)./mom.igg4(:,goodagidx); ratio.igg4(isinf(ratio.igg4)|isnan(ratio.igg4))=0;

%% bar plots
frac.mom.combined = [median(frac.mom.igg1,'omitnan')' median(frac.mom.igg2,'omitnan')'...
    median(frac.mom.igg3,'omitnan')' median(frac.mom.igg4,'omitnan')'];

frac.baby.combined = [median(frac.baby.igg1,'omitnan')' median(frac.baby.igg2,'omitnan')'...
    median(frac.baby.igg3,'omitnan')' median(frac.baby.igg4,'omitnan')'];

for i = 1:height(frac.baby.combined)
 frac.baby.combined(i,:) = frac.baby.combined(i,:) / sum(frac.baby.combined(i,:));
end

for i = 1:height(frac.mom.combined)
 frac.mom.combined(i,:) = frac.mom.combined(i,:) / sum(frac.mom.combined(i,:));
end

frac.ratio = frac.baby.combined./frac.mom.combined;

figure; subplot(2,1,1)
b = bar(frac.mom.combined,'stacked','facecolor','flat')
b(1).CData = [0.5 0.11 0.8];b(2).CData =  [0.22 0.81 0.90];
b(3).CData = [0.086 0.6 0.086];b(4).CData =  [0.82 0.427 0.82];
ylim([0 1.25]); legend('IgG1','IgG2','IgG3','IgG4','location','eastoutside')
xticks([1:18]); xticklabels(goodag); xtickangle(45); title('Maternal Ag-specific IgG Subclass Proportions (normalized)')
subplot(2,1,2)
b = bar(frac.baby.combined,'stacked','facecolor','flat')
b(1).CData = [0.5 0.11 0.8]; b(2).CData =  [0.22 0.81 0.90];
b(3).CData = [0.086 0.6 0.086]; b(4).CData =  [0.82 0.427 0.82];
ylim([0 1.25]); legend('IgG1','IgG2','IgG3','IgG4','location','eastoutside')
xticks([1:18]); xticklabels(goodag); xtickangle(45); title('Cord Blood Ag-specific IgG Subclass Proportions (normalized)')
% subplot(3,1,3)
% bar(frac.ratio)
% ylim([0 1.25]); legend('IgG1','IgG2','IgG3','IgG4','location','eastoutside')
% xticks([1:24]); xticklabels(ag); xtickangle(45); title('Cord:Maternal Ratios')

% plot(frac.mom.igg1(:,idx)'+4,'-','color','#801CCC'); hold on; grid on; plot(median(frac.mom.igg1(:,idx))'+4,'k-','linewidth',2)
% plot(frac.mom.igg2(:,idx)'+3,'-','color','#38CEE6'); plot(median(frac.mom.igg2(:,idx))'+3,'k-','linewidth',2)
% plot(frac.mom.igg3(:,idx)'+2,'-','color','#169916'); plot(median(frac.mom.igg3(:,idx))'+2,'k-','linewidth',2)
% plot(frac.mom.igg4(:,idx)'+1,'-','color','#D16DD1'); plot(median(frac.mom.igg4(:,idx))'+1,'k-','linewidth',2)

%% plot averages
[a,idx]=sort(median(frac.mom.igg1+frac.mom.igg2+frac.mom.igg3+frac.mom.igg4),2,'descend');

figure
plot(frac.mom.igg1(:,idx)'+4,'-','color','#801CCC'); hold on; grid on; plot(median(frac.mom.igg1(:,idx))'+4,'k-','linewidth',2)
plot(frac.mom.igg2(:,idx)'+3,'-','color','#38CEE6'); plot(median(frac.mom.igg2(:,idx))'+3,'k-','linewidth',2)
plot(frac.mom.igg3(:,idx)'+2,'-','color','#169916'); plot(median(frac.mom.igg3(:,idx))'+2,'k-','linewidth',2)
plot(frac.mom.igg4(:,idx)'+1,'-','color','#D16DD1'); plot(median(frac.mom.igg4(:,idx))'+1,'k-','linewidth',2)
yticks([1:4]); yticklabels(['IgG4';'IgG3';'IgG2';'IgG1']); xtickangle(30);ylim([1 6])
xticks([1:19]); xticklabels(goodag(idx)); title('Least squares estimate of maternal IgG subclass proportions')
ax = gca; ax.FontSize = 14;

figure
plot(frac.baby.igg1(:,idx)'+4,'-','color','#801CCC'); hold on; grid on; plot(median(frac.baby.igg1(:,idx))'+4,'k-','linewidth',2)
plot(frac.baby.igg2(:,idx)'+3,'-','color','#38CEE6'); plot(median(frac.baby.igg2(:,idx))'+3,'k-','linewidth',2)
plot(frac.baby.igg3(:,idx)'+2,'-','color','#169916'); plot(median(frac.baby.igg3(:,idx))'+2,'k-','linewidth',2)
plot(frac.baby.igg4(:,idx)'+1,'-','color','#D16DD1'); plot(median(frac.baby.igg4(:,idx))'+1,'k-','linewidth',2)
yticks([1:4]); yticklabels(['IgG4';'IgG3';'IgG2';'IgG1']); xtickangle(30);ylim([1 6])
xticks([1:19]); xticklabels(goodag(idx)); title('Least squares estimate of cord blood IgG subclass proportions')
ax = gca; ax.FontSize = 14;

figure
plot(median(log2(ratio.igg1(:,idx)))','-o','linewidth',2,'color','#801CCC'); hold on; grid on; %plot(ratio.igg1(:,idx)'+4,'c-'); 
plot(median(log2(ratio.igg2(:,idx)))','-o','linewidth',2,'color','#38CEE6');  %plot(ratio.igg2(:,idx)'+3,'r-'); 
plot(median(log2(ratio.igg3(:,idx)))','-o','linewidth',2,'color','#169916'); %plot(ratio.igg3(:,idx)'+2,'g-'); 
plot(median(log2(ratio.igg4(:,idx)))','-o','linewidth',2,'color','#D16DD1'); %plot(ratio.igg4(:,idx)'+1,'m-'); 
ylabel('Log_2(IgG Transfer Ratio)')% yticks([1:4]); yticklabels(['IgG4';'IgG3';'IgG2';'IgG1'])
xticks([1:19]); xticklabels(goodag(idx)); xtickangle(30); title('Least squares estimate of IgG Transfer Ratios')
ax = gca; ax.FontSize = 14; legend('IgG1','IgG2','IgG3','IgG4')

%% plot the log2 transformed transfer ratios (goodagidx)
log2ratio.igg1 = log2(baby.igg1(:,goodagidx)./mom.igg1(:,goodagidx)); log2ratio.igg1(isinf(log2ratio.igg1)|isnan(log2ratio.igg1))=0;
log2ratio.igg2 = log2(baby.igg2(:,goodagidx)./mom.igg2(:,goodagidx)); log2ratio.igg2(isinf(log2ratio.igg2)|isnan(log2ratio.igg2))=0;
log2ratio.igg3 = log2(baby.igg3(:,goodagidx)./mom.igg3(:,goodagidx)); log2ratio.igg3(isinf(log2ratio.igg3)|isnan(log2ratio.igg3))=0;
log2ratio.igg4 = log2(baby.igg4(:,goodagidx)./mom.igg4(:,goodagidx)); log2ratio.igg4(isinf(log2ratio.igg4)|isnan(log2ratio.igg4))=0;

figure; subplot(2,2,1); Mycolor = [0.5 0.11 0.8];
Color = repmat(Mycolor',1,length(goodag));
vs = violinplot_SD(log2ratio.igg1,goodag,'ViolinColor',Color'); 
hold on; yline(0,'--'); ylabel('Log_2(IgG1 Transfer Ratio)'); ylim([-3 3])
subplot(2,2,2); Mycolor = [0.22 0.81 0.90];
Color = repmat(Mycolor',1,length(goodag));
vs = violinplot_SD(log2ratio.igg2,goodag,'ViolinColor',Color'); 
hold on; yline(0,'--'); ylabel('Log_2(IgG2 Transfer Ratio)'); ylim([-3 3])
subplot(2,2,3); Mycolor = [0.086 0.6 0.086];
Color = repmat(Mycolor',1,length(goodag));
vs = violinplot_SD(log2ratio.igg3,goodag,'ViolinColor',Color'); 
hold on; yline(0,'--'); ; ylabel('Log_2(IgG3 Transfer Ratio)'); ylim([-3 3])
subplot(2,2,4); Mycolor =  [0.82 0.427 0.82];
Color = repmat(Mycolor',1,length(goodag));
vs = violinplot_SD(log2ratio.igg4,goodag,'ViolinColor',Color'); 
hold on; yline(0,'--'); ylabel('Log_2(IgG4 Transfer Ratio)'); ylim([-3 3])

%% plot transfer ratios for all ag, all patients , per subclass
%% HERE
figure(4)

subplot(2,2,1)
scatter(frac.mom.igg1*100,log2(ratio.igg1(:,goodagidx)),50,'.','markeredgecolor',[0.5 0.11 0.8]); hold on
xlim([0 100]); xlabel('Mat. Subclass Abundance (%)'); ylabel('Log2(Ratio)'); legend('IgG1')
subplot(2,2,2)
scatter(frac.mom.igg2*100,log2(ratio.igg2(:,goodagidx)),50,'.','markeredgecolor',[0.22 0.81 0.90])
xlim([0 100]); xlabel('Mat. Subclass Abundance (%)'); ylabel('Log2(Ratio)'); legend('IgG2')
subplot(2,2,3)
scatter(frac.mom.igg3*100,log2(ratio.igg3(:,goodagidx)),50,'.','markeredgecolor',[0.086 0.6 0.086])
xlim([0 100]); xlabel('Mat. Subclass Abundance (%)'); ylabel('Log2(Ratio)'); legend('IgG3')
subplot(2,2,4)
scatter(frac.mom.igg4*100,log2(ratio.igg4(:,goodagidx)),50,'.','markeredgecolor',[0.82 0.427 0.82])
xlim([0 100]); xlabel('Mat. Subclass Abundance (%)'); ylabel('Log2(Ratio)'); legend('IgG4')
%% validate that most proportions add to 1, and that by summing across Ag-specificities we see IgG1>IgG2>IgG3>IgG4
mean(sum(frac.baby.combined,2))
approx_igg_subclass = sum(frac.mom.combined,1)
approx_igg_subclass(:,1)./sum(approx_igg_subclass)
approx_igg_subclass(:,2)./sum(approx_igg_subclass)
approx_igg_subclass(:,3)./sum(approx_igg_subclass)
approx_igg_subclass(:,4)./sum(approx_igg_subclass)

%% Plotting probability distributions of transfer ratios across subclasses and antigen specificities
% calculate transfer ratios
ratio.total = baby.totigg./mom.totigg; ratio.total(isinf(ratio.total)|isnan(ratio.total))=0;
ratio.igg1 = baby.igg1./mom.igg1; ratio.igg1(isinf(ratio.igg1)|isnan(ratio.igg1))=0;
ratio.igg2 = baby.igg2./mom.igg2; ratio.igg2(isinf(ratio.igg2)|isnan(ratio.igg2))=0;
ratio.igg3 = baby.igg3./mom.igg3; ratio.igg3(isinf(ratio.igg3)|isnan(ratio.igg3))=0;
ratio.igg4 = baby.igg4./mom.igg4; ratio.igg4(isinf(ratio.igg4)|isnan(ratio.igg4))=0;

ratio.combined = [median(ratio.igg1,'omitnan')' median(ratio.igg2,'omitnan')'...
    median(ratio.igg3,'omitnan')' median(ratio.igg4,'omitnan')' median(ratio.total,'omitnan')'];

x=linspace(0,5,100);
figure
for n = 1:length(ag)
    subplot(4,6,n); 
    pd = makedist('normal','mu',mean(ratio.total(:,n)),'sigma',std(ratio.total(:,n)));
    y=pdf(pd,x); plot(x,y,'linewidth',2,'color','k'); hold on; ylim([0 1.1*max(y)])
    plot(ones(1,100),linspace(0,1.1*max(y),100),'k-','linewidth',0.75,'handlevisibility','off'); 
    pd = makedist('normal','mu',mean(ratio.igg1(:,n)),'sigma',std(ratio.igg1(:,n)));
    y=pdf(pd,x); plot(x,y,'linewidth',2,'color','#801CCC');
    pd = makedist('normal','mu',mean(ratio.igg2(:,n)),'sigma',std(ratio.igg2(:,n)));
    y=pdf(pd,x); plot(x,y,'linewidth',2,'color','#38CEE6');
    pd = makedist('normal','mu',mean(ratio.igg3(:,n)),'sigma',std(ratio.igg3(:,n)));
    y=pdf(pd,x); plot(x,y,'linewidth',2,'color','#169916');
    pd = makedist('normal','mu',mean(ratio.igg4(:,n)),'sigma',std(ratio.igg4(:,n)));
    y=pdf(pd,x); plot(x,y,'linewidth',2,'color','#D16DD1');
    
%     histogram(ratio.total(:,n),'BinMethod','fd');hold on
%     histogram(ratio.igg1(:,n),'BinMethod','fd'); 
%     histogram(ratio.igg2(:,n),'BinMethod','fd');
%     histogram(ratio.igg3(:,n),'BinMethod','fd');
%     histogram(ratio.igg4(:,n),'BinMethod','fd');
    title(ag(n),'fontsize',12); xlabel('F:M Ratio'); ylabel('Probability')
end
legend('IgG_{tot}','IgG1','IgG2','IgG3','IgG4')

%% old
%% plot the log2 transformed transfer ratios (all)
log2ratio.igg1 = log2(baby.igg1(goodagidx)./mom.igg1(goodagidx)); log2ratio.igg1(isinf(log2ratio.igg1)|isnan(log2ratio.igg1))=0;
log2ratio.igg2 = log2(baby.igg2(goodagidx)./mom.igg2(goodagidx)); log2ratio.igg2(isinf(log2ratio.igg2)|isnan(log2ratio.igg2))=0;
log2ratio.igg3 = log2(baby.igg3(goodagidx)./mom.igg3(goodagidx)); log2ratio.igg3(isinf(log2ratio.igg3)|isnan(log2ratio.igg3))=0;
log2ratio.igg4 = log2(baby.igg4(goodagidx)./mom.igg4(goodagidx)); log2ratio.igg4(isinf(log2ratio.igg4)|isnan(log2ratio.igg4))=0;

figure
subplot(2,2,1); plot(log2ratio.igg1','color','#801CCC'); hold on; grid on; plot(median(log2ratio.igg1)','-','linewidth',2,'color','k');  
plot([0:25],zeros(1,26),'k-','handlevisibility','off');xticks([1:24]); xticklabels(ag); xtickangle(30); ax = gca; ax.FontSize = 14;ylabel('Log_2(IgG1 Transfer Ratio)')
subplot(2,2,2); plot(log2ratio.igg2','color','#38CEE6'); hold on; grid on; plot(median(log2ratio.igg2)','-','linewidth',2,'color','k'); 
plot([0:25],zeros(1,26),'k-','handlevisibility','off');xticks([1:24]); xticklabels(ag); xtickangle(30); ax = gca; ax.FontSize = 14;ylabel('Log_2(IgG2 Transfer Ratio)')
subplot(2,2,3); plot(log2ratio.igg3','color','#169916'); hold on; grid on; plot(median(log2ratio.igg3)','-','linewidth',2,'color','k'); hold on; grid on; 
plot([0:25],zeros(1,26),'k-','handlevisibility','off');xticks([1:24]); xticklabels(ag); xtickangle(30); ax = gca; ax.FontSize = 14;ylabel('Log_2(IgG3 Transfer Ratio)')
subplot(2,2,4); plot(log2ratio.igg4','color','#D16DD1'); hold on; grid on; plot(median(log2ratio.igg4)','-','linewidth',2,'color','k'); hold on; grid on; 
plot([0:25],zeros(1,26),'k-','handlevisibility','off');xticks([1:24]); xticklabels(ag); xtickangle(30); ax = gca; ax.FontSize = 14;ylabel('Log_2(IgG4 Transfer Ratio)')
% yticks([1:4]); yticklabels(['IgG4';'IgG3';'IgG2';'IgG1'])
%title('Median IgG Transfer Ratios'); xlim([0 25])
 %legend('IgG1','IgG2','IgG3','IgG4')
 %%
figure
subplot(2,3,1)
bar(ratio.combined(:,5)); hold on; yline(1,'--')
ylim([0 1.25]); xticks([1:24]); xticklabels(ag); xtickangle(45); title('Total IgG'); ylabel('F:M Ratio')
subplot(2,3,2)
bar(ratio.combined(:,1)); hold on; yline(1,'--')
ylim([0 1.25]); xticks([1:24]); xticklabels(ag); xtickangle(45); title('IgG1'); ylabel('F:M Ratio')
subplot(2,3,3)
bar(ratio.combined(:,2)); hold on; yline(1,'--')
ylim([0 1.25]); xticks([1:24]); xticklabels(ag); xtickangle(45); title('IgG2'); ylabel('F:M Ratio')
subplot(2,3,4)
bar(ratio.combined(:,3)); hold on; yline(1,'--')
ylim([0 1.25]); xticks([1:24]); xticklabels(ag); xtickangle(45); title('IgG3'); ylabel('F:M Ratio')
subplot(2,3,5)
bar(ratio.combined(:,4)); hold on; yline(1,'--')
ylim([0 1.25]); xticks([1:24]); xticklabels(ag); xtickangle(45); title('IgG4'); ylabel('F:M Ratio')

figure
bar(ratio.combined(:,[1:4])); hold on; yline(1,'--','handlevisibility','off')
ylim([0 3.1]); xticks([1:24]); xticklabels(ag); xtickangle(45); ylabel('F:M Ratio'); 
hold on; plot([1:length(ag)],ratio.combined(:,5),'kx','linewidth',1.2); legend('IgG1','IgG2','IgG3','IgG4','Total IgG')

%% parallel coordinate plots
% [~,idx]=sort(mean(frac.mom.igg1),2,'descend');

alligg = [frac.mom.igg1(:,idx);frac.mom.igg2(:,idx);frac.mom.igg3(:,idx);frac.mom.igg4(:,idx)];
whichigg = [ones(18,1);2*ones(18,1);3*ones(18,1);4*ones(18,1)];
figure
parallelcoords(alligg,'group',whichigg,'standardize','on','labels',...
    string(ag(idx)),'quantile',0.25,'linewidth',2)
% parallelcoords(frac.mom.igg1,'standardize','on','labels',string(ag(idx)))

%% train using just maternal or cord data
    % Maternal IgG normalized by total IgG
%     A = [mom.igg1(:,j) mom.igg2(:,j) mom.igg3(:,j) mom.igg4(:,j)];%./mom.totigg(:,j);
%     b = mom.totigg(:,j);
%     alpha_mom(:,j) = lsqcurvefit(fun,x0,A,b,lb,[],lsqopts);
%     b_fit = A*alpha_mom(:,j);
%     R_sq_mom(j) = 1-var(b-b_fit)/var(b);
%     SStot = sum((b-mean(b)).^2);                            % Total Sum-Of-Squares
%     SSres = sum((b(:)-b_fit(:)).^2);                         % Residual Sum-Of-Squares
%     Rsq_mom(j) = 1-SSres/SStot; 

% figure(1); subplot(4,6,j)
% plot(b,b_fit,'.');hold on; xlabel('Total IgG'); ylabel('Total IgG (fit)')
% plot(linspace(0,max(b)),linspace(0,max(b)),'r-')
% title(append(string(ag(j)),':  R^2 = ',string(R_sq_mom(j)))); %lsline;
% 
    % Cord blood IgG normalized by total IgG
%     A = [baby.igg1(:,j) baby.igg2(:,j) baby.igg3(:,j) baby.igg4(:,j)];%./mom.totigg(:,j);
%     b = baby.totigg(:,j);
%     alpha_baby(:,j) = lsqcurvefit(fun,x0,A,b,lb,[],lsqopts);
%     b_fit = A*alpha_baby(:,j);
%     R_sq_baby(j) = 1-var(b-b_fit)/var(b);
    
%     figure(2); subplot(4,6,j)
%     plot(b,b_fit,'.');hold on; xlabel('Total IgG'); ylabel('Total IgG (fit)')
%     plot(linspace(0,max(b)),linspace(0,max(b)),'r-')
%     title(append(string(ag(j)),':  R^2 = ',string(R_sq_baby(j)))); %lsline;