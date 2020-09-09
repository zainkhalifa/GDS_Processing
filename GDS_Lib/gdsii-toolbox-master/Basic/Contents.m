% Classes and Methods for GDSII 
% =============================
%
% GDSII libraries (files) consist of elements of the types boundary,
% sref, aref, path, node, box, and text, that are grouped into
% structures (sometimes called cells). The structures are combined
% into libries that describe a layout.
%
% Elements
% --------
% gds_element   - constructor for the gds_element class
% display       - display method for the gds_element class
% get           - retrieve element properties
% set           - set element properties
% etype
% is_etype      - test the element type
% is_ref        - test if element is sref or aref
% poly_box      - convert box to boundary element
% poly_text     - convert text to boundary element
% poly_path     - convert path to boundary element
% poly_bool     - Boolean set algebra with boundary elements
% poly_cw       - make polygons in boundary elements clockwise
% poly_iscw     - check orientation of bounday element polygons
% add_poly      - add a polygon to a compound boundary element
% and           - operator for Boolean set intersection 'and'
% or            - operator for Boolean set union 'or'
% minus         - operator for Boolean set difference 'notb'
% mpower        - operator for Boolean set exclusive or
% plus          - operator for creation of compound elements
% bbox          - bounding box of elements
% rotate        - applies a rotation to an element
% sname         - change names of referenced structures
%
% NOTE: 
% Element properties can be read and set using field name indexing
% (e.g.: el.layer = 2). 
%
% Structures
% ----------
% gds_structure   - constructor for the gds_structure class
% display         - display method for the gds_structure class
% find            - find elements with certain properties
% findref         - find names of referenced structures
% findel          - find elements with specified properties
% get             - to retrieve structure properties
% set             - set structure properties
% numel           - number of elements in a structure
% rename          - rename a structure
% refrename       - replaces referenced structure names
% sname           - returns the structure name
% sdate           - return structure creation/modification dates
% stuctfun        - iterator method for the gds_structure class
% poly_convert    - converts box, text, and path elements to 
%                   boundary elements
% add_element     - add element(s) to structures
% add_ref         - convenient method to create sref elements in structures 
%
% NOTES:
% - Elements in the structures can be addressed using array
%   indexing.
% - The number of elements can be read and the structure name can
%   be read and set using field name indexing.
%
% Libraries
% ---------
% gds_library      - constructor for the gds_library class
% display          - display method for the gds_library class
% treeview         - structure hierarchy view method
% subtree          - copy structure with referenced structures
% topstruct        - return name(s) of the top structure(s)
% get              - method to retrieve class properties
% set              - method to set class properties
% lname            - return library name
% rename           - changes the library name
% srename          - rename structure and all references to it
% snames           - list of structure names
% poly_convert     - convert path and box elements to boundary elements
% numst            - number of structures in the library
% numel            - alias for 'numst'
% length           - alias for 'numst'
% getstruct        - retrieve structures by name
% libraryfun       - iterator method for the gds_library class
% bbox             - boundary box of library
% write_gds_library- method to write a gds_library object to a file
%
% NOTE:
% - Structures in a library can be addressed using array indexing.
%
% Ulf Griesmann, NIST, 2008 - 2016
% -------------------------------------------------------
