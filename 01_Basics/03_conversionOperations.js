"use strict"; // Enforce strict mode

// 1. String Conversion
// Convert numbers, booleans, and other data types to strings.
let number = 123;
let numberAsString = String(number); // "123"
let boolean = true;
let booleanAsString = String(boolean); // "true"

// Using template literals also converts values to strings
let combinedString = `Number: ${number}, Boolean: ${boolean}`; // "Number: 123, Boolean: true"

console.log("String Conversion:");
console.log(`numberAsString: ${numberAsString}, type: ${typeof numberAsString}`);
console.log(`booleanAsString: ${booleanAsString}, type: ${typeof booleanAsString}`);
console.log(`combinedString: ${combinedString}`);


// 2. Number Conversion
// Convert strings and booleans to numbers.
let str = "456";
let strAsNumber = Number(str); // 456
let strAsNumberUsingUnaryPlus = +str; // 456 (using unary plus)
let trueAsNumber = Number(true); // 1
let falseAsNumber = Number(false); // 0

// Parse strings to numbers
let floatStr = "123.45";
let parsedInteger = parseInt(floatStr); // 123
let parsedFloat = parseFloat(floatStr); // 123.45

console.log("\nNumber Conversion:");
console.log(`strAsNumber: ${strAsNumber}, type: ${typeof strAsNumber}`);
console.log(`strAsNumberUsingUnaryPlus: ${strAsNumberUsingUnaryPlus}, type: ${typeof strAsNumberUsingUnaryPlus}`);
console.log(`trueAsNumber: ${trueAsNumber}, falseAsNumber: ${falseAsNumber}`);
console.log(`parsedInteger: ${parsedInteger}, parsedFloat: ${parsedFloat}`);


// 3. Boolean Conversion
// Convert numbers, strings, and other data types to booleans.
let zero = 0;
let nonZeroNumber = 123;
let emptyString = "";
let nonEmptyString = "Hello";
let nullValue = null;
let undefinedValue;

let zeroAsBoolean = Boolean(zero); // false
let nonZeroNumberAsBoolean = Boolean(nonZeroNumber); // true
let emptyStringAsBoolean = Boolean(emptyString); // false
let nonEmptyStringAsBoolean = Boolean(nonEmptyString); // true
let nullAsBoolean = Boolean(nullValue); // false
let undefinedAsBoolean = Boolean(undefinedValue); // false

console.log("\nBoolean Conversion:");
console.log(`zeroAsBoolean: ${zeroAsBoolean}, nonZeroNumberAsBoolean: ${nonZeroNumberAsBoolean}`);
console.log(`emptyStringAsBoolean: ${emptyStringAsBoolean}, nonEmptyStringAsBoolean: ${nonEmptyStringAsBoolean}`);
console.log(`nullAsBoolean: ${nullAsBoolean}, undefinedAsBoolean: ${undefinedAsBoolean}`);


// 4. Automatic Type Conversion (Type Coercion)
let result1 = "5" - 3; // 2 (string "5" is converted to number 5)
let result2 = "5" + 3; // "53" (number 3 is converted to string "3" and concatenated)
let result3 = "5" * "2"; // 10 (both strings are converted to numbers)
let result4 = 4 + true; // 5 (boolean true is converted to number 1)
let result5 = 4 + false; // 4 (boolean false is converted to number 0)
let result6 = null + 1; // 1 (null is converted to number 0)
let result7 = undefined + 1; // NaN (undefined cannot be converted to a number)

console.log("\nAutomatic Type Conversion (Type Coercion):");
console.log(`"5" - 3: ${result1}`);
console.log(`"5" + 3: ${result2}`);
console.log(`"5" * "2": ${result3}`);
console.log(`4 + true: ${result4}`);
console.log(`4 + false: ${result5}`);
console.log(`null + 1: ${result6}`);
console.log(`undefined + 1: ${result7}`);
