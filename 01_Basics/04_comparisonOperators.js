"use strict"; // Strict mode enable karte hain

// 1. Equality (==) aur Inequality (!=)
// Yeh operators values ko compare karte hain bina type check kiye
let a = 5;
let b = "5";

console.log(a == b); // true, kyunki '5' (number) aur "5" (string) ki value same hai, type check nahi hota
console.log(a != b); // false, kyunki '5' aur "5" ki value same hai

// 2. Strict Equality (===) aur Strict Inequality (!==)
// Yeh operators values ko compare karte hain aur type ko bhi check karte hain
console.log(a === b); // false, kyunki ek number hai aur dusra string
console.log(a !== b); // true, kyunki inki type alag-alag hai

// 3. Greater than (>), Less than (<), Greater than or equal to (>=), Less than or equal to (<=)
let x = 10;
let y = 20;

console.log(x > y); // false, kyunki 10 bada nahi hai 20 se
console.log(x < y); // true, kyunki 10 chhota hai 20 se
console.log(x >= 10); // true, kyunki 10 barabar hai 10 ke
console.log(y <= 20); // true, kyunki 20 barabar hai 20 ke

// 4. Comparison of different types
let num = 5;
let str = "5";

console.log(num == str); // true, kyunki '==' type conversion karta hai
console.log(num === str); // false, kyunki '===' type conversion nahi karta

// 5. Comparison with null aur undefined
console.log(null == undefined); // true, kyunki ye dono loosely equal hain
console.log(null === undefined); // false, kyunki inka type alag hai
console.log(null > 0); // false, kyunki null ko number mein convert karke compare karte hain
console.log(null >= 0); // true, kyunki null ko 0 mein convert karke compare karte hain

// 6. Comparison with NaN (Not-a-Number)
// NaN kisi bhi cheez ke barabar nahi hota, even NaN ke bhi
let value = NaN;

console.log(value == NaN); // false
console.log(value === NaN); // false
console.log(isNaN(value)); // true, isNaN function check karta hai ki value NaN hai ya nahi

// 7. Comparison of strings
let str1 = "apple";
let str2 = "banana";

console.log(str1 < str2); // true, kyunki alphabetically 'apple' pehle aata hai 'banana' se
console.log(str1 > str2); // false

// 8. Boolean Comparison
let bool1 = true;
let bool2 = false;

console.log(bool1 == 1); // true, kyunki true ko 1 maana jata hai
console.log(bool2 == 0); // true, kyunki false ko 0 maana jata hai

console.log(bool1 > bool2); // true, kyunki true (1) bada hai false (0) se

console.log("Equality and Inequality Examples:");
console.log(a == b); // true
console.log(a != b); // false
console.log(a === b); // false
console.log(a !== b); // true

console.log("\nGreater than, Less than Examples:");
console.log(x > y); // false
console.log(x < y); // true
console.log(x >= 10); // true
console.log(y <= 20); // true

console.log("\nComparison of Different Types Examples:");
console.log(num == str); // true
console.log(num === str); // false

console.log("\nComparison with Null and Undefined Examples:");
console.log(null == undefined); // true
console.log(null === undefined); // false
console.log(null > 0); // false
console.log(null >= 0); // true

console.log("\nComparison with NaN Examples:");
console.log(value == NaN); // false
console.log(value === NaN); // false
console.log(isNaN(value)); // true

console.log("\nComparison of Strings Examples:");
console.log(str1 < str2); // true
console.log(str1 > str2); // false

console.log("\nBoolean Comparison Examples:");
console.log(bool1 == 1); // true
console.log(bool2 == 0); // true
console.log(bool1 > bool2); // true
