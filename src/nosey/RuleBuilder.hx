package nosey;

#if macro
import nosey.definition.DParameter;
import nosey.definition.DType;

class RuleBuilder
{
    public static function make(concreteParams :Array<DParameter>, genericParams :Array<DParameter>) : DType -> DType
    {
        var map = new Map<String,DType>();
        for(i in 0...genericParams.length) {
            switch genericParams[i].type.get() {
                case FUNC(val): 
                    throw "FUNC NOT POSSIBLE";
                case TYPE(module, params):
                    map.set(module, concreteParams[i].type.get());
            }
        }
        return mapDType.bind(map);
    }

    private static function mapDType(map :Map<String,DType>, dVarType :DType) : DType
    {
        return switch dVarType {
            case FUNC(vals):
                FUNC(vals.map(function(dType) {
                    return mapDType(map, dType);
                }));
            case TYPE(module, params):
                return (map.get(module) == null) ? dVarType : map.get(module);
        }
    }
}
#end