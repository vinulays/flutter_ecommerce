import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';
import 'package:flutter_ecommerce/screens/Checkout/checkout.dart';
import 'package:flutter_ecommerce/screens/ShoppingCart/bloc/shopping_cart_bloc.dart';
import 'package:flutter_ecommerce/ui/cart_item_card.dart';
import 'package:google_fonts/google_fonts.dart';

class ShoppingCart extends StatefulWidget {
  // * fromWhere is used to display the back button if the user visited the cart from product detail & profile pages.
  final String fromWhere;
  const ShoppingCart({super.key, required this.fromWhere});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);

    return BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: deviceData.size.width * 0.05),
                child: Row(
                  children: [
                    if (widget.fromWhere != "home")
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.chevron_left_outlined,
                          size: 30,
                        ),
                      ),
                    if (widget.fromWhere != "home") const SizedBox(width: 10),
                    Text("Shopping Cart",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              if (state is ShoppingCartLoadedState)
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.cart.items.length,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          child: CartItemCard(
                            fromWhere: "cart",
                            cartItem: CartItem(
                                id: state.cart.items[index].id,
                                name: state.cart.items[index].name,
                                imageUrl: state.cart.items[index].imageUrl,
                                price: state.cart.items[index].price,
                                quantity: state.cart.items[index].quantity,
                                color: state.cart.items[index].color,
                                size: state.cart.items[index].size),
                          ),
                        );
                      }),
                ),
              Container(
                margin: EdgeInsets.only(
                    right: deviceData.size.width * 0.05,
                    left: deviceData.size.width * 0.05,
                    bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                      ),
                    ),
                    if (state is ShoppingCartLoadedState)
                      Text(
                        "\$${state.cart.total.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                            fontSize: 19, fontWeight: FontWeight.w700),
                      ),
                  ],
                ),
              ),
              BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                builder: (context, state) {
                  return Container(
                    margin: EdgeInsets.only(
                        right: deviceData.size.width * 0.05,
                        left: deviceData.size.width * 0.05,
                        bottom: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        // * navigating to checkout.
                        onPressed: (state is ShoppingCartLoadedState &&
                                state.cart.items.isEmpty)
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => Checkout()),
                                );
                              },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.8),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 17.88)),
                          backgroundColor: (state is ShoppingCartLoadedState &&
                                  state.cart.items.isNotEmpty)
                              ? MaterialStateProperty.all<Color>(Colors.black)
                              : MaterialStateProperty.all(
                                  Colors.black.withOpacity(0.5)),
                        ),
                        child: Text(
                          "Checkout",
                          style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
