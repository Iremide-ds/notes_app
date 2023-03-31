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
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (ctx, index) {
            return _CategoryButton(category: categories[index]);
          }),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final NoteCategory category;

  const _CategoryButton({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
        onPressed: () {
          //TODO: apply filter logic
        },
        child: Text(category.name));
  }
}
