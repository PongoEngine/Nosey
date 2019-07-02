package nosey.type;

typedef NEnumType =
{
    public var constructs (default, null) :Map<String, NEnumField>;
    public var isExtern (default, null) :Bool;
    public var isPrivate (default, null) :Bool;
    public var module (default, null) :String;
    public var name (default, null) :String;
    public var names (default, null) :Array<String>;
    public var pack (default, null) :Array<String>;
    public var params (default, null) :Array<NTypeParameter>;
}