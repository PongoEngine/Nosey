package nosey.definition;

class DFunction
{
    public var name (default, null):String;
    public var arguments (default, null):Array<DArg>;
    public var ret (default, null):DRef<DType>;

    public function new(name :String, arguments :Array<DArg>, ret :DRef<DType>) : Void
    {
        this.name = name;
        this.arguments = arguments;
        this.ret = ret;
    }

#if macro
    public static function fromClassField(field :haxe.macro.Type.ClassField) : DFunction
    {
        return switch field.type {
            case TFun(args,ret): 
                var retType = nosey.definition.DType.DTypeTools.fromType(ret);
                new DFunction(field.name, args.map(DArg.fromArg), new DTypeRef(retType));
            case _: throw "fromClassField NOT_VALID";
        }
    }
#end
}