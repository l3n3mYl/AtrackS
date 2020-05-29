class NutritionGoals{
  String carbs_goals, protein_goals, fats_goals, calorie_goals, water_goals;

  get carbCountGoals {
    return this.carbs_goals;
  }

  set carbCountGoals (String mg){
    this.carbs_goals = mg;
  }

  get proteinCountGoals {
    return this.protein_goals;
  }

  set proteinCountGoals (String mg){
    this.protein_goals = mg;
  }

  get fatsCountGoals {
    return this.fats_goals;
  }

  set fatsCountGoals (String mg) {
    this.fats_goals = mg;
  }

  get calorieCountGoals {
    return this.calorie_goals;
  }

  set calorieCountGoals (String kcal){
    this.calorie_goals = kcal;
  }

  get waterMillsGoals {
    return this.water_goals;
  }

  set waterMillsGoals (String mills){
    this.water_goals = mills;
  }

  Map<String, Object> nutritionGoalsInfoToMap(){
    Map<String, Object> info = {
      "Carbs_Goals" : carbCountGoals,
      "Protein_Goals" : proteinCountGoals,
      "Fats_Goals" : fatsCountGoals,
      "Calories_Goals" : calorieCountGoals,
      "Water_Goals" : waterMillsGoals,
    };

    return info;
  }

  NutritionGoals({this.carbs_goals, this.protein_goals, this.fats_goals, this.calorie_goals, this.water_goals});

}