import 'package:flutter/material.dart';
import 'package:takroom/models/supplier_product.dart';
import 'package:takroom/services/product_service.dart';
import 'package:takroom/widgets/dialogs/edit_product_dialog.dart';

class SuppliserProductCard extends StatefulWidget {
  const SuppliserProductCard({super.key, required this.product});

  final SupplierProduct product;

  @override
  State<SuppliserProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<SuppliserProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// PRODUCT INFO
                  Row(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.inventory_2, color: Colors.orange),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "${widget.product.price} sp",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// EDIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: "",
                          barrierColor: Colors.black.withOpacity(.45),
                          transitionDuration: const Duration(milliseconds: 350),
                          pageBuilder: (_, __, ___) {
                            return EditProductDialog(product: widget.product);
                          },
                          transitionBuilder: (_, animation, __, child) {
                            return Transform.scale(
                              scale: Curves.easeInOutBack.transform(
                                animation.value,
                              ),
                              child: Opacity(
                                opacity: animation.value,
                                child: child,
                              ),
                            );
                          },
                        );

                        // TODO: edit product
                      },

                      icon: const Icon(Icons.edit),

                      label: const Text("Edit Product"),

                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// DELETE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ProductService.deleteProduct(
                          context,
                          widget.product.id,
                        );

                        Navigator.pop(context);

                        // TODO: delete product
                      },

                      icon: const Icon(Icons.delete),

                      label: const Text("Delete Product"),

                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red.withOpacity(.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),

                borderRadius: BorderRadius.circular(14),
              ),

              child: widget.product.categoryId == 1
                  ? Icon(Icons.lunch_dining, color: Colors.orange)
                  : widget.product.categoryId == 2
                  ? Icon(Icons.wine_bar, color: Colors.orange)
                  : widget.product.categoryId == 3
                  ? Icon(Icons.kitchen, color: Colors.orange)
                  : widget.product.categoryId == 4
                  ? Icon(Icons.cookie, color: Colors.orange)
                  : Icon(Icons.fastfood, color: Colors.orange),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    widget.product.name,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Stock: ${widget.product.stock}",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            Text(
              "\$${widget.product.price}",

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
