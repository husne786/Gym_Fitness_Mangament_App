import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:developer' as developer;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Editable Profile Screen',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Shaik');
  final _emailController = TextEditingController(text: 'shaik@gmail.com');
  final _phoneController = TextEditingController(text: '+91 9876543210');
  final _membershipIdController = TextEditingController(text: 'GYM12345');
  final _workoutGoalController = TextEditingController(text: 'Build Muscle');
  final _workoutTypeController =
      TextEditingController(text: 'Strength Training');
  bool _isEditingName = false;
  bool _isEditingEmail = false;
  bool _isEditingPhone = false;
  bool _isEditingMembershipId = false;
  bool _isEditingWorkoutGoal = false;
  bool _isEditingWorkoutType = false;
  File? _profileImage; // Store the selected image
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _membershipIdController.dispose();
    _workoutGoalController.dispose();
    _workoutTypeController.dispose();
    super.dispose();
  }

  // Function to pick an image from gallery or camera
  Future<void> _pickImage() async {
    setState(() => _isLoading = true);
    ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: const Text('Choose where to pick your profile image from.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (source != null) {
      try {
        XFile? pickedFile;
        if (source == ImageSource.gallery) {
          pickedFile = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
            maxWidth: 300,
            maxHeight: 300,
          );
        } else if (source == ImageSource.camera) {
          pickedFile = await _picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 80,
            maxWidth: 300,
            maxHeight: 300,
            preferredCameraDevice: CameraDevice.rear,
          );
        }

        if (pickedFile != null) {
          final file = File(pickedFile.path);
          if (await file.exists()) {
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Image'),
                content: Image.file(file,
                    width: 200, height: 200, fit: BoxFit.cover),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (!mounted) return;
                      setState(() => _profileImage = file);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile image updated')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Set Image'),
                  ),
                ],
              ),
            );
          } else {
            throw Exception('File does not exist at path: ${pickedFile.path}');
          }
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No image selected')),
          );
        }
      } catch (e) {
        developer.log('Image picking error: $e', name: 'ProfileScreen');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to pick image: ${e.toString()}\nPlease check permissions or try again.'),
            duration: const Duration(seconds: 3),
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleEditName() {
    setState(() => _isEditingName = !_isEditingName);
    if (!_isEditingName && _formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name updated')),
      );
    }
  }

  void _toggleEditEmail() {
    setState(() => _isEditingEmail = !_isEditingEmail);
    if (!_isEditingEmail && _formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email updated')),
      );
    }
  }

  void _toggleEditPhone() {
    setState(() => _isEditingPhone = !_isEditingPhone);
    if (!_isEditingPhone && _formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number updated')),
      );
    }
  }

  void _toggleEditMembershipId() {
    setState(() => _isEditingMembershipId = !_isEditingMembershipId);
    if (!_isEditingMembershipId && _formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membership ID updated')),
      );
    }
  }

  void _toggleEditWorkoutGoal() {
    setState(() => _isEditingWorkoutGoal = !_isEditingWorkoutGoal);
    if (!_isEditingWorkoutGoal && _formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout goal updated')),
      );
    }
  }

  void _toggleEditWorkoutType() {
    setState(() => _isEditingWorkoutType = !_isEditingWorkoutType);
    if (!_isEditingWorkoutType && _formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout type updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Color(0xFF40C4FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  if (_isLoading) const CircularProgressIndicator(),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _buildProfileAvatar(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person, color: Colors.grey),
                        errorMaxLines: 2,
                      ),
                      enabled: _isEditingName,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: _toggleEditName,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                        errorMaxLines: 2,
                      ),
                      enabled: _isEditingEmail,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: _toggleEditEmail,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone, color: Colors.grey),
                        errorMaxLines: 2,
                      ),
                      enabled: _isEditingPhone,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: _toggleEditPhone,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _membershipIdController,
                      decoration: const InputDecoration(
                        labelText: 'Gym Membership ID',
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.fitness_center, color: Colors.grey),
                        errorMaxLines: 2,
                      ),
                      enabled: _isEditingMembershipId,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your membership ID';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: _toggleEditMembershipId,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _workoutGoalController,
                      decoration: const InputDecoration(
                        labelText: 'Workout Goal',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flag, color: Colors.grey),
                        errorMaxLines: 2,
                      ),
                      enabled: _isEditingWorkoutGoal,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your workout goal';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: _toggleEditWorkoutGoal,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _workoutTypeController,
                      decoration: const InputDecoration(
                        labelText: 'Preferred Workout Type',
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.directions_run, color: Colors.grey),
                        errorMaxLines: 2,
                      ),
                      enabled: _isEditingWorkoutType,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your preferred workout type';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: _toggleEditWorkoutType,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipOval(
          child: _profileImage != null
              ? Image.file(
                  _profileImage!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    developer.log('Image file error: $error',
                        name: 'ProfileScreen');
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
              : Image.asset(
                  'assets/images/profile.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    developer.log('Asset image error: $error',
                        name: 'ProfileScreen');
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _pickImage,
            splashColor: Colors.blue.withAlpha(77),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
