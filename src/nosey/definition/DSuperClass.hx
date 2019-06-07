package nosey.definition;

class DSuperClass
{
    public var name (default, null):String;
    public var params (default, null):Array<DParameter>;

    public function new(name :String, params :Array<DParameter>) : Void
    {
        this.name = name;
        this.params = params;
    }

#if macro
    public static function fromSuperClass(superClass:Null<{t:haxe.macro.Type.Ref<haxe.macro.Type.ClassType>, params:Array<haxe.macro.Type>}>) : DSuperClass
    {
        if(superClass==null) {
            return null;
        }
        return new DSuperClass
            ( superClass.t.get().module
            , superClass.params.map(DParameter.fromType)
            );
    }
#end
}