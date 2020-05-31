class MonthNutritionProgress{
  String carbs, protein, fats, calories, water;

  get carbCountProgress {
    return this.carbs;
  }

  set carbCountProgress (String mg){
    this.carbs = mg;
  }

  get proteinCountProgress {
    return this.protein;
  }

  set proteinCountProgress (String mg){
    this.protein = mg;
  }

  get fatsCountProgress {
    return this.fats;
  }

  set fatsCountProgress (String mg) {
    this.fats = mg;
  }

  get calorieCountProgress {
    return this.calories;
  }

  set calorieCountProgress (String kcal){
    this.calories = kcal;
  }

  get waterMillsProgress {
    return this.water;
  }

  set waterMillsProgress (String mills){
    this.water = mills;
  }


  Map<String, Object> nutritionMonthProgressInfoToMap(){
    Map<String, Object> info = {
      "Carbs" : carbCountProgress,
      "Protein" : proteinCountProgress,
      "Fats" : fatsCountProgress,
      "Calories" : calorieCountProgress,
      "Water" : waterMillsProgress,
    };

    return info;
  }

  MonthNutritionProgress({this.carbs, this.protein, this.fats, this.calories, this.water});

}