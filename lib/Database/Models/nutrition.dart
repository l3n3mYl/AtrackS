class Nutrition{
  String carbs, protein, fats, calories, water;

  get carbCount {
    return this.carbs;
  }

  set carbCount (String mg){
    this.carbs = mg;
  }

  get proteinCount {
    return this.protein;
  }

  set proteinCount (String mg){
    this.protein = mg;
  }

  get fatsCount {
    return this.fats;
  }

  set fatsCount (String mg) {
    this.fats = mg;
  }

  get calorieCount {
    return this.calories;
  }

  set calorieCount (String kcal){
    this.calories = kcal;
  }

  get waterMills {
    return this.water;
  }

  set waterMills (String mills){
    this.water = mills;
  }

  Map<String, Object> nutritionInfoToMap(){
    Map<String, Object> info = {
      "Carbs" : carbCount,
      "Protein" : proteinCount,
      "Fats" : fatsCount,
      "Calories" : calorieCount,
      "Water" : waterMills,
    };

    return info;
  }

  Nutrition({this.carbs, this.protein, this.fats, this.calories, this.water});

}