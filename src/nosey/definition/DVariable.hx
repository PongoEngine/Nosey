package nosey.definition;

class DVariable
{
    public var name (default, null):String;
    public var type (default, null):DRef<DType>;

    public function new(name :String, type :DRef<DType>) : Void
    {
        this.name = name;
        this.type = type;
    }

#if macro
    public static function fromClassField(field :haxe.macro.Type.ClassField) : DVariable
    {
        return fromType(field.name, field.type);
    }

    public static function fromType(fieldName :String, type :haxe.macro.Type) : DVariable
    {
        return new DVariable(fieldName, new DTypeRef(nosey.definition.DType.DTypeTools.fromType(type)));
    }
#end
}