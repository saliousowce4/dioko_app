import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../manager/payment_providers.dart';
import '../manager/payment_state.dart';


class CreatePaymentBottomSheet extends ConsumerStatefulWidget {
  const CreatePaymentBottomSheet({super.key});

  @override
  ConsumerState<CreatePaymentBottomSheet> createState() => _CreatePaymentBottomSheetState();
}

class _CreatePaymentBottomSheetState extends ConsumerState<CreatePaymentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;
  PlatformFile? _selectedFile;

  final List<String> _categories = ['Internet', 'Loyer', 'Électricité', 'Eau', 'Services Divers'];

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg'],
      withData: kIsWeb, // Important: Tells file_picker to load bytes on web
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first; // <-- Get the PlatformFile
      });
    }
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please attach a receipt'), backgroundColor: Colors.orange),
        );
        return;
      }

      ref.read(paymentNotifierProvider.notifier).createPayment(
        description: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        category: _selectedCategory!,
        attachment: _selectedFile!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to state changes to show feedback and close the sheet
    ref.listen<PaymentState>(paymentNotifierProvider, (previous, next) {
      if (next is PaymentError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      } else if (next is PaymentSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment created successfully!'), backgroundColor: Colors.green),
        );
        // Close the bottom sheet on success
        Navigator.of(context).pop();
      }
    });

    final paymentState = ref.watch(paymentNotifierProvider);
    final isLoading = paymentState is PaymentLoading;

    return Padding(
      // Padding to account for the keyboard
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('New Payment', style: Theme.of(context).textTheme.titleLarge),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Description (e.g., Internet bill for August)',
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _amountController,
                labelText: 'Amount',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter an amount';
                  if (double.tryParse(value) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text('Select Category'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(value: category, child: Text(category));
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedCategory = newValue),
                validator: (value) => value == null ? 'Please select a category' : null,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.attach_file),
                label: Text(_selectedFile == null ? 'Attach Receipt (PDF, JPG)' : 'File attached!'),
                onPressed: _pickFile,
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Submit Payment',
                onPressed: _submitPayment,
                isLoading: isLoading,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}