% This code generates the layout for via 5 in the solid shieldings using 
% the inner shield mask from HFSS to have clearance for the vias away from 
% the edges (DRC) and a bbox mask and the mask of via fillings on layer 5
%

clear all
close all
clc

location = 'IN_OUT/';
glib1_filename = 'HRO_InnerShields_HFSS';
glib2_filename = 'z_M5via_mask_5x5_Grid_Fill'; % This is tricky 
glib3_filename = 'HRO_bbox_HFSS';   
% use bbox form HFSS to have the same reference for the blocks

output_filename = 'HRO_Shieldsvia5_CAD';
Cell_name = 'HRO_Shieldsvia5';

[in_glib] = read_gds_library(strcat(location,glib1_filename,'.gds'));
[block_glib] = read_gds_library(strcat(location,glib2_filename,'.gds'));
[bbox_glib] = read_gds_library(strcat(location,glib3_filename,'.gds'));

uunit  = get(in_glib,'uunit' );
dbunit = get(in_glib,'dbunit');
units = uunit/dbunit;
gdsii_units(uunit, dbunit);

%% Create the output gds library 
Output_glib = gds_library('z_MATLAB','uunit',uunit, 'dbunit',dbunit);

%% Discretize to the needed grid > minGrid(for M8) and > minWidth for the rest
in_gstr = GDS_Discretize_gstr(in_glib(1),100,units);

bbox_gstr = bbox_glib(1); 
block_gstr = block_glib(1);
block_metals = gds_structure('MATLAB');
block_vias = gds_structure('MATLAB');
for idx=1:length(block_gstr(:))
    if(layer(block_gstr(idx)) == 35 | layer(block_gstr(idx)) == 36 )
        block_metals(1+end) = block_gstr(idx);
    else
        block_vias(1+end) = block_gstr(idx);
    end
end

%%
figure
GDS_plot(in_gstr,'-'),hold on
GDS_plot(block_gstr,'-'),hold on
GDS_plot(bbox_gstr,'-'),hold on

%% Create Mosaic of the block to find intersections later
    Mosaic.b = [5 5];
    Mosaic.d = [0 0];
    Mosaic.e = [0 0];

    block_gelm = GDS_Create_box(Mosaic.b,[0 0]);
    [RC,Center] = GDS_Mosaic_calc(bbox_gstr(1),Mosaic);
    Mosaic_gstr = GDS_Mosaic(block_gelm,Mosaic,RC,Center);
    
    figure
    GDS_plot(Mosaic_gstr,'k-'),hold on
    GDS_plot(bbox_gstr(1),'r-.')   
%%    
% find the blocks that intersects with the shield mask then replace it with
% the basic block 

inter_Mosaic_gstr = GDS_Mosaic_intersections(in_gstr,Mosaic_gstr,units);
inter_Mosaic_gstr = inter_Mosaic_gstr{1};

inter_Mosaic_gstr = GDS_Discretize_gstr(inter_Mosaic_gstr,2500,units);

figure
GDS_plot(inter_Mosaic_gstr,'k-'),hold on
GDS_plot(bbox_gstr(1),'r-.') 

%% replace elements of inter_gstr with block_metal and block_via
inter_metals_gstr = {};
inter_via_gstr = {};

for idx = 1:length(inter_Mosaic_gstr(:))
    box = bbox(inter_Mosaic_gstr(idx));
    center = [mean([box(1) box(3)])  mean([box(2) box(4)])];
    inter_metals_gstr(1+end) = {GDS_Shift(block_metals,center)};
    inter_via_gstr(1+end) = {GDS_Shift(block_vias,center)};
end

figure
GDS_plot(in_gstr,'k-'),hold on
GDS_plot(inter_metals_gstr,'r-.') 

%% This will find the intersections for Metals and it will take few minutes 
output_Metal_gstr = GDS_MATH(inter_metals_gstr,in_gstr,'and',units);

figure
GDS_plot(output_Metal_gstr,'-')
%% This will find the intersections for vias and it will take few minutes 
output_vias_gstr = GDS_MATH(inter_via_gstr,in_gstr,'and',units);

figure
GDS_plot(output_vias_gstr,'-')

%%
str = {"VIAz_box" "VIA5_layer"};
info = GDS_ST55(str{1});
VIAs_gstr_checked = GDS_checkvias(output_vias_gstr,info.b);
figure
GDS_plot(VIAs_gstr_checked,'-')
%% Discretize everything to account for the stupid polyboolmex function

DMetals = GDS_Discretize_gstr(output_Metal_gstr,20,units);
DVias = GDS_Discretize_gstr(VIAs_gstr_checked,20,units);

%%

clear ogstr
ogstr = {};

ogstr(1+end) = {GDS_reset(DMetals,GDS_ST55("M5_layer"))};
ogstr(1+end) = {GDS_reset(DMetals,GDS_ST55("M6_layer"))};
ogstr(1+end) = {GDS_reset(DVias,GDS_ST55("VIA5_layer"))};

% Store the layers in the Output_glib
[Output_glib] = add_struct(Output_glib,ogstr);
fprintf("Done reseting layers.\n");
%% rename all structures so that we dont get importing error in CAD
[Output_glib] = GDS_auto_rename_glib(Output_glib,Cell_name);

%% add reference to all elements
lol = gds_structure(convertStringsToChars(Cell_name));
for idx = 1:length(Output_glib(:))
    lol = add_ref(lol,Output_glib(idx));
end
[Output_glib] = add_struct(Output_glib,lol);
%% Export the library as a gds file
write_gds_library(Output_glib, strcat(location,output_filename,'.gds'));
%%

