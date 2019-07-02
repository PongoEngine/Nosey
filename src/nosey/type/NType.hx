package nosey.type;

typedef NType =
{
    public var name (default, null):NTypeName;
    public var val (default, null):Dynamic;
}

typedef NTMono =
{
}

typedef NTLazy =
{
}

typedef NTDyna =
{
}

typedef NTAnonymous =
{
}

typedef NTType =
{
    public var refModule (default, null) : String;
    public var params (default, null) : Array<NType>;
}

typedef NTEnum =
{
    public var refModule (default, null) : String;
    public var params (default, null) : Array<NType>;
}

typedef NTInst =
{
    public var refModule (default, null) : String;
    public var params (default, null) : Array<NType>;
}

typedef NTFun =
{
    public var args (default, null) : Array<{t:NType, opt:Bool, name:String}>;
    public var ret (default, null) : NType;
}

typedef NTAbstract =
{
    public var primitive (default, null):Primitive;
}

@:enum
abstract Primitive(String) to String from String
{
    var Int = "Int";
    var Float = "Float";
}

@:enum
abstract NTypeName(String) to String from String
{
    var TMono = "NTMono";
    var TEnum = "NTEnum";
    var TInst = "NTInst";
    var TType = "NTType";
    var TFun = "NTFun";
    var TAnonymous = "NTAnonymous";
    var TDynamic = "NTDynamic";
    var TLazy = "NTLazy";
    var TAbstract = "NTAbstract";
}