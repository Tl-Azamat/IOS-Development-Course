Shopping Cart System
Course: iOS Development — Classes & Structs

Author: Азамат
Assignment: Shopping Cart System

Why a class for ShoppingCart?
The cart represents shared, mutable state with identity. Multiple parts of an app (product list, cart screen, checkout) should see the same cart instance and observe each other’s changes.
Reference semantics make this natural: passing the cart to a function or view doesn’t copy it, and mutations affect the single, canonical cart.
I also used private(set) on items to encapsulate writes inside the class methods while keeping read access public.

Why structs for Product and Order?
Product is plain data with no identity needs; copying it is cheap and safe.
A failable initializer enforces invariants (price > 0, stockQuantity >= 0) at the boundary, which fits value semantics.
Order is a snapshot of the cart at checkout time. Making it a struct with all let properties ensures immutability: even if the cart changes afterward, the order stays exactly as it was when created (timestamped, totals fixed, items frozen).

Reference semantics that matter
I demonstrate this by passing a ShoppingCart into a helper function:
func modifyCart(_ cart: ShoppingCart) {
    cart.addItem(product: headphones, quantity: 1)
}
After calling modifyCart(cart), the original cart reflects the new item.
That behavior is desired because there should be one source of truth for the cart across the app.

Value semantics that matter
CartItem (and Product) are structs. Copying a CartItem and then changing the copy’s quantity leaves the original untouched:
let item1 = CartItem(product: laptop, quantity: 1)!
var item2 = item1
item2.updateQuantity(5) // item1.quantity is still 1
This illustrates value semantics clearly and helps avoid accidental shared mutations in simple data models.

Challenges and solutions
Validation & safety: I used failable initializers in Product and CartItem to prevent invalid states (negative price/quantity).
Encapsulation: items is private(set); all mutations go through methods that maintain invariants (no duplicates per product.id, 0 quantity removes an item).
Discount design: The base task supports codes like "SAVE10". For the bonus I added a DiscountType enum (percentage, fixedAmount, buyXGetY).
The computed discountAmount first checks discountType and falls back to codes, keeping the system extensible.
Inventory (bonus): Changing stock on a value type (Product) requires care. I kept a simple addItem(product:quantity:) that checks stock but doesn’t mutate it, and an optional addItemCheckingStock(product: inout ...) version that safely decrements via inout.
Xcode gotchas: Files must be in the target (Target Membership). Also, top-level prints don’t run in an iOS app; I wrapped demos in runScenarios() and triggered them via ContentView.onAppear.

