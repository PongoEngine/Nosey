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

package nosey.type;

typedef NType =
{
    public var name (default, null):NTypeName;
    public var val (default, null):Dynamic;
}

typedef NTMono =
{
}

typedef NTLazy =
{
}

typedef NTDyna =
{
}

typedef NTAnonymous =
{
}

typedef NTType =
{
    public var refModule (default, null) : String;
    public var params (default, null) : Array<NType>;
}

typedef NTEnum =
{
    public var refModule (default, null) : String;
    public var params (default, null) : Array<NType>;
}

typedef NTInst =
{
    public var refModule (default, null) : String;
    public var params (default, null) : Array<NType>;
}

typedef NTFun =
{
    public var args (default, null) : Array<{t:NType, opt:Bool, name:String}>;
    public var ret (default, null) : NType;
}

typedef NTAbstract =
{
    public var primitive (default, null):Primitive;
}

@:enum
abstract Primitive(String) to String from String
{
    var Int = "Int";
    var Float = "Float";
}

@:enum
abstract NTypeName(String) to String from String
{
    var TMono = "NTMono";
    var TEnum = "NTEnum";
    var TInst = "NTInst";
    var TType = "NTType";
    var TFun = "NTFun";
    var TAnonymous = "NTAnonymous";
    var TDynamic = "NTDynamic";
    var TLazy = "NTLazy";
    var TAbstract = "NTAbstract";
}