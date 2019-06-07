package nosey.definition;

class DTypeRef
{
    private var _dType :DType;

    public function new(dType :DType) : Void
    {
        _dType = dType;
    }

    public function get() : DType
    {
        return _dType;
    }

    public function toString() : String
    {
        return switch _dType {
            case TYPE(name, params): untyped {name:name,params:params};
            case FUNC(vals): throw "DTypeRef toString!";
        }
    }
}