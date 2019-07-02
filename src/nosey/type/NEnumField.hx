package nosey.type;

typedef NEnumField =
{
    public var index (default, null) :Int;
    public var name (default, null) :String;
    public var params (default, null) :Array<NTypeParameter>;
    public var type (default, null) :NType;
}