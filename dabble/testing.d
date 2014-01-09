
module dabble.testing;

import dabble.repl;


/**
* Seperately eval an array of strings.
*/
void run(string[] code, uint debugLevel = Debug.times)
{    
    string err;
    evaluate("import std.stdio, std.conv, std.traits, std.typecons, std.algorithm, std.range;", err);

    foreach(i, c; code)
    {
        writeln("Line: ", i, " -> ", c);
        auto result = evaluate(c, err);
        assert(result != EvalResult.parseError && result != EvalResult.buildError, err);
        writeln(err);
    }    
}

void stress()
{
    run([
    "auto err0 = `1.2`.to!int;",
    "struct S {int x, y = 5; }",
    "auto structS = S();",
    "auto arr0 = [1,2,3,4];",
    "auto arr1 = arr0.sort();",
    "auto arr2 = arr1;",    
    "foreach(ref i; arr2) i++;",
    "writeln(arr2);",
    "writeln(structS);",
    "class C { int a; string b; }",
    "auto classC = new C;",
    "auto str0 = `hello there`;",
    "foreach(i; iota(150)) { str0 ~= `x`;}",
    "writeln(str0);",
    "writeln(classC);",
    "str0 = str0[0..$-20];"
    "writeln(str0);",
    "auto aa0 = [`one`:1, `two`:2, `three`:3, `four`:4];",
    "writeln(aa0[`two`]);",
    "writeln(aa0);",
    "writeln(arr0);",
    "enum Enum { one, two = 5, three = 7 }",
    "auto ee = Enum.two;",
    "write(ee, \"\n\");",
    "auto int0 = 0;",
    "for(auto i=0; i<50; i++) int0++;",
    "import std.array;",
    "auto app0 = appender!string;",
    "for(auto i=0; i<50; i++) app0.put(`blah`);",
    "writeln(app0.data);",
    "import std.container;",
    "auto arr3 = Array!int(4, 6, 2, 3, 8, 0, 2);",
    "foreach(val; arr3[]){ writeln(val); }",
    "int foo(int i) { return 5*i + 1; }",
    "foo(100);",
    "immutable int int1 = 45;", 
    "const(int) int2 = foo(3);",
    "Array!int arr4;",
    "arr4 ~= [1,2,3,4];",
    "writeln(arr4[]);",
    "T boo(T)(T t) { return T.init; }",
    "auto short0 = boo(cast(short)5);",
    "if (true) { auto b = [1,2,3]; writeln(b); } else { auto b = `hello`; writeln(b); }",
    "auto counter0 = 10;",
    "while(counter0-- > 1) { if (false) { auto _temp = 8; } else { writeln(counter0);} }",
    "auto func0 = (int i) { return i + 5; };",
    "func0(10);",
    "auto func1 = func0;",
    "func1(10);",
    "auto func2 = (int i) => i + 5;",
    "auto func3 = (int i) => (i + 5);",
    "func1(func2(func3(5)));",
    "import std.algorithm, std.range;",
    "auto arr5 = [1,2,3,4,5];",
    "arr5 = arr5.map!( a => a + 4).array();",
    "writeln(arr5);"
    ], Debug.times);
}


void libTest()
{    
    string err;

    void test(string i) { writeln(i); assert(evaluate(i, err) == EvalResult.noError, err); }
    
    test("import std.typecons;");
    test("Nullable!int a;");
    test("a = 5;");
    test("a;");
    test("int b;");
    test("auto bref = NullableRef!int(&b);");
    test("bref = 5;");
    test("bref;");
    test("auto c = tuple(1, `hello`);");    
    //test("class C { int x; }; Unique!C f = new C;");
    //test("f.x = 7;");

    context.reset();

    test("import std.algorithm, std.range;");
    test("auto r0 = iota(0, 50, 10);");
    test("r0.find(20);");
    test("balancedParens(`((()))`, '(', ')');");
    test("`hello`.countUntil('l');");
    test("`hello`.findSplitAfter(`el`);");
    test("[1,2,3,4,5].bringToFront([3,4,5]);");
    test("[1,2,3,4,5].filter!(a => a > 3).array();");
    test("[1,2,3,4,5].isSorted();");

    context.reset();

    test("import std.range;");
    test("auto r0 = iota(0, 50, 10);");
    test("while(!r0.empty) { r0.popFront(); }");
    test("auto r1 = stride(iota(0, 50, 1), 5);");
    test("writeln(r1);");
    test("drop(iota(20), 12);");
    test("auto r2 = iota(20);");
    test("popFrontN(r2, 7);");
    test("takeOne(retro(iota(20)));");
    test("takeExactly(iota(20), 5);");
    test("radial(iota(20).array(), 10);");

    context.reset();

    test("import std.container;");
    test("SList!int slist0;");
    test("slist0.insertFront([1,2,3]);");
    test("auto slist1 = SList!int(1,2,3);");
    test("slist1.insertFront([1,2,3]);");
    test("DList!int dlist0;");
    test("dlist0.insertFront([1,2,3]);");
    test("auto dlist1 = DList!int(1,2,3);");
    test("dlist1.insertFront([1,2,3]);");
    test("Array!int array0;");
    test("array0 ~= [1,2,3];");
    test("auto array1 = Array!int(1,2,3);");
    test("array1 ~= [1,2,3];");
    test("auto tree0 = redBlackTree!true(1,2,3,4,5);");
    test("tree0.insert(5);");
    test("RedBlackTree!int tree1 = new RedBlackTree!int();");
    test("tree1.insert(5);");
    test("BinaryHeap!(Array!int) heap0 = BinaryHeap!(Array!int)(Array!int(1,2,3,4));");
    //test("heap0.insert(1);");

    context.reset();

    test("import std.regex;");
    test("auto r0 = regex(`[a-z]*`,`g`);");
    test("auto m0 = match(`abdjsadfjg`,r0);");
    test("auto r1 = regex(`[0-9]+`,`g`);");
    test("auto m1 = match(`12345`,r1);");

}


auto test0()
{
    return run(["class C { int x; }","c = new C;"]);
}

auto test1()
{
    return run([
    "interface I { bool foo(); } ", 
    "class C : I { int x; bool foo() { return true; } }", 
    "c = new C;",
    "writeln(c);",
    "writeln(c.foo());"
    ]);
}

auto test2()
{
    return run([
    "import std.typecons; int i = 7; ", "Unique!int ui = &i;", "writeln(ui);"
    ]);
}

