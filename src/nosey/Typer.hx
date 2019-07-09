package nosey;

import haxe.macro.Context;
import haxe.macro.Expr;
import nosey.type.NClassType;
import nosey.type.NEnumType;
import nosey.type.NDefType;

using nosey.Util;

class Typer 
{
	macro static public function build(path :String, includes :Array<String>, excludes :Array<String>, prettyPrint :Bool):Array<Field> 
    {
        Context.onAfterTyping(function(modules) {
            var typings = {
                classes: {},
                enums: {},
                defs: {}
            }

            for(module in modules) {
                switch module {
                    case TClassDecl(c):
                        var moduleStr = c.get().module;
                        var isHiddenExtern = #if hideExtern c.get().isExtern #else false #end;
                        var isHiddenPrivate = #if hidePrivate c.get().isPrivate #else false #end;
                        var isHiddenInterface = #if hideInterface c.get().isInterface #else false #end;

                        if(moduleStr.isIncluded(includes) && !moduleStr.isExcluded(excludes) && !isHiddenExtern && !isHiddenPrivate && !isHiddenInterface) {
                            Reflect.setField(typings.classes,
                                moduleStr,
                                c.get().createNClassType()
                            );
                        }
                    case TEnumDecl(e):
                        var moduleStr = e.get().module;
                        var isHiddenExtern = #if hideExtern e.get().isExtern #else false #end;
                        var isHiddenPrivate = #if hidePrivate e.get().isPrivate #else false #end;

                        if(moduleStr.isIncluded(includes) && !moduleStr.isExcluded(excludes) && !isHiddenExtern && !isHiddenPrivate) {
                            Reflect.setField(typings.enums,
                                moduleStr,
                                e.get().createNEnumType()
                            );
                        }
                    case TTypeDecl(t):
                        var moduleStr = t.get().module;
                        var isHiddenExtern = #if hideExtern t.get().isExtern #else false #end;
                        var isHiddenPrivate = #if hidePrivate t.get().isPrivate #else false #end;

                        if(moduleStr.isIncluded(includes) && !moduleStr.isExcluded(excludes) && !isHiddenExtern && !isHiddenPrivate) {
                            Reflect.setField(typings.defs,
                                moduleStr,
                                t.get().createNDefType()
                            );
                        }
                    case TAbstract(a):
                        null;
                }
            }

            var validTypingsStr = haxe.Json.stringify(typings, prettyPrint ? "  " : null);
            sys.io.File.saveContent(path + 'baseComponents.json', validTypingsStr);
        });

		return Context.getBuildFields();
	}
}
