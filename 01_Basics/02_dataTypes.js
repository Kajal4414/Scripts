"use strict"; // Enforce strict mode (treat all js code as newer version).

// alert( 3 + 3 ); // we are using nodejs, not browser

// 1. Number: Represents both integer and floating-point numbers.
let age = 28; // Integer
let height = 5.9; // Floating-point number
let infinityValue = Infinity; // Represents positive infinity
let notANumber = NaN; // Represents a value that is not a number

// 2. String: Represents a sequence of characters.
let firstName = "John"; // Double quotes
let lastName = 'Doe'; // Single quotes
let fullName = `John Doe`; // Template literals (backticks)
let greeting = `Hello, my name is ${firstName} ${lastName}`; // Template literals with variable interpolation

// 3. Boolean: Represents a logical entity with two values: true and false.
let isStudent = true;
let hasGraduated = false;

// 4. Undefined: A variable that has been declared but not assigned a value.
let middleName; // Middle name is declared but not assigned, so it is undefined

// 5. Null: Represents the intentional absence of any object value.
let emptyValue = null; // Explicitly set to null

// 6. Object: A collection of properties, where each property is a key-value pair.
let person = {
    firstName: "John",
    lastName: "Doe",
    age: 28,
    isStudent: true
};

// Accessing object properties
let personName = person.firstName; // John
let personAge = person["age"]; // 28

// 7. Symbol: Represents a unique identifier.
let uniqueId = Symbol("id"); // Creating a new symbol
let anotherUniqueId = Symbol("id"); // Even though the description is the same, each symbol is unique

// 8. BigInt: Represents whole numbers larger than 2^53 - 1.
let largeNumber = 9007199254740991n; // BigInt is created by appending 'n' at the end of the number

// Example usage of different data types:
console.log("Number Examples:");
console.log(`Age: ${age}, Height: ${height}, Infinity: ${infinityValue}, NaN: ${notANumber}`);

console.log("\nString Examples:");
console.log(`First Name: ${firstName}, Last Name: ${lastName}, Full Name: ${fullName}`);
console.log(greeting);

console.log("\nBoolean Examples:");
console.log(`Is Student: ${isStudent}, Has Graduated: ${hasGraduated}`);

console.log("\nUndefined Example:");
console.log(`Middle Name: ${middleName}`); // Will print 'undefined'

console.log("\nNull Example:");
console.log(`Empty Value: ${emptyValue}`); // Will print 'null'

console.log("\nObject Example:");
console.log(`Person: ${JSON.stringify(person)}`);
console.log(`Person Name: ${personName}, Person Age: ${personAge}`);

console.log("\nSymbol Example:");
console.log(`Unique ID: ${uniqueId.toString()}, Another Unique ID: ${anotherUniqueId.toString()}`);
console.log(uniqueId === anotherUniqueId); // Will print 'false' because symbols are unique

console.log("\nBigInt Example:");
console.log(`Large Number: ${largeNumber}`);
