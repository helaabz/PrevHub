import 'package:flutter/material.dart';
import '../../../widgets/app_button.dart';

class FiltresModal extends StatefulWidget {
  const FiltresModal({super.key});

  @override
  State<FiltresModal> createState() => _FiltresModalState();
}

class _FiltresModalState extends State<FiltresModal> {
  RangeValues _periodRange = const RangeValues(0, 100);
  double _complexity = 1;
  bool _urgentOnly = false;
  bool _noCandidates = false;
  String _sortBy = 'date';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filtres',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _periodRange = const RangeValues(0, 100);
                          _complexity = 1;
                          _urgentOnly = false;
                          _noCandidates = false;
                          _sortBy = 'date';
                        });
                      },
                      child: const Text('Réinitialiser'),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Période'),
                      const SizedBox(height: 12),
                      RangeSlider(
                        values: _periodRange,
                        onChanged: (values) => setState(() => _periodRange = values),
                        min: 0,
                        max: 100,
                      ),
                      const Text(
                        'Nov 2023',
                        style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Complexité'),
                      const SizedBox(height: 12),
                      Slider(
                        value: _complexity,
                        onChanged: (value) => setState(() => _complexity = value),
                        min: 1,
                        max: 3,
                        divisions: 2,
                        label: 'Niveau ${_complexity.toInt()}',
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Critères spécifiques'),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        value: _urgentOnly,
                        onChanged: (value) => setState(() => _urgentOnly = value),
                        title: const Text('Missions urgentes seulement'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      SwitchListTile(
                        value: _noCandidates,
                        onChanged: (value) => setState(() => _noCandidates = value),
                        title: const Text('Missions sans candidat'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Trier par'),
                      const SizedBox(height: 12),
                      RadioListTile<String>(
                        value: 'date',
                        groupValue: _sortBy,
                        onChanged: (value) => setState(() => _sortBy = value!),
                        title: const Text('Date de début (croissant)'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      RadioListTile<String>(
                        value: 'complexity',
                        groupValue: _sortBy,
                        onChanged: (value) => setState(() => _sortBy = value!),
                        title: const Text('Complexité (faible à élevée)'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      RadioListTile<String>(
                        value: 'distance',
                        groupValue: _sortBy,
                        onChanged: (value) => setState(() => _sortBy = value!),
                        title: const Text('Distance (plus proche)'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
              ),
              // CTA Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: AppButton(
                  text: 'Voir 12 missions',
                  onPressed: () => Navigator.pop(context),
                  variant: ButtonVariant.primary,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
      ),
    );
  }
}

