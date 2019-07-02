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

                        if(moduleStr.isIncluded(includes) && !moduleStr.isExcluded(excludes)) {
                            Reflect.setField(typings.classes,
                                moduleStr,
                                c.get().createNClassType()
                            );
                        }
                    case TEnumDecl(e):
                        var moduleStr = e.get().module;

                        if(moduleStr.isIncluded(includes) && !moduleStr.isExcluded(excludes)) {
                            Reflect.setField(typings.enums,
                                moduleStr,
                                e.get().createNEnumType()
                            );
                        }
                    case TTypeDecl(t):
                        var moduleStr = t.get().module;

                        if(moduleStr.isIncluded(includes) && !moduleStr.isExcluded(excludes)) {
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
