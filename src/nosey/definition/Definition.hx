package nosey.definition;

class Definition
{
    public var module (default, null):String;
    public var params (default, null):Array<DParameter>;
    public var isInterface (default, null):Bool;
    public var superClass (default, null):DSuperClass;
    public var interfaces (default, null):Array<String>;
    public var extendedBy (default, null):Array<String>;
    public var variables (default, null):Array<DVariable>;
    public var methods (default, null):Array<DFunction>;
    public var new_ (default, null):DFunction;

    public function new(module :String, params :Array<DParameter>, isInterface :Bool, superClass :DSuperClass, interfaces :Array<String>, extendedBy :Array<String>, variables :Array<DVariable>, methods :Array<DFunction>, new_ :DFunction) : Void
    {
        this.module = module;
        this.params = params;
        this.isInterface = isInterface;
        this.superClass = superClass;
        this.interfaces = interfaces;
        this.extendedBy = extendedBy;
        this.variables = variables;
        this.methods = methods;
        this.new_ = new_;
    }

#if macro
    public static function fromClassType(classType :haxe.macro.Type.ClassType) : Definition
    {
        return new Definition
            ( classType.module
            , classType.params.map(DParameter.fromTypeParameter)
            , classType.isInterface
            , DSuperClass.fromSuperClass(classType.superClass)
            , classType.interfaces.map(function(i) {return i.t.get().module;})
            , [] //extendedBy
            , classType.fields.get().filter(isPublicVariable).map(DVariable.fromClassField) //variables
            , classType.fields.get().filter(isPublicMethod).map(DFunction.fromClassField) //methods
            , (classType.constructor == null) ? null : DFunction.fromClassField(classType.constructor.get())
            );
    }

    public static function fromDefType(defType :haxe.macro.Type.DefType) : Definition
    {
        return new Definition
            ( defType.module
            , defType.params.map(DParameter.fromTypeParameter)
            , false
            , null
            , []
            , []
            , []
            , []
            , null
            ); //NOT COMPLETE JEREMY
    }

    static function isPublicVariable(field :haxe.macro.Type.ClassField) : Bool
    {
        return switch field.kind {
            case FVar(read, write): field.isPublic;
            case FMethod(k): false;
        }
    }

    static function isPublicMethod(field :haxe.macro.Type.ClassField) : Bool
    {
        return switch field.kind {
            case FVar(read, write): false;
            case FMethod(k): field.isPublic;
        }
    }
#end

}