import 'package:dilly_daily/models/Step.dart' show Step, StepType;
import 'package:flutter/material.dart' hide Step;

class StepEditor extends StatefulWidget {
  final Step? step; // null pour création, non-null pour édition
  final Function(Step) onSave;
  final VoidCallback onCancel;

  const StepEditor({
    super.key,
    this.step,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<StepEditor> createState() => _StepEditorState();
}

class _StepEditorState extends State<StepEditor> {
  late TextEditingController _descriptionController;
  late int _durationMinutes;
  late StepType _selectedType;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.step?.description ?? '');
    _durationMinutes = widget.step?.duration?.inMinutes ?? 0;
    _selectedType = widget.step?.type ?? StepType.preparation;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme themeScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: themeScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type de step
          Row(
            children: [
              Text("Type: ", style: Theme.of(context).textTheme.labelLarge),
              ChoiceChip(
                label: Text("Preparation"),
                selected: _selectedType == StepType.preparation,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedType = StepType.preparation);
                  }
                },
              ),
              SizedBox(width: 8),
              ChoiceChip(
                label: Text("Cooking"),
                selected: _selectedType == StepType.cooking,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedType = StepType.cooking);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 12),

          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Step description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 12),

          // Durée
          Row(
            children: [
              Text("Duration: ", style: Theme.of(context).textTheme.labelLarge),
              SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: _durationMinutes.toString(),
                  decoration: InputDecoration(
                    suffixText: 'min',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _durationMinutes = int.tryParse(value) ?? 0;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Boutons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: Text("Cancel"),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (_descriptionController.text.isNotEmpty) {
                    widget.onSave(Step(
                      description: _descriptionController.text,
                      duration: Duration(minutes: _durationMinutes),
                      type: _selectedType,
                    ));
                  }
                },
                child: Text("Save step"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
