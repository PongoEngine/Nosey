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

import nosey.type.NClassType;
import nosey.type.NEnumType;
import nosey.type.NClassField;
import nosey.type.NType;

class Query
{
    public static function getClass(data :Dynamic, name :String) : NClassType
    {
        var classes = Reflect.getProperty(data, "classes");
        return Reflect.getProperty(classes, name);
    }

    public static inline function getConstructor(classType :NClassType) : Null<NClassField>
    {
        return classType.constructor;
    }

    public static function getConstructorArgs(classType :NClassType) : Array<{t:NType, opt:Bool, name:String}>
    {
        return classType.constructor.type.val.args;
    }

    public static function getClassnames(data :Dynamic) : Array<String>
    {
        var classes = Reflect.getProperty(data, "classes");
        return Reflect.fields(classes);
    }

    public static function getEnum(data :Dynamic, name :String) : NEnumType
    {
        var enums = Reflect.getProperty(data, "enums");
        return Reflect.getProperty(enums, name);
    }
}