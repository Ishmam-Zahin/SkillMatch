import 'dart:io';
import 'package:flutter/material.dart';
import 'package:worklance/bloc/blocs/image_bloc.dart';
import 'package:worklance/bloc/blocs/user_bloc.dart';
import 'package:worklance/bloc/events/image_events.dart';
import 'package:worklance/bloc/events/user_event.dart';
import 'package:worklance/bloc/states/image_states.dart';
import 'package:worklance/bloc/states/user_state.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worklance/widgets/skill_chip_selector.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _signUpFormKey = GlobalKey<FormState>();
  String? _fullName;
  String? _email;
  String? _password;
  String? _phone;
  String? _address;
  XFile? _image;
  List<String> _skills = [];

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Worklance',
                style: TextStyle(
                  fontFamily: 'Wet',
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                'Create your account now!',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Form(
                key: _signUpFormKey,
                child: Column(
                  children: [
                    _buildTextFormField(
                      hintText: 'Full name/Company name',
                      icon: Icons.manage_accounts,
                      onSaved: (value) => _fullName = value,
                    ),
                    const SizedBox(height: 12),
                    _buildTextFormField(
                      hintText: 'Enter your email address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _email = value,
                    ),
                    const SizedBox(height: 12),
                    _buildTextFormField(
                      hintText: 'Enter your password',
                      icon: Icons.key,
                      obscureText: true,
                      onSaved: (value) => _password = value,
                    ),
                    const SizedBox(height: 12),
                    _buildTextFormField(
                      hintText: 'Phone number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => _phone = value,
                    ),
                    const SizedBox(height: 12),
                    _buildTextFormField(
                      hintText: 'Company address',
                      icon: Icons.home,
                      onSaved: (value) => _address = value,
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<MyImageBloc, MyImageStates>(
                      listener: (context, state) {
                        if (state is ImageLoadedState) {
                          _image = state.image;
                        } else if (state is ImageErrorSate) {
                          _image = null;
                          _showSnackBar(context, state.error, Colors.red);
                        }
                      },
                      builder: (context, state) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<MyImageBloc>().add(LoadImageEvent());
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: _image != null
                                  ? FileImage(File(_image!.path))
                                  : null,
                              child: _image == null
                                  ? Icon(
                                      Icons.camera_alt,
                                      size: 30,
                                      color: Colors.grey.shade700,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Select a profile image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SkillChipSelector(
                      selectedSkills: _skills,
                      onChanged: (skills) => setState(() => _skills = skills),
                      label: 'Choose your skills',
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<AuthUserBloc, UserState>(
                      listener: (context, state) {
                        if (state is AuthenticateUserSate) {
                          Get.back();
                        } else if (state is CreateAuthUserErrorState) {
                          _showSnackBar(context, state.error, Colors.red);
                        }
                      },
                      builder: (context, state) => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_image == null) {
                              _showSnackBar(
                                context,
                                'You must provide an image!',
                                Colors.red,
                              );
                              return;
                            }
                            if (_signUpFormKey.currentState!.validate()) {
                              _signUpFormKey.currentState!.save();
                              context.read<AuthUserBloc>().add(
                                CreateUserEvent(
                                  name: _fullName!,
                                  email: _email!,
                                  password: _password!,
                                  phone: _phone!,
                                  address: _address!,
                                  image: _image!,
                                  skills: _skills,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: state is CreateLoadingUserState
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'LOG IN',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: Colors.blueAccent, // Set icon color to match theme
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Consistent rounded borders
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field can\'t be empty';
        }
        if (obscureText && value.length < 8) {
          return 'minimum 8 characters long';
        }

        return null;
      },
      onSaved: onSaved,
    );
  }
}
