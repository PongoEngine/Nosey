package nosey.definition;

class DParameter
{
    public var type :DType;

    public function new(type :DType) : Void
    {
        this.type = type;
    }

#if macro
    public static function fromTypeParameter(typeParam:haxe.macro.Type.TypeParameter) : DParameter
    {
        return fromType(typeParam.t);
    }

    public static function fromType(type :haxe.macro.Type) : DParameter
    {
        return new DParameter(nosey.definition.DType.DTypeTools.fromType(type));
    }
#end
}