import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_manager_flutter/models/category/category_model.dart';

const _CATEGORY_DB_NAME = 'category_database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();

  Future<void> insertCategory(CategoryModel value);

  Future<void> deleteCategory(String categoryID);
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomecategoryListNotifier =
      ValueNotifier([]);

  ValueNotifier<List<CategoryModel>> expenseCategoryListNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _CategoryDB = await Hive.openBox<CategoryModel>(_CATEGORY_DB_NAME);
    await _CategoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _CategoryDB = await Hive.openBox<CategoryModel>(_CATEGORY_DB_NAME);
    return _CategoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final allCategories = await getCategories();
    incomecategoryListNotifier.value.clear();
    expenseCategoryListNotifier.value.clear();

    await Future.forEach(allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomecategoryListNotifier.value.add(category);
      } else {
        expenseCategoryListNotifier.value.add(category);
      }
    });

    incomecategoryListNotifier.notifyListeners();
    expenseCategoryListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _CategoryDB = await Hive.openBox<CategoryModel>(_CATEGORY_DB_NAME);
    await _CategoryDB.delete(categoryID);

    refreshUI();
  }
}
