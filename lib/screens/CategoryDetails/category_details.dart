import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/screens/CategoryDetails/bloc/category_details_bloc.dart';
import 'package:flutter_ecommerce/screens/ShoppingCart/bloc/shopping_cart_bloc.dart';
import 'package:flutter_ecommerce/screens/ShoppingCart/shopping_cart.dart';
import 'package:flutter_ecommerce/ui/product_card.dart';
import 'package:flutter_ecommerce/ui/product_search_delegate.dart';
import 'package:flutter_ecommerce/ui/products_filter_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDetails extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String bannerURL;

  const CategoryDetails(
      {super.key,
      required this.categoryName,
      required this.bannerURL,
      required this.categoryId});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  // * Selected value of the dropdown menu
  String? selectedValue = "All items";

  // * Lists of products in the category
  List<Product> products = [];
  List<Product> productsCopy = [];

  // * boolean using to fetch the products from firestore only one time.
  bool productsFetched = false;

  // * Selected values from the filter options
  String selectedAvailability = "";
  RangeValues selectedRangeValues = const RangeValues(100, 350);

  void applyFilters(String availability, RangeValues rangeValues) {
    // * Set values from the filters
    setState(() {
      selectedAvailability = availability;
      selectedRangeValues = rangeValues;
    });

    // * Filtering by availability
    products = productsCopy.where((product) {
      if (selectedAvailability == "In Stock") {
        return product.isInStock;
      } else if (selectedAvailability == "Out of Stock") {
        return !product.isInStock;
      }
      return true;
    }).toList();

    // * Filtering by price range
    products = products.where((product) {
      return product.price >= rangeValues.start &&
          product.price <= rangeValues.end;
    }).toList();

    // * Resetting the drop down menu to 'All times'
    selectedValue = "All items";
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    // * Drop down menu items
    final List<String> items = [
      "All items",
      'New Arrival',
      'Price: High to Low',
      'Price: Low to High',
    ];

    return BlocBuilder<CategoryDetailsBloc, CategoryDetailsState>(
      builder: (context, state) {
        // * Fetching & Setting category products using Category Bloc Provider.
        // * Fetching should call before this page is rendered.
        if (state is CategoryLoaded && !productsFetched) {
          products = state.products;
          productsCopy = state.products;

          productsFetched = true;
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: (state is CategoryLoaded)
              ? Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: deviceSize.height * 0.33,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(widget.bannerURL),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Positioned.fill(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 55),
                                      child: Text(
                                        widget.categoryName,
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 45,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )))
                          ],
                        ),
                        // * no of products & sort button
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: deviceSize.width * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${products.length.toString()} items",
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  items: items
                                      .map(
                                        (String item) =>
                                            DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: GoogleFonts.poppins(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      // * Sorting products based on the selected drop down menu.
                                      selectedValue = value;
                                      if (selectedValue ==
                                          'Price: Low to High') {
                                        products = state.products;
                                        products.sort((a, b) =>
                                            a.price.compareTo(b.price));
                                      } else if (selectedValue ==
                                          'Price: High to Low') {
                                        products = state.products;

                                        products.sort((a, b) =>
                                            b.price.compareTo(a.price));
                                      } else if (selectedValue ==
                                          "New Arrival") {
                                        products =
                                            state.products.where((product) {
                                          final currentDate = DateTime.now();
                                          final differenceInDays = currentDate
                                              .difference(product.createdAt)
                                              .inDays;
                                          return differenceInDays <= 4;
                                        }).toList();
                                      } else if (selectedValue == 'All items') {
                                        // * Show all products
                                        products = state.products;
                                      }
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 40,
                                    width: 190,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                    ),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      CupertinoIcons.chevron_down,
                                    ),
                                    iconSize: 14,
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.grey,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    offset: const Offset(-20, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness: MaterialStateProperty.all(6),
                                      thumbVisibility:
                                          MaterialStateProperty.all(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // * category items
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                  horizontal: deviceSize.width * 0.05),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                runSpacing: 10,
                                children:
                                    List.generate(products.length, (index) {
                                  return ProductCard(product: products[index]);
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.only(top: 50, left: 25),
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Icon(
                                    Icons.chevron_left,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            // * back and like button
                            GestureDetector(
                              onTap: () async {
                                await showSearch(
                                    context: context,
                                    delegate: ProductSearchDelegate(
                                        categoryId: widget.categoryId,
                                        categoryName: widget.categoryName));
                              },
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  margin:
                                      const EdgeInsets.only(top: 50, right: 25),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: const Center(
                                    child: Icon(Icons.search),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton.icon(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            shape:
                                                const RoundedRectangleBorder(),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ProductsFilterBottomSheet(
                                                initialAvailabilitySelected:
                                                    selectedAvailability,
                                                initialRangeValues:
                                                    selectedRangeValues,
                                                applyFiltersCallBack:
                                                    applyFilters,
                                              );
                                            });
                                      },
                                      icon: const Icon(
                                          Icons.filter_alt_outlined,
                                          color: Colors.white),
                                      label: Text(
                                        "Add Filter",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ShoppingCart(
                                                      fromWhere: "category",
                                                    )));
                                      },
                                      icon: const Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                      ),
                                      label: BlocBuilder<ShoppingCartBloc,
                                          ShoppingCartState>(
                                        builder: (context, state) {
                                          if (state
                                              is ShoppingCartLoadedState) {
                                            if (state.cart.items.isNotEmpty) {
                                              return Text(
                                                "Cart ${state.cart.items.length}",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              );
                                            } else {
                                              return Text(
                                                "Cart Empty",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              );
                                            }
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              // * Displaying loading circle when category products are loading (state = CategoryLoading)
              : (state is CategoryLoading)
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        strokeWidth: 5,
                        color: Color(0xff75A488),
                      ),
                    )
                  : Container(),
        );
      },
    );
  }
}
