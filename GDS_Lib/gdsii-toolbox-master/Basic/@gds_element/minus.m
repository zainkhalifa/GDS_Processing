function [gelm] = minus(gelm1, gelm2)
%function [gelm] = minus(gelm1, gelm2)
%
% Defines the '-' operator for the gds_element class, which 
% performs a Boolean 'notb' (set difference) operation with the polygons
% of boundary elements. All properties are inherited from gelm1.
%
% gelm1 :  input boundary element 1
% gelm2 :  input boundary element 2
% gelm  :  boundary element on the same layer as gelm1.

% Ulf Griesmann, NIST, April 2014

   % global variables
   global gdsii_uunit;

   % units must be defined
   if isempty(gdsii_uunit) 
       warning('undefined GDSII units');
       fprintf('\n  +-------------------- WARNING -----------------------+\n');
       fprintf('  | Units are not defined; setting uunit/dbunit = 1000.|\n'); 
       fprintf('  | Define units by creating the library object or     |\n'); 
       fprintf('  | by calling gdsii_units.                            |\n'); 
       fprintf('  +----------------------------------------------------+\n');
       udf = 1000;
   else
       udf = gdsii_uunit;      % conversion factor to db units
   end

   % check arguments
   if ~strcmp(get_etype(gelm1.data.internal), 'boundary') || ...
      ~strcmp(get_etype(gelm2.data.internal), 'boundary')
      error('gds_element.minus :  arguments of - must be boundary elements.');
   end

   % create output element
   gelm = gelm1;

   % apply boolean set operation
   [gelm.data.xy, hf] = poly_boolmex(gelm1.data.xy, gelm2.data.xy, ...
                                     'notb', udf);
   if any(hf)
      warning('gds_element.minus :  a polygon with a hole was created.');
   end
   
end
