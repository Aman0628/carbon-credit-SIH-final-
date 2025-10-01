import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class CarbonCalculatorScreen extends ConsumerStatefulWidget {
  const CarbonCalculatorScreen({super.key});

  @override
  ConsumerState<CarbonCalculatorScreen> createState() => _CarbonCalculatorScreenState();
}

class _CarbonCalculatorScreenState extends ConsumerState<CarbonCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _electricityController = TextEditingController();
  final _fuelController = TextEditingController();
  final _transportController = TextEditingController();
  
  String _selectedCalculationType = 'business';
  double _totalEmissions = 0.0;
  double _creditsNeeded = 0.0;
  bool _isCalculated = false;

  final Map<String, String> _calculationTypes = {
    'business': 'Business Operations',
    'personal': 'Personal Footprint',
    'project': 'Project Assessment',
    'event': 'Event Planning',
  };

  @override
  void dispose() {
    _electricityController.dispose();
    _fuelController.dispose();
    _transportController.dispose();
    super.dispose();
  }

  void _calculateEmissions() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        double electricity = double.tryParse(_electricityController.text) ?? 0;
        double fuel = double.tryParse(_fuelController.text) ?? 0;
        double transport = double.tryParse(_transportController.text) ?? 0;

        // Emission factors (kg CO2 per unit)
        double electricityFactor = 0.82; // kg CO2 per kWh
        double fuelFactor = 2.31; // kg CO2 per liter
        double transportFactor = 0.21; // kg CO2 per km

        _totalEmissions = (electricity * electricityFactor) + 
                         (fuel * fuelFactor) + 
                         (transport * transportFactor);
        
        _creditsNeeded = _totalEmissions / 1000; // Convert to tonnes and credits
        _isCalculated = true;
      });
    }
  }

  void _resetCalculator() {
    setState(() {
      _electricityController.clear();
      _fuelController.clear();
      _transportController.clear();
      _totalEmissions = 0.0;
      _creditsNeeded = 0.0;
      _isCalculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCalculator,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Calculate Your Carbon Footprint',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your consumption data to calculate emissions and required carbon credits',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Calculation Type
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calculation Type',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedCalculationType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _calculationTypes.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCalculationType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Input Fields
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consumption Data',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Electricity Usage
                      TextFormField(
                        controller: _electricityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Electricity Usage (kWh/month)',
                          prefixIcon: Icon(Icons.electrical_services),
                          border: OutlineInputBorder(),
                          hintText: 'Enter monthly electricity consumption',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter electricity usage';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Fuel Usage
                      TextFormField(
                        controller: _fuelController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Fuel Usage (liters/month)',
                          prefixIcon: Icon(Icons.local_gas_station),
                          border: OutlineInputBorder(),
                          hintText: 'Enter monthly fuel consumption',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter fuel usage';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Transportation
                      TextFormField(
                        controller: _transportController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Transportation (km/month)',
                          prefixIcon: Icon(Icons.directions_car),
                          border: OutlineInputBorder(),
                          hintText: 'Enter monthly travel distance',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter transportation distance';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Calculate Button
              ElevatedButton(
                onPressed: _calculateEmissions,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Calculate Emissions'),
              ),
              const SizedBox(height: 24),

              // Results
              if (_isCalculated) ...[
                Card(
                  color: AppColors.primary.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.eco,
                          size: 48,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Calculation Results',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildResultItem(
                              'Total Emissions',
                              '${_totalEmissions.toStringAsFixed(2)} kg CO₂',
                              Icons.cloud,
                              AppColors.error,
                            ),
                            _buildResultItem(
                              'Credits Needed',
                              '${_creditsNeeded.toStringAsFixed(2)} credits',
                              Icons.verified,
                              AppColors.success,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        Text(
                          'Estimated Cost: ₹${(_creditsNeeded * 750).toStringAsFixed(0)}',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _resetCalculator,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Recalculate'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Redirecting to marketplace...'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Buy Credits'),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              // Information Card
              Card(
                color: AppColors.info.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.info,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'How It Works',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This calculator uses standard emission factors to estimate your carbon footprint. '
                        'Results are approximate and may vary based on actual conditions and energy sources.',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
