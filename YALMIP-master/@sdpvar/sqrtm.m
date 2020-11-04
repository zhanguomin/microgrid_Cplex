function varargout = sqrtm(varargin)
%SQRTM (overloaded)

switch nargout
    case 0
        sqrtm_internal(varargin{:});
    case 1
        varargout{1} = sqrtm_internal(varargin{:});
    case 2
        [varargout{1},varargout{2}] = sqrtm_internal(varargin{:});
    case 3
        [varargout{1},varargout{2},varargout{3}] = sqrtm_internal(varargin{:});
    otherwise
end
