package nosey;

import nosey.DefinitionBuilder;
import nosey.DefinitionExtender;
import haxe.Serializer;

class TypeWriter
{
    macro static public function build(path :String, includes :Array<String>, excludes :Array<String>, prettyJson :Bool):Array<haxe.macro.Expr.Field>
    {
        haxe.macro.Context.onAfterGenerate(function() {
            DefinitionBuilder.extendDefinitions();
            var typingData = new TypingData();
            for(definition in DefinitionBuilder.definitions) {
                var editorClass = DefinitionExtender.createEditorClass(DefinitionBuilder.definitions, definition);
                typingData.classes.set(editorClass.name, editorClass);
            }
            for(enum_ in DefinitionBuilder.enums) {
                typingData.enums.set(enum_.name, enum_);
            }

            sys.io.File.saveContent(path + '/baseComponents.json', Serializer.run(typingData));
        });

        haxe.macro.Context.onAfterTyping(function(moduleTypes :Array<haxe.macro.Type.ModuleType>) {
            for(moduleType in moduleTypes) {
                switch moduleType {
                    case TClassDecl(c): { //A class.
                        DefinitionBuilder.fromClassType(c.get(), includes, excludes);
                    }
                    case TEnumDecl(e): { //An enum.
                        DefinitionBuilder.fromEnumType(e.get(), includes, excludes);
                    }
                    case TTypeDecl(t): { //A typedef.
                        DefinitionBuilder.fromDefType(t.get(), includes, excludes);
                    }
                    case TAbstract(a): { //An abstract.
                        //ignore
                    }
                }
            }
        });

        return haxe.macro.Context.getBuildFields();
    }
}