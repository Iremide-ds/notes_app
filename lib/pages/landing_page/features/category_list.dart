import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_dimensions.dart';
import '../../../providers.dart';
import '../../../models/category.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return SizedBox(
      height: AppDimensions.height1,
      width: AppDimensions.screenWidth,
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
              vertical: AppDimensions.screenHeight * 0.016),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (ctx, index) {
            return _CategoryButton(category: categories[index]);
          }),
    );
  }
}

class _CategoryButton extends ConsumerWidget {
  final NoteCategory category;

  const _CategoryButton({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);

    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.defaultPadding),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  (filter == category.id) ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius1),
                  side: BorderSide(
                      width: 1.0,
                      color: (filter == category.id)
                          ? Colors.black
                          : Colors.white)),
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenWidth * 0.06, vertical: 0),
              elevation: 0.0),
          onPressed: () {
            ref.read(filterProvider.notifier).update((state) {
              if (state == category.id) {
                return state = null;
              } else {
                return state = category.id;
              }
            });
          },
          child: Text(
            category.name,
            style: TextStyle(
                fontSize: AppDimensions.fontSize1,
                fontWeight: FontWeight.w600,
                color: (filter == category.id) ? Colors.black : Colors.white),
          )),
    );
  }
}
