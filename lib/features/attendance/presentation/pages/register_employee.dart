import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_employee/core/utils/time_utils.dart';
import 'package:register_employee/data/apis.dart';
import 'package:register_employee/features/attendance/domain/models/shift_model.dart';
import 'package:register_employee/features/attendance/domain/models/site_model.dart';
import 'package:register_employee/helpers/storage_helper.dart';
import 'package:register_employee/routes/app_router.dart';

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
  final _accountNumberController = TextEditingController();
  String? _faceId;

  Map<String, dynamic> _employeeData = {};

  Site? _selectedSite;
  Shift? _selectedShift;

  List<Shift> _shiftOptions = [];
  List<Site> _siteOptions = [
    // Site(name: 'Site A'),
    // Site(name: 'Site B'),
    // Site(name: 'Site C')
  ];

  bool _registerEmployee = false;

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

    Apis.shifts().then(
      (value) {
        if (value?.isNotEmpty == true) {
          setState(() {
            _shiftOptions = value ?? [];
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
        "account_number": _accountNumberController.text.trim(),
        'aadhar_card': _aadharCardController.text.trim(),
        'mobile_number': _mobileNumberController.text.trim(),
        "site_name": _selectedSite?.name ?? '',
        "face_metadata": _faceId,
        "shift_id": _selectedShift?.id ?? '',
      };
      _employeeData = employeeData;
      debugPrint("Submitting: $employeeData");
      setState(() {
        _registerEmployee = true;
      });
      await Apis.registerEmployee(employeeData).then(
        (value) {
          setState(() {
            _registerEmployee = false;
          });
          if (value == true) {
            setState(() {
              _faceId = null;
            });
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  "Success",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  "Employee ${_nameController.text} registered successfully",
                  style: TextStyle(fontSize: 16),
                ),
                actionsPadding: const EdgeInsets.only(right: 8, bottom: 8),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              ),
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
          labelText: "Select Site",
          labelStyle: GoogleFonts.inter(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null) {
            return 'Select Site';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownForShift() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<Shift>(
        value: _selectedShift,
        items: _shiftOptions.map((site) {
          return DropdownMenuItem(
              value: site,
              child: Text(site.clockIn?.toTimeOfDay.format(context) ?? ''));
        }).toList(),
        onChanged: (val) {
          setState(() {
            _selectedShift = val;
          });
        },
        decoration: InputDecoration(
          labelText: "Select Shift",
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
        actions: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8).copyWith(right: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: loading ? Colors.grey.shade300 : Colors.redAccent),
            child: InkWell(
              onTap: loading ? null : _logout,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.output_outlined,
                    color: Colors.white,
                  ),
                  Text(
                    " Logout",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Flexible(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField("Name", _nameController),
                    _buildTextField("Employee ID", _empIdController),
                    _buildTextField("Address", _addressController),
                    _buildTextField("Aadhar Card", _aadharCardController,
                        type: TextInputType.visiblePassword),
                    _buildTextField("Mobile Number", _mobileNumberController,
                        type: TextInputType.number),
                    _buildTextField("Account Number", _accountNumberController,
                        type: TextInputType.visiblePassword),
                    _buildDropdown(),
                    _buildDropdownForShift()
                  ],
                ),
              )),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 45),
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
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 45),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor:
                      _registerEmployee ? Colors.white38 : Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _registerEmployee ? null : _submitForm,
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

  bool loading = false;

  void _logout() async {
    setState(() {
      loading = true;
    });
    final key = await StorageHelper().getAdminToken();
    if (key?.isNotEmpty == true) {
      await Apis.logout(key!).then(
        (value) async {
          if (value) {
            setState(() {
              loading = false;
            });
            await StorageHelper().clearToken();
            _showSnackbar('Logout successful');
            Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);
          }
        },
      ).catchError((error) {
        setState(() {
          loading = false;
        });
        _showSnackbar(error.toString(), error: false);
      });
    }
  }

  void _showSnackbar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }
}
