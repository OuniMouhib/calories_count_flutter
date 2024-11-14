import 'package:flutter/material.dart';
import 'package:project_flutter/Components/button.dart';
import 'package:project_flutter/Components/colors.dart';
import 'package:project_flutter/Components/textfield.dart'; // Importez votre widget InputField ici

class GainScreen extends StatefulWidget {
  const GainScreen({Key? key}) : super(key: key);

  @override
  _GainScreenState createState() => _GainScreenState();
}

class _GainScreenState extends State<GainScreen> {
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();
  final gainKilosController = TextEditingController();
  final durationController = TextEditingController();
  double caloriesPerDay = 0.0;

  void calculateCalories() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;
    int age = int.tryParse(ageController.text) ?? 0;
    double gainKilos = double.tryParse(gainKilosController.text) ?? 0.0;
    int duration = int.tryParse(durationController.text) ?? 0;

    // Coefficients utilisés dans la formule (en supposant qu'il s'agit d'une formule simplifiée)
    double weightCoefficient = 13.75; // coefficient fixe pour le poids
    double heightCoefficient = 5.003; // coefficient fixe pour la taille
    double ageCoefficient = 6.755; // coefficient fixe pour l'âge

    // Formule de calcul des calories basales sans le sexe
    double basalMetabolicRate = weightCoefficient * weight + heightCoefficient * height - ageCoefficient * age + 5;

    // Calcul des calories nécessaires pour gagner du poids
    caloriesPerDay = basalMetabolicRate + gainKilos * 770 / duration;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Couleur de la barre de navigation
        title: Text("Gain Weight"),
        leading: IconButton( // Bouton de retour à la page précédente
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                InputField(
                  hint: "Weight (kg)",
                  icon: Icons.person,
                  controller: weightController,
                ),
                InputField(
                  hint: "Height (cm)",
                  icon: Icons.height,
                  controller: heightController,
                ),
                InputField(
                  hint: "Age",
                  icon: Icons.calendar_today,
                  controller: ageController,
                ),
                InputField(
                  hint: "Kilos to Gain",
                  icon: Icons.fitness_center,
                  controller: gainKilosController,
                ),
                InputField(
                  hint: "Duration (months)",
                  icon: Icons.timer,
                  controller: durationController,
                ),

                SizedBox(height: 10),
                Button(
                  label: "Calculate Calories",
                  press: calculateCalories,
                ),

                SizedBox(height: 20),
                Text(
                  'Calories Per Day Needed: ${caloriesPerDay.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18.0),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
