Shopping Cart System
Course: iOS Development — Classes & Structs

Author: Азамат
Assignment: Shopping Cart System (100 points)

Overview

This project implements a shopping cart system in Swift to demonstrate the differences between structs (value types) and classes (reference types).
It models real-world entities such as products, cart items, shopping carts, addresses, and orders.

The project is organized using clean code principles, encapsulation, and proper use of mutability.

Type Choice Explanation
Why class for ShoppingCart?

The shopping cart has identity and shared mutable state.
When you pass a ShoppingCart instance around, any change in one reference should reflect everywhere — just like in a real app where multiple screens show the same cart.
That’s why it’s implemented as a class (reference type).

Why struct for Product and Order?

Product doesn’t need identity — two identical products can exist independently.
Copying it should create a new, independent instance.

Order represents a snapshot of the cart. Once created, it’s immutable — you can’t change the items or totals later.
Therefore, a struct (value type) fits perfectly.

This assignment clearly demonstrates the difference between value semantics (structs) and reference semantics (classes) in Swift.
The system models real-world e-commerce behavior while following strong object-oriented and Swift paradigms.

✅ All tests passed
✅ Proper encapsulation
✅ Clean and documented code
✅ Full understanding of classes vs structs
