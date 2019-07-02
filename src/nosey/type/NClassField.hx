package nosey.type;

typedef NClassField =
{
    public var isPublic (default, null) :Bool;
    public var kind (default, null) :NFieldKind;
    public var name (default, null) :String;
    public var overloads (default, null) :Array<NClassField>;
    public var params (default, null) :Array<NTypeParameter>;
    public var type (default, null) :NType;
}