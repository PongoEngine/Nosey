package nosey.type;

typedef NClassType =
{
    public var constructor (default, null) :NClassField;
    public var fields (default, null) :Array<NClassField>;
    public var isExtern (default, null) :Bool;
    public var isInterface (default, null) :Bool;
    public var isPrivate (default, null) :Bool;
    public var module (default, null) :String;
    public var name (default, null) :String;
    public var overrides (default, null) :Array<NClassField>;
    public var pack (default, null) :Array<String>;
    public var params (default, null) :Array<NTypeParameter>;
    public var superClass (default, null) :Null<{refModule:String, params:Array<NType>}>;
}