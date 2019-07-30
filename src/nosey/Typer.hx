/*
 * MIT License
 *
 * Copyright (c) 2019 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
