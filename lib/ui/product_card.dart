import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/screens/ProductDetails/bloc/product_details_bloc.dart';
import 'package:flutter_ecommerce/screens/ProductDetails/product_details.dart';
import 'package:flutter_ecommerce/screens/Wishlist/bloc/wishlist_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  Future<bool?> _toggleWishlistProduct(
      BuildContext context, Product product, bool isLiked) async {
    try {
      context.read<WishlistBloc>().add(ToggleWishlistProduct(product));
      // * Return true to indicate success
      return true;
    } catch (e) {
      // * Return false to indicate failure
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      builder: (context, state) {
        bool isLiked = false;

        if (state is WishlistLoaded) {
          isLiked = state.wishlistProducts
              .any((wishListProduct) => wishListProduct.id == product.id);
        }
        return GestureDetector(
          onTap: () {
            context
                .read<ProductDetailsBloc>()
                .add(FetchProductDetailsEvent(product.id!));

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProductDetails()));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * item thumbnail
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      // color: const Color(0xff7279F6),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(product.thumbnailURL),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 3, top: 1, bottom: 1),
                        child: LikeButton(
                          onTap: (bool isLiked) {
                            return _toggleWishlistProduct(
                                context, product, isLiked);
                          },
                          isLiked: isLiked,
                          circleColor: const CircleColor(
                              start: Colors.red, end: Colors.red),
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: Colors.red,
                            dotSecondaryColor: Colors.red,
                          ),
                          likeBuilder: (bool isLiked) {
                            if (isLiked) {
                              return const Icon(
                                CupertinoIcons.heart_fill,
                                color: Colors.red,
                                size: 20,
                              );
                            } else {
                              return const Icon(
                                CupertinoIcons.heart,
                                color: Colors.black,
                                size: 20,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 160,
                child: Text(
                  product.title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              SizedBox(
                width: 160,
                child: Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
