function glib = subsasgn(glib, ins, val)
%function glib = subsasgn(glib, ins, val)
%
% Subscript assign method for the gds_library class
% Enables addressing structures in a library using
% either array indexing or structure name indexing
%
% glib :  gds_library object to be modified
% ins  :  index structure
% val  :  gds_structure or cell array of gds_structure

% Ulf Griesmann, NIST, June 2011

    switch ins.type
  
      case '()'
        idx = ins.subs{:};
        if isa(val, 'gds_structure')
            glib.st{idx} = val;
        elseif iscell(val) || isempty(val)
            glib.st(idx) = val;
        else
            error('gds_library.subsasgn :  rhs. must be gds_structure or cell array.');
        end
        
      case '.'
        for k = 1:length(glib.st)
            if strcmp(ins.subs, glib.st{k}.sname)
                glib.st{k} = val;   
                break
            end
        end
        
        % structure was not found if we get here ...
        error(sprintf('gds_library.susasgn :  structure >>> %s <<< not found', ins.subs));
        
      otherwise
        error('gds_structure.subsasgn :  must use array indexing.');
        
    end
    
end
