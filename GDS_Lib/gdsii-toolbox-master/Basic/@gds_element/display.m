function display(gelm)
%function display(gelm)
%
% display method for GDS elements
%

    % print variable name
    fprintf('\n%s is a GDSII element:\n\n', inputname(1));

    switch get_etype(gelm.data.internal)
  
      case 'boundary'
          fprintf('   Type: boundary (%d)\n', numel(gelm.data.xy));
          fprintf('   layer = %d\n', get_element_data(gelm.data.internal, 'layer') );
          fprintf('   dtype = %d\n', get_element_data(gelm.data.internal, 'dtype') );
      
      case 'sref'
          fprintf('   Type: sref (%d) --> %s\n', size(gelm.data.xy,1), ...
                  get_element_data(gelm.data.internal, 'sname') );
          if has_property(gelm.data.internal, 'strans')
              display_strans( get_element_data(gelm.data.internal, 'strans') );
          end
   
      case 'aref'
          fprintf('   Type: aref --> %s\n', get_element_data(gelm.data.internal, 'sname') );
          fprintf('   xy = '); 
          fprintf('\n        %g  %g', gelm.data.xy');
          fprintf('\n');
          adim = get_element_data(gelm.data.internal, 'adim');
          fprintf('   adim = (rows = %d, cols = %d)\n', adim.row, adim.col);
          if has_property(gelm.data.internal, 'strans')
              display_strans( get_element_data(gelm.data.internal, 'strans') );
          end
  
      case 'node' % what is that anyway ...
          fprintf('   Type: node\n');
          fprintf('   xy = '); 
          fprintf('\n        %g  %g', gelm.data.xy');
          fprintf('   layer = %d\n', get_element_data(gelm.data.internal, 'layer') );
          fprintf('   ntype = %d\n', get_element_data(gelm.data.internal, 'ntype') );
          
      case 'path'
          fprintf('   Type: path (%d)\n', numel(gelm.data.xy));
          fprintf('   layer = %d\n', get_element_data(gelm.data.internal, 'layer') );
          fprintf('   dtype = %d\n', get_element_data(gelm.data.internal, 'dtype') );
          if has_property(gelm.data.internal, 'ptype')
              fprintf('   ptype = %d\n', get_element_data(gelm.data.internal, 'ptype') );
          else
              fprintf('   ptype = 0 (undefined)\n');
          end
          if has_property(gelm.data.internal, 'width')
              fprintf('   width = %f\n', get_element_data(gelm.data.internal, 'width') );
          else
              fprintf('   width = 0 (undefined)\n');
          end
  
      case 'text'
          fprintf('   Type: text\n');
          fprintf('   text = %s\n', gelm.data.text);
          fprintf('   layer = %d\n', get_element_data(gelm.data.internal, 'layer') );
          fprintf('   dtype = %d\n', get_element_data(gelm.data.internal, 'dtype') );
          fprintf('   ttype = %d\n', get_element_data(gelm.data.internal, 'ttype') );
          if has_property(gelm.data.internal, 'present')
              fprintf('   font = %d\n', get_element_data(gelm.data.internal, 'font') );
              fprintf('   verj = %d\n', get_element_data(gelm.data.internal, 'verj') );
              fprintf('   horj = %d\n', get_element_data(gelm.data.internal, 'horj') );
          end
          if has_property(gelm.data.internal, 'ptype')
              fprintf('   ptype = %d\n', get_element_data(gelm.data.internal, 'ptype') );
          else
              fprintf('   ptype undefined\n');
          end
          if has_property(gelm.data.internal, 'width')
              fprintf('   width = %f\n', get_element_data(gelm.data.internal, 'width') );
          else
              fprintf('   width undefined\n');
          end
          fprintf('   xy = '); 
          fprintf('\n        %g  %g', gelm.data.xy');
          fprintf('\n');
          if has_property(gelm.data.internal, 'strans')
              display_strans( get_element_data(gelm.data.internal, 'strans') );
          end
   
      case 'box' 
          fprintf('   Type: box\n'); 
          fprintf('   xy = '); 
          fprintf('\n        %g  %g', gelm.data.xy');
          fprintf('\n');
          fprintf('   layer = %d\n', get_element_data(gelm.data.internal, 'layer') );
          fprintf('   btype = %d\n', get_element_data(gelm.data.internal, 'btype') );
  
    end

    % display records common to all elements
    if has_property(gelm.data.internal, 'elflags')
        fprintf('   elflags = %s\n', get_element_data(gelm.data.internal, 'elflags') );
    end
    if has_property(gelm.data.internal, 'plex')
        fprintf('   plex = %d\n', get_element_data(gelm.data.internal, 'plex') );
    end
    if isfield(gelm, 'prop') && ~isempty(gelm.data.prop)
        for k = 1:length(gelm.data.prop)
            fprintf('   (property %d :  attr = %d, name = %s)\n', ...
                    k, gelm.data.prop(k).attr, gelm.data.prop(k).value);
        end
    end
    fprintf('\n');

end


%
% display a strans structure
%
function display_strans(strans);

    fprintf('   strans = (');
    fprintf('reflect ');
    if isfield(strans,'reflect')
        fprintf('= %d, ', strans.reflect);
    else
        fprintf('undefined, ');
    end
    fprintf('absmag ');
    if isfield(strans,'absmag')
        fprintf('= %d, ', strans.absmag);
    else
        fprintf('undefined, ');
    end
    fprintf('absang ');
    if isfield(strans,'absang')
        fprintf('= %d, ', strans.absang);
    else
        fprintf('undefined, ');
    end
    fprintf('mag ');
    if isfield(strans,'mag') && ~isempty(strans.mag)
        fprintf('= %f, ', strans.mag);
    else
        fprintf('undefined, ');
    end
    fprintf('angle ');
    if isfield(strans,'angle') && ~isempty(strans.angle)
        fprintf('= %f)\n', strans.angle);
    else
        fprintf('undefined)\n');
    end
    
end
