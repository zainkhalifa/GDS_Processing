function gstruc = gds_structure(sname, varargin)
%function gstruc = gds_structure(sname, varargin)
%
% Constructor for the GDS structure class.
% Structures contain one or more GDS elements.
%
% sname :     a string with the name of the structure.
% gstruc :    the structure object returned by the constructor
% varargin :  (Optional) EITHER one or more elements that become
%             part of the structure OR a cell array with elements
%

% Ulf Griesmann, NIST, June 2011

    % check argument
    if nargin == 0, error('gds_structure :  structure name is missing'); end;
    if ~ischar(sname), error('gds_structure :  first argument is not a string'); end;
    
    % default values; the structure is implemented as a cell array
    gstruc.sname = sname; % structure name
    gstruc.el = {};       % cell array of elements
    
    % structure properties
    gstruc.cdate = datevec(now);              % creation date
    gstruc.cdate(6) = round(gstruc.cdate(6)); % to nearest second
    gstruc.mdate = [];                        % modification date
    
    % add the elements to the structure
    while length(varargin) > 0
        
        % get element
        el = varargin{1};
        
        if isa(el, 'gds_element')  % check if an element
            gstruc.el{end+1} = el;
            
        elseif iscell(el)          % check if it is a cell array
            if ~all(cellfun(@(x)isa(x,'gds_element'), el))
                error('gds_structure : at least one object in cell array is not a gds_element.');
            end
            gstruc.el = [gstruc.el, el];
            
        else
            error('gds_structure :  argument(s) must be GDS element(s) or structure(s).');
        end
        varargin(1) = [];
        
    end
    
    % create the structure object
    gstruc = class(gstruc, 'gds_structure');
    
end
