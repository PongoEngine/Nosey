package nosey;

import nosey.definition.DEnum;
import nosey.EditorClass;

using Lambda;

class TypingData
{
    public var classes (default, null) :Map<String, EditorClass>;
    public var enums (default, null) :Map<String, DEnum>;

    public function new() : Void
    {
        this.classes = new Map<String, EditorClass>();
        this.enums = new Map<String, DEnum>();
    }

    public static function getClass(data :TypingData, name :String) : EditorClass
    {
        return data.classes.get(name);
    }

    public static function getExtended(data :TypingData, class_ :EditorClass) : Array<EditorClass>
    {
        var editorClasses = class_.extendedBy.map(function(name) {
            return data.classes.get(name);
        });

        return editorClasses.concat(editorClasses.map(function(c) {
            return getExtended(data, c);
        }).flatten());
    }
}