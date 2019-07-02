package nosey.type;

typedef NFieldKind =
{
    public var isMethod (default, null):Bool;
    public var val (default, null):Dynamic;
}

typedef Var =
{
    public var read (default, null):VarAccess;
    public var write (default, null):VarAccess;
}

typedef Method =
{
    public var methodKind (default, null):MethodKind;
}

@:enum
abstract MethodKind(String)
{
    var MethNormal = "MethNormal";
    var MethInline = "MethInline";
    var MethDynamic = "MethDynamic";
    var MethMacro = "MethMacro";
}

@:enum
abstract VarAccess(String)
{
    var AccCtor = "AccCtor";
    var AccNormal = "AccNormal";
    var AccNo = "AccNo";
    var AccNever = "AccNever";
    var AccResolve = "AccResolve";
    var AccCall = "AccCall";
    var AccInline = "AccInline";
    var AccRequire = "AccRequire";
}