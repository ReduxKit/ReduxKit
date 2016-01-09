//: [Previous](@previous)

import Foundation
import ReduxKit

var str = "Hello, playground"

//: [Next](@next)


infix operator >>> { associativity left }
func >>><A>(f: A -> A, g: A-> A) -> A -> A {
    return { x in
        g(f(x))
    }
}

func testCompose<A>(functions: [A -> A]) -> A->A{
    
    
    let firstFunction = functions.first!;
    
    
    
    
    return functions.reduce(firstFunction) {$0 >>> $1 };
}

func innerStringFunc(test: String) -> String {
    return test + test;
}

func stringFunc(test: (String) -> String) -> String {
    return test(test("New String!"));
}


func outerFunction(firstString: String)
    -> (((String) -> String) -> String)
    -> (((String) -> String) -> String) {
        print(firstString)
        
        return { newString in {newNewString in
             let next = newString(newNewString);
             return  next;
            }
           
        }
}





let stringTest = compose([outerFunction("1 "), outerFunction("2 "), outerFunction("3 ")]);
print(stringTest(innerS))

//let applyMiddlewareTest = testCompose([applyMiddleware([]), applyMiddleware([])]);
