package nosey.definition;

import nosey.definition.DType.DTypeRef;

class DParameter
{
    public var type :DRef<DType>;

    public function new(type :DRef<DType>) : Void
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
        return new DParameter(new DTypeRef(nosey.definition.DType.DTypeTools.fromType(type)));
    }
#end
}