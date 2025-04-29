import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_employee/data/apis.dart';
import 'package:register_employee/features/attendance/domain/models/site_model.dart';

class RegisterEmployeePage extends StatefulWidget {
  const RegisterEmployeePage({super.key});

  @override
  State<RegisterEmployeePage> createState() => _RegisterEmployeePageState();
}

class _RegisterEmployeePageState extends State<RegisterEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _empIdController = TextEditingController();
  final _addressController = TextEditingController();
  final _aadharCardController = TextEditingController();
  final _salaryController = TextEditingController();
  String? _faceId;

  Map<String, dynamic> _employeeData = {};

  Site? _selectedSite;
  List<Site> _siteOptions = [
    Site(name: 'Site A'),
    Site(name: 'Site B'),
    Site(name: 'Site C')
  ];

  final TextEditingController _mobileNumberController =
      TextEditingController(); // Example sites

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Apis.availableSties().then(
      (value) {
        if (value?.isNotEmpty == true) {
          setState(() {
            _siteOptions = value ?? [];
          });
        }
      },
    );
  }

  void _submitForm() async {
    if (_employeeData.isNotEmpty &&
        _employeeData.containsKey("emp_id") &&
        _employeeData["emp_id"] == _empIdController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee ID already exists')),
      );
      return;
    }

    if (_formKey.currentState!.validate() && _faceId != null) {
      final employeeData = {
        "name": _nameController.text.trim(),
        "emp_id": _empIdController.text.trim(),
        "address": _addressController.text.trim(),
        "salary": _salaryController.text.trim(),
        'aadhar_card': _aadharCardController.text.trim(),
        'mobile_number': _mobileNumberController.text.trim(),
        "site_name": _selectedSite?.name ?? '',
        "face_metadata": _faceId
      };
      _employeeData = employeeData;
      debugPrint("Submitting: $employeeData");
      await Apis.registerEmployee(employeeData).then(
        (value) {
          if (value == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Employee Registered Successfully')),
            );
          }
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Face ID not given or invalid employee details')),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<Site>(
        value: _selectedSite,
        items: _siteOptions.map((site) {
          return DropdownMenuItem(value: site, child: Text(site.name ?? ''));
        }).toList(),
        onChanged: (val) {
          setState(() {
            _selectedSite = val;
          });
        },
        decoration: InputDecoration(
          labelText: "Site Name",
          labelStyle: GoogleFonts.inter(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null) {
            return 'Select Site Name';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Register Employee', style: GoogleFonts.inter(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Name", _nameController),
              _buildTextField("Employee ID", _empIdController),
              _buildTextField("Address", _addressController),
              _buildTextField("Aadhar Card", _aadharCardController,
                  type: TextInputType.visiblePassword),
              _buildTextField("Mobile Number", _mobileNumberController,
                  type: TextInputType.number),
              _buildTextField("Salary", _salaryController,
                  type: TextInputType.number),
              _buildDropdown(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor:
                      _faceId != null ? Colors.green : Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _navigateToFaceIdPage,
                child: Text(_faceId != null ? 'Face ID Given' : 'Give Face ID',
                    style: GoogleFonts.inter(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _submitForm,
                child: Text('Submit',
                    style: GoogleFonts.inter(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFaceIdPage() async {
    var result =
        await Navigator.of(context).pushNamed('/face_recognition_page');
    if (result is String && result.isNotEmpty) {
      setState(() {
        _faceId = result as String?;
      });
    }
  }
}
