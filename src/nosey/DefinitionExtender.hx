package nosey;

#if macro
import nosey.definition.Definition;
import nosey.definition.DVariable;
import nosey.definition.DParameter;
import nosey.definition.DFunction;
import nosey.definition.DType;
import nosey.definition.DArg;
import nosey.definition.DTypeRef;

class DefinitionExtender
{
    public static function createEditorClass(data :Map<String, Definition>, definition :Definition) : EditorClass
    {
        var isConstructable = definition.params.length == 0 && !definition.isInterface && definition.constructor != null;
        var superClass = (definition.superClass == null) ? null : definition.superClass.name;
        return new EditorClass
            ( definition.module
            , superClass
            , isConstructable
            , definition.extendedBy
            , getVariables
                ( data
                , getParentDef(data, definition)
                , getConcreteParams(definition, null)
                , definition.variables
                )
            , getMethods
                ( data
                , getParentDef(data, definition)
                , getConcreteParams(definition, null)
                , definition.methods
                )
            , definition.constructor
            );
    }

    private static function getVariables(data :Map<String, Definition>, definition :Definition, concreteParams :Array<DParameter>, variables: Array<DVariable>) : Array<DVariable>
    {
        if(definition != null) {
            var resolveType = RuleBuilder.make(concreteParams, definition.params);
            return getVariables(data, getParentDef(data, definition), getConcreteParams(definition, resolveType), variables.concat(definition.variables.map(function(var_) {
                var type = resolveType(var_.type.get());
                return new DVariable(var_.name, new DTypeRef(type));
            })));
        }
        else {
            return variables;
        }
    }

    private static function getMethods(data :Map<String, Definition>, definition :Definition, concreteParams :Array<DParameter>, methods: Array<DFunction>) : Array<DFunction>
    {
        if(definition != null) {
            var resolveType = RuleBuilder.make(concreteParams, definition.params);
            return getMethods(data, getParentDef(data, definition), getConcreteParams(definition, resolveType), methods.concat(definition.methods.map(function(method) {
                var args = method.arguments.map(function(arg :DArg) {
                    var type = resolveType(arg.type.get());
                    return new DArg(arg.name, arg.opt, new DTypeRef(type));
                });
                var retType = resolveType(method.ret.get());
                return new DFunction(method.name, args, new DTypeRef(retType));
            })));
        }
        else {
            return methods;
        }
    }

    private static function getParentDef(data :Map<String, Definition>, definition :Definition) : Definition
    {
        return (definition.superClass == null) ? null : data.get(definition.superClass.name);   
    }

    private static function getConcreteParams(definition :Definition, resolveType :Null<DType -> DType>) :Array<DParameter>
    {
        return (definition.superClass == null) 
            ? null 
            : (resolveType == null)
                ? definition.superClass.params
                : definition.superClass.params.map(function(dParam) {
                    var type = resolveType(dParam.type.get());
                    return new DParameter(new DTypeRef(type));
                });
    }
}
#end