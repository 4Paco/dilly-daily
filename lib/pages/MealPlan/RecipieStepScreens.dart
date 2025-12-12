import 'package:dilly_daily/models/Recipe.dart';
import 'package:flutter/material.dart' hide Step;

class RecipeStepsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeStepsScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeStepsScreen> createState() => _RecipeStepsScreenState();
}

class _RecipeStepsScreenState extends State<RecipeStepsScreen> {
  int currentStep = 0;

  void nextStep() {
    if (currentStep < widget.recipe.steps.length - 1) {
      setState(() => currentStep++);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.recipe.steps[currentStep];
    final recipe = widget.recipe;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// BIG STEP NUMBER
            Text(
              "${currentStep + 1}", // <-- ONLY THE NUMBER
              style: const TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// STEP TYPE (small + lighter color)
            Text(
              "${step.type.name[0].toUpperCase()}${step.type.name.substring(1)}",
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            /// STEP DESCRIPTION (center)
            Expanded(
              child: Center(
                child: Text(
                  step.description,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// INGREDIENTS SECTION
            Container(
              width: double.infinity, // <-- FULL WIDTH
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  ...step.ingredients.map(
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// BULLET
Container(
  width: 8,
  height: 8,
  margin: const EdgeInsets.only(top: 6, right: 10),
  decoration: BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer, // <-- guaranteed to contrast
    shape: BoxShape.circle,
  ),
),

                          /// TEXT
                          Expanded(
                            child: Text(
                              "${i.name}: ${i.quantity} ${i.unit.name}",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// NAVIGATION CONTROLS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: previousStep,
                  icon: const Icon(Icons.arrow_left, size: 36),
                ),
                Text(
                  "${currentStep + 1} / ${widget.recipe.steps.length}",
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: nextStep,
                  icon: const Icon(Icons.arrow_right, size: 36),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
