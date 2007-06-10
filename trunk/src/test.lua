-- test lua script to be run with the luabridge test program

-- enum from C++
FN_CTOR = 0
FN_DTOR = 1
FN_STATIC = 2
FN_VIRTUAL = 3
NUM_FN_TYPES = 4

-- function to print contents of a table
function printtable (t)
	for k, v in pairs(t) do
		if (type(v) == "table") then
			print(k .. " =>", "(table)");
		elseif (type(v) == "function") then
			print(k .. " =>", "(function)");
		elseif (type(v) == "userdata") then
			print(k .. " =>", "(userdata)");
		else
			print(k .. " =>", v);
		end
	end
end

function assert (expr)
	if (not expr) then error("assert failed", 2) end
end

-- test functions registered from C++

assert(testSucceeded());
assert(testRetInt() == 47);
assert(testRetFloat() == 47.0);
assert(testRetConstCharPtr() == "Hello, world");
assert(testRetStdString() == "Hello, world");

testParamInt(47);						assert(testSucceeded());
testParamBool(true);					assert(testSucceeded());
testParamFloat(47.0);					assert(testSucceeded());
testParamConstCharPtr("Hello, world");	assert(testSucceeded());
testParamStdString("Hello, world");		assert(testSucceeded());
testParamStdStringRef("Hello, world");	assert(testSucceeded());

-- test static methods of classes registered from C++

A.testStatic();							assert(testAFnCalled(FN_STATIC));
B.testStatic();							assert(testAFnCalled(FN_STATIC));
B.testStatic2();						assert(testBFnCalled(FN_STATIC));

-- test classes registered from C++

object1 = A("object1");					assert(testAFnCalled(FN_CTOR));
object1:testVirtual();					assert(testAFnCalled(FN_VIRTUAL));

object2 = B("object2");					assert(testAFnCalled(FN_CTOR) and testBFnCalled(FN_CTOR));
object2:testVirtual();					assert(testBFnCalled(FN_VIRTUAL) and not testAFnCalled(FN_VIRTUAL));

-- test functions taking and returning classes

testParamAPtr(object1);					assert(object1:testSucceeded());
testParamAPtrConst(object1);			assert(object1:testSucceeded());
testParamConstAPtr(object1);			assert(object1:testSucceeded());
testParamSharedPtrA(object1);			assert(object1:testSucceeded());

testParamAPtr(object2);					assert(object2:testSucceeded());
testParamAPtrConst(object2);			assert(object2:testSucceeded());
testParamConstAPtr(object2);			assert(object2:testSucceeded());
testParamSharedPtrA(object2);			assert(object2:testSucceeded());

result = testRetSharedPtrA();			assert(result:getName() == "from C");

print("All tests succeeded.");