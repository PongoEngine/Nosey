package nosey;

import nosey.type.NClassType;
import nosey.type.NEnumType;
import nosey.type.NClassField;
import nosey.type.NType;

class Query
{
    public static function getClass(data :Dynamic, name :String) : NClassType
    {
        var classes = Reflect.getProperty(data, "classes");
        return Reflect.getProperty(classes, name);
    }

    public static inline function getConstructor(classType :NClassType) : Null<NClassField>
    {
        return classType.constructor;
    }

    public static function getConstructorArgs(classType :NClassType) : Array<{t:NType, opt:Bool, name:String}>
    {
        return classType.constructor.type.val.args;
    }

    public static function getClassnames(data :Dynamic) : Array<String>
    {
        var classes = Reflect.getProperty(data, "classes");
        return Reflect.fields(classes);
    }

    public static function getEnum(data :Dynamic, name :String) : NEnumType
    {
        var enums = Reflect.getProperty(data, "enums");
        return Reflect.getProperty(enums, name);
    }
}