package nosey;

#if macro
import haxe.macro.Type;
import nosey.definition.Definition;
import nosey.definition.DEnum;

class DefinitionBuilder
{
    public static function fromClassType(c :ClassType, includes :Array<String>, excludes :Array<String>) : Void
    {
        if(isIncluded(c.module, includes, excludes)) {
            var definition = Definition.fromClassType(c);
            definitions.set(definition.module, definition);
        }
    }

    public static function fromEnumType(e :EnumType, includes :Array<String>, excludes :Array<String>) : Void
    {
        if(isIncluded(e.module, includes, excludes)) {
            var enum_ = DEnum.fromEnumType(e);
            enums.set(enum_.name, enum_);
        }
    }

    public static function fromDefType(d :DefType, includes :Array<String>, excludes :Array<String>) : Void
    {
        if(isIncluded(d.module, includes, excludes)) {
            var definition = Definition.fromDefType(d);
            definitions.set(definition.module, definition);
        }
    }

    public static function extendDefinitions() :Void
    {
        for(definition in definitions) {
            if(definition.superClass != null) {
                var def = definitions.get(definition.superClass.name);
                if(def != null) {
                    def.extendedBy.push(definition.module);
                }
            }
            for(interface_ in definition.interfaces) {
                var def = definitions.get(interface_);
                if(def != null) {
                    def.extendedBy.push(definition.module);
                }
            }
        }
    }

    static function isIncluded(module :String, includes :Array<String>, excludes :Array<String>) : Bool
    {
        return isIncluded_(module, includes) && !isExcluded(module, excludes);
    }

    static function isIncluded_(module :String, includes :Array<String>) : Bool
    {
        for(include in includes) {
            if((module.indexOf(include) == 0)) return true;
        }
        return false;        
    }

    static function isExcluded(module :String, excludes :Array<String>) : Bool
    {
        for(exclude in excludes) {
            if((module.indexOf(exclude) == 0)) return true;
        }
        return false;        
    }

    public static var definitions :Map<String, Definition> = new Map<String, Definition>();
    public static var enums :Map<String, DEnum> = new Map<String, DEnum>();
}
#end