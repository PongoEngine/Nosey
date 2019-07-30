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

import nosey.type.NClassField;
import nosey.type.NFieldKind;
import nosey.type.NTypeParameter;
import nosey.type.NType;
import nosey.type.NClassType;
import nosey.type.NDefType;
import nosey.type.NEnumField;
import nosey.type.NEnumType;
import haxe.ds.Option;

class Util
{
    public static function isIncluded(target :String, includes :Array<String>) : Bool
    {
        for(include in includes) {
            if(include.length == 0) {
                return true;
            }
            else if(target.length >= include.length) {
                if(isIncluded_(target, include)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static function isIncluded_(target :String, include :String) : Bool
    {
        for(i in 0...include.length) {
            var targetChar = target.charAt(i);
            var includeChar = include.charAt(i);
            if(targetChar != includeChar) {
                return false;
            }
            if(i == include.length-1) {
                return true;
            }
        }

        return false;
    }

    public static inline function isExcluded(target :String, excludes :Array<String>) : Bool
    {
        return isIncluded(target, excludes);
    }

    public static function createNClassField(classField :haxe.macro.Type.ClassField) : Option<NClassField>
    {
        var shouldCreate = #if hidePrivate classField.isPublic; #else true; #end
        return shouldCreate ? Some({
    #if !hidePrivate
            isPublic: classField.isPublic,
    #end
            kind: createNFieldKind(classField.kind),
            name: classField.name,
            overloads: classField.overloads.get() != null
                ? classField.overloads.get()
                    .map(o -> createNClassField(o))
                    .map(option -> {
                        switch option {
                            case Some(v): v;
                            case None: null;
                        }
                    })
                    .filter(o -> o != null)
                : [],
            params: classField.params.map(p -> createNTypeParameter(p)),
            type: createNType(classField.type)
        }) : None;
    }

    public static function createNClassType(classType :haxe.macro.Type.ClassType) : NClassType
    {
        return {
            constructor: classType.constructor != null
                ? switch createNClassField(classType.constructor.get()) {
                    case Some(v): v;
                    case None: null;
                }
                : null,
            fields: classType.fields.get() != null
                ? classType.fields.get()
                    .map(f -> createNClassField(f))
                    .map(option -> {
                        switch option {
                            case Some(v): v;
                            case None: null;
                        }
                    })
                    .filter(o -> o != null)
                : [],
#if !hideExtern
            isExtern: classType.isExtern,
#end
#if !hideInterface
            isInterface: classType.isInterface,
#end
#if !hidePrivate
            isPrivate:  classType.isPrivate,
#end
            module: classType.module,
            name: classType.name,
            overrides: classType.overrides
                .map(o -> createNClassField(o.get()))
                .map(option -> {
                    switch option {
                        case Some(v): v;
                        case None: null;
                    }
                })
                .filter(o -> o != null),
            pack: classType.pack,
            params: classType.params.map(p -> createNTypeParameter(p)),
            superClass: classType.superClass != null
                ? 
                { refModule: classType.superClass.t.get().module
                , params: classType.superClass.params.map(p -> createNType(p))
                }
                : null
        }
    }

    public static function createNDefType(defType :haxe.macro.Type.DefType) : NDefType
    {
        return {
#if !hideExtern
            isExtern: defType.isExtern,
#end
#if !hidePrivate
            isPrivate: defType.isPrivate,
#end
            module: defType.module,
            name: defType.name,
            pack: defType.pack,
            params: defType.params.map(p -> createNTypeParameter(p)),
            type: createNType(defType.type)
        }
    }

    public static function createNEnumField(enumField :haxe.macro.Type.EnumField) : NEnumField
    {
        return {
            index: enumField.index,
            name: enumField.name,
            params: enumField.params.map(p -> createNTypeParameter(p)),
            type: createNType(enumField.type)
        }
    }

    public static function createNEnumType(enumType :haxe.macro.Type.EnumType) : NEnumType
    {
        var constructs = new Map<String, NEnumField>();
        for(key in enumType.constructs.keys()) {
            constructs.set(key, createNEnumField(enumType.constructs.get(key)));
        }

        return {
            constructs: constructs,
#if !hideExtern
            isExtern: enumType.isExtern,
#end
#if !hidePrivate
            isPrivate: enumType.isPrivate,
#end
            module: enumType.module,
            name: enumType.name,
            names: enumType.names,
            pack: enumType.pack,
            params: enumType.params.map(p -> createNTypeParameter(p))
        }
    }

    public static function createNFieldKind(fieldkind :haxe.macro.Type.FieldKind) : NFieldKind
    {
        return switch fieldkind {
            case FVar(read, write): {
                isMethod: false,
                val: createVar(read, write)
            }
            case FMethod(k): {
                isMethod: true,
                val: createMethod(k)
            }
        }
    }

    public static function createVar(read :haxe.macro.Type.VarAccess, write :haxe.macro.Type.VarAccess) : Var
    {
        return {
            read: switch read {
                case AccCtor: VarAccess.AccCtor;
                case AccNormal: VarAccess.AccNormal;
                case AccNo: VarAccess.AccNo;
                case AccNever: VarAccess.AccNever;
                case AccResolve: VarAccess.AccResolve;
                case AccCall: VarAccess.AccCall;
                case AccInline: VarAccess.AccInline;
                case AccRequire(r, msg): VarAccess.AccRequire;
            },
            write: switch write {
                case AccCtor: VarAccess.AccCtor;
                case AccNormal: VarAccess.AccNormal;
                case AccNo: VarAccess.AccNo;
                case AccNever: VarAccess.AccNever;
                case AccResolve: VarAccess.AccResolve;
                case AccCall: VarAccess.AccCall;
                case AccInline: VarAccess.AccInline;
                case AccRequire(r, msg): VarAccess.AccRequire;
            }
        }
    }

    public static function createMethod(k :haxe.macro.Type.MethodKind) : Method
    {
        return {
            methodKind: switch k {
                case MethNormal: MethodKind.MethNormal;
                case MethInline: MethodKind.MethInline;
                case MethDynamic: MethodKind.MethDynamic;
                case MethMacro: MethodKind.MethMacro;
            }
        }
    }

    public static function createNType(type :haxe.macro.Type) : NType
    {
        return {
            val: switch type {
                case TMono(t): {};
                case TEnum(t, params): 
                    createNTEnum(t, params);
                case TInst(t, params): 
                    createNTInst(t, params);
                case TType(t, params): 
                    createNTType(t, params);
                case TFun(args, ret): 
                    createNTFun(args, ret);
                case TAnonymous(a): {};
                case TDynamic(t): {};
                case TLazy(f): {};
                case TAbstract(t, params):
                    createNTAbstract(t.get().name);
            },

            name: switch type {
                case TMono(t): NTypeName.TMono;
                case TEnum(t, params): NTypeName.TEnum;
                case TInst(t, params): NTypeName.TInst;
                case TType(t, params): NTypeName.TType;
                case TFun(args, ret): NTypeName.TFun;
                case TAnonymous(a): NTypeName.TAnonymous;
                case TDynamic(t): NTypeName.TDynamic;
                case TLazy(f): NTypeName.TLazy;
                case TAbstract(t, params):  NTypeName.TAbstract;
            }
        }
    }

    public static function createNTType(t:haxe.macro.Type.Ref<haxe.macro.Type.DefType>, params:Array<haxe.macro.Type>) : NTType
    {
        return {
            refModule: t.get().module,
            params: params.map(p -> createNType(p))
        }
    }

    public static function createNTEnum(t:haxe.macro.Type.Ref<haxe.macro.Type.EnumType>, params:Array<haxe.macro.Type>) : NTEnum
    {
        return {
            refModule: t.get().module,
            params: params.map(p -> createNType(p))
        }
    }

    public static function createNTInst(t:haxe.macro.Type.Ref<haxe.macro.Type.ClassType>, params:Array<haxe.macro.Type>) : NTInst
    {
        return {
            refModule: t.get().module,
            params: params.map(p -> createNType(p))
        }
    }

    public static function createNTFun(args:Array<{t:haxe.macro.Type, opt:Bool, name:String}>, ret:haxe.macro.Type) : NTFun
    {
        return {
            args: args.map(a -> {
                t: createNType(a.t),
                opt: a.opt,
                name: a.name
            }),
            ret: createNType(ret)
        }
    }

    public static function createNTAbstract(primitive :Primitive) : NTAbstract
    {
        return {
            primitive: primitive
        }
    }

    public static function createNTypeParameter(typeParameter :haxe.macro.Type.TypeParameter) : NTypeParameter
    {
        return {
            name: typeParameter.name,
            type: createNType(typeParameter.t) 
        }
    }
}