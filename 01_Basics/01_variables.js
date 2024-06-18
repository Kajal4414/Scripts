const accountId = 112233; // 'const' declares a constant variable. Its value cannot be changed later.
let accountEmail = "johndoe@gmail.com"; // 'let' declares a block-scoped variable. Its value can be changed later.
var accountPassword = "123456"; // 'var' declares a variable that is function-scoped or globally scoped. It's better to avoid using 'var' due to potential scope issues.
let accountState; // 'let' declares a block-scoped variable, but it is not assigned any value yet.
accountCity = "delhi"; // This is a variable assigned without declaration, making it globally scoped.

// accountId = 445566; // Attempting to change a 'const' variable will cause an error because 'const' variables cannot be changed.
accountEmail = "new-account@gmail.com"; // Changing the value of a 'let' variable is allowed.
accountPassword = "new-account-password"; // Changing the value of a 'var' variable is allowed.
accountCity = "new-account-city"; // Changing the value of a globally scoped variable is allowed.

// console.log(accountId); // This line will print the value of accountId to the console.
console.table([accountId, accountEmail, accountPassword, accountState, accountCity]); // This line will print all the variable values in a table format to the console.