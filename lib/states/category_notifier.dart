import 'package:flutter/cupertino.dart';

CategoryNotifier categoryNotifier = CategoryNotifier();

class CategoryNotifier extends ChangeNotifier{
  String _selectedCategoryInEng = 'none';

  String get currentCategoryInEng => _selectedCategoryInEng;
  String get currentCategoryInKor => categoriesMapEngToKor[_selectedCategoryInEng]!;
  
  
  void setNewCategoryWithEng(String newCategory){
    if(categoriesMapEngToKor.keys.contains(newCategory)){
      _selectedCategoryInEng = newCategory;
      notifyListeners();
    }
  }

  void setNewCategoryWithKor(String newCategory){
    if(categoriesMapEngToKor.values.contains(newCategory)){
      _selectedCategoryInEng = categoriesMapKorToEng[newCategory]!;
      notifyListeners();
    }
  }
}


const Map<String, String> categoriesMapEngToKor = {
  'none': '선택',
  'fashion': '패션',
  'kids': '아동',
  'electronics': '전자제품',
  'furniture': '가구',
  'sports': '스포츠',
  'cosmetics': '화장품'
};

const Map<String, String> categoriesMapKorToEng = {
  '선택':'none',
  '패션':'fashion',
  '아동':'kids',
  '전자제품':'electronics',
  '가구':'furniture',
  '스포츠':'sports',
  '화장품':'cosmetics'
};