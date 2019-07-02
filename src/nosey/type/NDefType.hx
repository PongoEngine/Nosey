package nosey.type;

typedef NDefType =
{
    public var isExtern (default, null) :Bool;
    public var isPrivate (default, null) :Bool;
    public var module (default, null) :String;
    public var name (default, null) :String;
    public var pack (default, null) :Array<String>;
    public var params (default, null) :Array<NTypeParameter>;
    public var type (default, null) :NType;
}