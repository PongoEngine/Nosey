package nosey;

import nosey.definition.DVariable;
import nosey.definition.DFunction;

class EditorClass
{
    public var name (default, null):String;
    public var superClass (default, null):String;
    public var isTyped (default, null):Bool;
    public var extendedBy (default, null):Array<String>;
    public var variables (default, null):Array<DVariable>;
    public var methods (default, null):Array<DFunction>;
    public var constructor (default, null):DFunction;

    public function new(name :String, superClass :String, isTyped :Bool, extendedBy :Array<String>, variables :Array<DVariable>, methods :Array<DFunction>, constructor :DFunction) : Void
    {
        this.name = name;
        this.superClass = superClass;
        this.isTyped = isTyped;
        this.extendedBy = extendedBy;
        this.variables = variables;
        this.methods = methods;
        this.constructor = constructor;
    }
}