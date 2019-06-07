package nosey.definition;

enum DType
{
    TYPE(module :String, params :Array<DParameter>);
    FUNC(vals :Array<DType>);
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