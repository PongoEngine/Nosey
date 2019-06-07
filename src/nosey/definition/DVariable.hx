package nosey.definition;

class DVariable
{
    public var name (default, null):String;
    public var type (default, null):DType;

    public function new(name :String, type :DType) : Void
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
        return new DVariable(fieldName, nosey.definition.DType.DTypeTools.fromType(type));
    }
#end
}