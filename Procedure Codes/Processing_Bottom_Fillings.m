% This code generates solid fillings and fillings using blocks like
% 7lf7laf block or Grid_Fill block. This code needs masks and it is better
% to be generated from HFSS side. 

clear all
close all
clc

location = 'IN_OUT/';
Filling_glib_filename   = 'HRO_BFillings_HFSS';
outside_block_filename  = 'z_01210000_5x5_block';

output_filename = 'HRO_BFillings_CAD';
Cell_name = 'HRO_BFillings';

[Fillings_glib] = read_gds_library(strcat(location,Filling_glib_filename,'.gds'));
[ob_glib] = read_gds_library(strcat(location,outside_block_filename,'.gds'));

Filling_gstr = get(Fillings_glib,'st');
Filling_gstr = Filling_gstr{1};
OutGrid_gstr = get(ob_glib,'st');
OutGrid_gstr = OutGrid_gstr{1};

uunit  = get(Fillings_glib,'uunit' );
dbunit = get(Fillings_glib,'dbunit');
units = uunit/dbunit;
gdsii_units(uunit, dbunit);

%% Create the output gds library 
Output_glib = gds_library('z_MATLAB','uunit',uunit, 'dbunit',dbunit);

%% Discretize to the needed grid > minGrid(for M8) and > minWidth for the rest
DSt = GDS_Discretize_gstr(Filling_gstr,20,units);
Filling_maskgelm = DSt(1);
DSt(1) = [];
Shield_maskgstr = DSt;
%% produce the bbox element

    box = bbox(Filling_maskgelm);
    c = [mean([box(1) box(3)]) mean([box(2) box(4)])];
    d = abs([box(3)-box(1) box(4)-box(2)]);
%     d = ceil(d./5).*5;
%     c = ceil(c./5).*5;
    if d(2) < c(2)*2, d(2) = 2*c(2);
    end
    bboxgelm = GDS_Create_box(d,c);
    figure
    GDS_plot(Shield_maskgstr,'k-')
    GDS_plot(bboxgelm,'b-'),hold on
    GDS_plot(Filling_maskgelm,'r-.')
%% created mosaic of grid wall in the bbox
    Mosaic.b = [5 5];
    Mosaic.d = [0 0];
    Mosaic.e = [0 0];

    block_gelm = GDS_Create_box(Mosaic.b,[0 0]);
    [RC,Center] = GDS_Mosaic_calc(bboxgelm,Mosaic);
    Mosaic_gstr = GDS_Mosaic(block_gelm,Mosaic,RC-1,Center);
    Mosaic_gstr = GDS_combine_gstrcells(Mosaic_gstr);
    
    figure
    GDS_plot(Mosaic_gstr,'k-.'),hold on
    GDS_plot(Filling_maskgelm,'r-')
%% find the intersecting filling blocks with out/in_mask   
    inv_inner_maskgstr = GDS_MATH(bboxgelm,Filling_maskgelm,'diff',units);
    InOut_Mosaic_gstr = GDS_Mosaic_intersections(inv_inner_maskgstr(1),Mosaic_gstr,units);

    figure
    GDS_plot(InOut_Mosaic_gstr{2},'k-'),hold on
    GDS_plot(Filling_maskgelm,'r-'),hold on
    
%% get the negative of the Outside_Mosaic_gstr and produce the squary ring mask layer
    outer_solid_gstr = GDS_Merge(InOut_Mosaic_gstr{1},units*100);
    outer_solid_gstr = GDS_MATH(bboxgelm,outer_solid_gstr(1),'diff',units);
    outer_solid_gstr = GDS_Discretize_gstr(outer_solid_gstr,2500,units);
    figure
%     GDS_plot_gstr(InOut_Mosaic_gstr{2},0,'k-'),hold on
    GDS_plot(outer_solid_gstr,'-')

%%  
    the_diffring_mask = GDS_MATH(Shield_maskgstr,outer_solid_gstr,'diff',units); 
    figure
    % GDS_plot_gstr(Shield_maskgstr,0,'b-'),hold on
    % GDS_plot_gelm(outer_solid_gstr(1),'r-.')
    GDS_plot_gstr(the_diffring_mask,0,'k-'),hold on 


    the_diffring_mask = GDS_Discretize_gstr(the_diffring_mask,500,units);
    the_diffring_mask = GDS_minWidth_gstr(the_diffring_mask,650,400,5000,units);
    
    figure
    GDS_plot(Filling_maskgelm,'r-'),hold on
    GDS_plot(the_diffring_mask,'b-'),hold on    
    GDS_plot(InOut_Mosaic_gstr{2},'k.'),hold on

%% replace the Outer_Mosaic_gstr with the grid block from the ob_glib (z_Si_M8_5x5_...)

    igstr = InOut_Mosaic_gstr{2};
    OUT_GRID = gds_structure('OUT_GRID');
    for e_idx = 1:length(igstr(:))
        box = bbox(igstr(e_idx));
        center = [mean([box(1) box(3)]) mean([box(2) box(4)])];
        OUT_GRID = add_ref(OUT_GRID,OutGrid_gstr,'xy',center);
    end

%% Copy the the_diffring_mask to the required layers in CAD
Splited_St = GDS_Split_gstr(the_diffring_mask,2,units);

clear ogstr
ogstr = {};

ogstr(1+end) = {GDS_reset(Splited_St,GDS_ST55("M6_layer"))};
ogstr(1+end) = {GDS_reset(Splited_St,GDS_ST55("M7_layer"))};
ogstr(1+end) = {GDS_reset(Splited_St,GDS_ST55("M8_layer"))};

% Store the layers in the Output_glib
[Output_glib] = add_struct(Output_glib,ogstr);

%% rename all structures so that we dont get importing error in CAD
[Output_glib] = add_struct(Output_glib,OUT_GRID);
[Output_glib] = GDS_auto_rename_glib(Output_glib,Cell_name);

%% add reference to all elements
lol = gds_structure(convertStringsToChars(Cell_name));
for idx = 1:length(Output_glib(:))
    lol = add_ref(lol,Output_glib(idx));
end
[Output_glib] = add_struct(Output_glib,lol);
[Output_glib] = add_struct(Output_glib,OutGrid_gstr);
%% Export the library as a gds file
write_gds_library(Output_glib, strcat(location,output_filename,'.gds'));
%%


    
