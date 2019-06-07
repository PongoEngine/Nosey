package nosey.definition;

import Lambda;

class DEnum
{
    public var name (default, null):String;
    public var enums (default, null):Array<Dynamic>;

    public function new(name :String, enums :Array<Dynamic>) : Void
    {
        this.name = name;
        this.enums = enums;
    }

#if macro
    public static function fromEnumType(enumType :haxe.macro.Type.EnumType) : DEnum
    {
        return new DEnum
            ( enumType.module
            , Lambda.array(enumType.constructs).map(createDEnumType)
            );
    }

    static function createDEnumType(field :haxe.macro.Type.EnumField) : Dynamic
    {
        return switch field.type {
            case TEnum(t,params): field.name;
            case TFun(args,ret): 
                var func = {};
                Reflect.setField(func,field.name,args.map(DArg.fromArg));
                func;
            case _: throw "createDEnumType not reachable";
        }
    }
#end
}
