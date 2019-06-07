package nosey.definition;

enum DType
{
    TYPE(module :String, params :Array<DParameter>);
    FUNC(vals :Array<DType>);
}

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

#if macro
class DTypeTools
{
    public static function fromType(type :haxe.macro.Type) : DType
    {
        return switch type {
            case TAbstract(t,params): 
                TYPE(t.toString(), params.map(DParameter.fromType));
            case TAnonymous(a): 
                throw "fromType NOT_VALID";
            case TDynamic(t): 
                TYPE("Dynamic", []);
            case TEnum(t,params): 
                TYPE(t.toString(), params.map(DParameter.fromType));
            case TFun(args,ret): 
                FUNC(args.map(function(arg) {
                    return fromType(arg.t);
                }).concat([fromType(ret)]));
            case TInst(t,params): 
                TYPE(t.toString(), params.map(DParameter.fromType));
            case TLazy(t): 
                throw "fromType NOT_VALID";
            case TMono(t): 
                throw "fromType NOT_VALID";
            case TType(t,params): 
                TYPE(t.toString(), params.map(DParameter.fromType));
        };
    }
}
#end