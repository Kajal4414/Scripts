"use strict"; // Strict mode enable karte hain

// 1. Number: Represents both integer and floating-point numbers.
let integerNumber = 42; // Integer
let floatingPointNumber = 3.14; // Floating-point number
let infinityNumber = Infinity; // Positive infinity
let negativeInfinity = -Infinity; // Negative infinity
let notANumber = NaN; // Not-a-Number

console.log("Number Examples:");
console.log(`Integer: ${integerNumber}`);
console.log(`Floating Point: ${floatingPointNumber}`);
console.log(`Infinity: ${infinityNumber}`);
console.log(`Negative Infinity: ${negativeInfinity}`);
console.log(`NaN: ${notANumber}`);

// 2. String: Sequence of characters.
let singleQuoteString = 'Hello';
let doubleQuoteString = "World";
let templateLiteralString = `Hello, ${doubleQuoteString}!`; // Template literals

console.log("\nString Examples:");
console.log(`Single Quote: ${singleQuoteString}`);
console.log(`Double Quote: ${doubleQuoteString}`);
console.log(`Template Literal: ${templateLiteralString}`);

// 3. Boolean: Logical type that can be true or false.
let isJavaScriptFun = true;
let isCodingTough = false;

console.log("\nBoolean Examples:");
console.log(`isJavaScriptFun: ${isJavaScriptFun}`);
console.log(`isCodingTough: ${isCodingTough}`);

// 4. Undefined: Variable declared but not assigned a value.
let undefinedVariable;

console.log("\nUndefined Example:");
console.log(`undefinedVariable: ${undefinedVariable}`); // Will print 'undefined'

// 5. Null: Represents the intentional absence of any object value.
let nullVariable = null;

console.log("\nNull Example:");
console.log(`nullVariable: ${nullVariable}`); // Will print 'null'

// 6. Object: Collection of properties, where each property is a key-value pair.
let person = {
    name: "John Doe",
    age: 30,
    isEmployed: true
};

console.log("\nObject Example:");
console.log(`Person: ${JSON.stringify(person)}`);

// Accessing object properties
console.log(`Person's Name: ${person.name}`);
console.log(`Person's Age: ${person.age}`);
console.log(`Is Person Employed: ${person.isEmployed}`);

// 7. Symbol: Unique identifier.
let uniqueId1 = Symbol("id1");
let uniqueId2 = Symbol("id1"); // Symbols with the same description are still unique

console.log("\nSymbol Example:");
console.log(`Unique ID 1: ${uniqueId1.toString()}`);
console.log(`Unique ID 2: ${uniqueId2.toString()}`);
console.log(`Are Unique IDs equal? ${uniqueId1 === uniqueId2}`); // false

// 8. BigInt: Represents integers larger than 2^53 - 1.
let largeNumber = 9007199254740991n; // BigInt is created by appending 'n' at the end of the number
let largerNumber = 9007199254740992n; // BigInt example

console.log("\nBigInt Example:");
console.log(`Large Number: ${largeNumber}`);
console.log(`Larger Number: ${largerNumber}`);

// Summary console output
console.log("\nData Types Summary:");
console.log(`Number: ${integerNumber}, Type: ${typeof integerNumber}`);
console.log(`String: ${singleQuoteString}, Type: ${typeof singleQuoteString}`);
console.log(`Boolean: ${isJavaScriptFun}, Type: ${typeof isJavaScriptFun}`);
console.log(`Undefined: ${undefinedVariable}, Type: ${typeof undefinedVariable}`);
console.log(`Null: ${nullVariable}, Type: ${typeof nullVariable}`);
console.log(`Object: ${JSON.stringify(person)}, Type: ${typeof person}`);
console.log(`Symbol: ${uniqueId1.toString()}, Type: ${typeof uniqueId1}`);
console.log(`BigInt: ${largeNumber}, Type: ${typeof largeNumber}`);
