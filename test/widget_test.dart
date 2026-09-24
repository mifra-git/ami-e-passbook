import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  bool _showAccountNumber = false;
  bool _isUploadingPhoto = false;

  // Local profile image
  Uint8List? _profileImageBytes;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadLocalProfilePhoto();
  }

  // ============================================================
  // LOCAL PROFILE PHOTO KEY
  // ============================================================

  String _profilePhotoKey() {
    final User? user = _auth.currentUser;

    if (user == null) {
      return 'profile_image_unknown';
    }

    // Each Firebase user gets their own local image.
    return 'profile_image_${user.uid}';
  }

  // ============================================================
  // LOAD LOCAL PROFILE PHOTO
  // ============================================================

  Future<void> _loadLocalProfilePhoto() async {
    try {
      final SharedPreferences prefs =
          await SharedPreferences.getInstance();

      final String? savedImage =
          prefs.getString(_profilePhotoKey());

      if (savedImage == null || savedImage.isEmpty) {
        return;
      }

      final Uint8List imageBytes =
          base64Decode(savedImage);

      if (!mounted) return;

      setState(() {
        _profileImageBytes = imageBytes;
      });

      debugPrint('Local profile image loaded.');
      debugPrint('Image bytes: ${imageBytes.length}');
    } catch (e) {
      debugPrint(
        'Unable to load local profile image: $e',
      );
    }
  }

  // ============================================================
  // GET CURRENT USER DATA
  // ============================================================

  Future<DocumentSnapshot<Map<String, dynamic>>>
      _getUserData() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No user is currently logged in.',
      );
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .get();
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  Future<void> _changePassword() async {
    final User? user = _auth.currentUser;

    if (user == null || user.email == null) {
      _showMessage(
        'No email address is associated with this account.',
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(
        email: user.email!,
      );

      if (!mounted) return;

      _showMessage(
        'Password reset email sent successfully.',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      _showMessage(
        e.message ??
            'Unable to send password reset email.',
      );
    }
  }

  // ============================================================
  // PICK PROFILE PHOTO
  // ============================================================

  Future<void> _changeProfilePhoto() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      _showMessage('Please login again.');
      return;
    }

    try {
      final XFile? pickedFile =
          await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (pickedFile == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        _isUploadingPhoto = true;
      });

      // ========================================================
      // READ IMAGE BYTES
      // ========================================================

      debugPrint('=================================');
      debugPrint('LOCAL PROFILE PHOTO');
      debugPrint('USER UID: ${user.uid}');
      debugPrint('=================================');

      final Uint8List imageBytes =
          await pickedFile.readAsBytes();

      debugPrint(
        'Image bytes: ${imageBytes.length}',
      );

      // ========================================================
      // CONVERT IMAGE TO BASE64
      // ========================================================

      final String base64Image =
          base64Encode(imageBytes);

      // ========================================================
      // SAVE IMAGE LOCALLY
      // ========================================================

      final SharedPreferences prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        _profilePhotoKey(),
        base64Image,
      );

      debugPrint(
        'Profile image saved locally.',
      );

      // ========================================================
      // UPDATE SCREEN IMMEDIATELY
      // ========================================================

      if (!mounted) return;

      setState(() {
        _profileImageBytes = imageBytes;
        _isUploadingPhoto = false;
      });

      _showMessage(
        'Profile picture updated successfully.',
      );
    } catch (e, stackTrace) {
      debugPrint('=================================');
      debugPrint('LOCAL IMAGE ERROR');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('=================================');

      if (!mounted) return;

      setState(() {
        _isUploadingPhoto = false;
      });

      _showMessage(
        'Unable to change profile picture.',
      );
    }
  }

  // ============================================================
  // REMOVE PROFILE PHOTO
  // ============================================================

  Future<void> _removeProfilePhoto() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      if (mounted) {
        setState(() {
          _isUploadingPhoto = true;
        });
      }

      // ========================================================
      // REMOVE LOCAL IMAGE
      // ========================================================

      final SharedPreferences prefs =
          await SharedPreferences.getInstance();

      await prefs.remove(
        _profilePhotoKey(),
      );

      debugPrint(
        'Local profile image removed.',
      );

      if (!mounted) return;

      setState(() {
        _profileImageBytes = null;
        _isUploadingPhoto = false;
      });

      _showMessage(
        'Profile picture removed.',
      );
    } catch (e) {
      debugPrint(
        'Unable to remove local profile photo: $e',
      );

      if (!mounted) return;

      setState(() {
        _isUploadingPhoto = false;
      });

      _showMessage(
        'Unable to remove profile picture.',
      );
    }
  }

  // ============================================================
  // PHOTO OPTIONS
  // ============================================================

  void _showPhotoOptions(bool hasPhoto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Profile Picture',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // CHOOSE FROM GALLERY
                // =================================================

                ListTile(
                  leading: Container(
                    padding:
                        const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFEAF1FA),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons
                          .photo_library_outlined,
                      color:
                          Color(0xFF123C73),
                    ),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Select a photo from your phone',
                  ),
                  onTap: () {
                    Navigator.pop(
                      bottomSheetContext,
                    );

                    _changeProfilePhoto();
                  },
                ),

                // =================================================
                // REMOVE PHOTO
                // =================================================

                if (hasPhoto)
                  ListTile(
                    leading: Container(
                      padding:
                          const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color:
                            Colors.red.shade700,
                      ),
                    ),
                    title: const Text(
                      'Remove Profile Picture',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Remove your current photo',
                    ),
                    onTap: () async {
                      Navigator.pop(
                        bottomSheetContext,
                      );

                      final bool? confirm =
                          await _confirmRemovePhoto();

                      if (confirm == true) {
                        await _removeProfilePhoto();
                      }
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // CONFIRM REMOVE PHOTO
  // ============================================================

  Future<bool?> _confirmRemovePhoto() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Remove Picture',
          ),
          content: const Text(
            'Are you sure you want to remove your profile picture?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Unable to logout. Please try again.',
      );
    }
  }

  // ============================================================
  // CONFIRM LOGOUT
  // ============================================================

  Future<void> _confirmLogout() async {
    final bool? confirm =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Logout',
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _logout();
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
  }

  // ============================================================
  // GET INITIALS
  // ============================================================

  String _getInitials(String name) {
    final String cleanName =
        name.trim();

    if (cleanName.isEmpty) {
      return 'U';
    }

    final List<String> parts =
        cleanName.split(
      RegExp(r'\s+'),
    );

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'
        .toUpperCase();
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _profileCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.shade300,
        ),
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Icon(
          icon,
          color: const Color(0xFF123C73),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        subtitle: Text(
          value.isEmpty
              ? 'Not available'
              : value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor:
            const Color(0xFF123C73),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ========================================================
      // USER DATA
      // ========================================================

      body: FutureBuilder<
          DocumentSnapshot<
              Map<String, dynamic>>>(
        future: _getUserData(),

        builder: (context, snapshot) {
          // ======================================================
          // LOADING
          // ======================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color: Color(0xFF123C73),
              ),
            );
          }

          // ======================================================
          // ERROR
          // ======================================================

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Unable to load profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${snapshot.error}',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ======================================================
          // PROFILE NOT FOUND
          // ======================================================

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Profile not found.',
              ),
            );
          }

          final Map<String, dynamic> data =
              snapshot.data!.data() ?? {};

          // ======================================================
          // USER DATA
          // ======================================================

          final User? currentUser =
              _auth.currentUser;

          final String name =
              data['name']
                          ?.toString()
                          .trim()
                          .isNotEmpty ==
                      true
                  ? data['name'].toString()
                  : 'Customer';

          final String email =
              data['email']?.toString() ??
                  currentUser?.email ??
                  '';

          final String customerId =
              data['customerId']
                      ?.toString() ??
                  'N/A';

          final String accountNumber =
              data['accountNumber']
                      ?.toString() ??
                  'N/A';

          final String accountType =
              data['accountType']
                      ?.toString() ??
                  'Savings';

          // IMPORTANT:
          // We no longer use profileImageUrl
          // because Firebase Storage is not used.

          final bool hasPhoto =
              _profileImageBytes != null;

          final String initials =
              _getInitials(name);

          final String maskedAccountNumber =
              accountNumber.length > 4
                  ? '**** ${accountNumber.substring(accountNumber.length - 4)}'
                  : accountNumber;

          // ======================================================
          // PROFILE PAGE
          // ======================================================

          return RefreshIndicator(
            color:
                const Color(0xFF123C73),

            onRefresh: () async {
              await _loadLocalProfilePhoto();

              setState(() {});

              await Future.delayed(
                const Duration(
                  milliseconds: 500,
                ),
              );
            },

            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),

              padding:
                  const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                30,
              ),

              children: [
                // =================================================
                // PROFILE PHOTO
                // =================================================

                Center(
                  child: Stack(
                    alignment:
                        Alignment.bottomRight,
                    children: [
                      Container(
                        width: 115,
                        height: 115,
                        decoration:
                            BoxDecoration(
                          shape:
                              BoxShape.circle,
                          color:
                              const Color(
                                  0xFF123C73),
                          border:
                              Border.all(
                            color:
                                Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withAlpha(
                                      25),
                              blurRadius: 15,
                              offset:
                                  const Offset(
                                0,
                                6,
                              ),
                            ),
                          ],
                        ),

                        child: ClipOval(
                          child:
                              _profileImageBytes !=
                                      null
                                  ? Image.memory(
                                      _profileImageBytes!,
                                      width: 115,
                                      height: 115,
                                      fit: BoxFit
                                          .cover,
                                    )
                                  : Center(
                                      child:
                                          Text(
                                        initials,
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize:
                                              34,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                        ),
                      ),

                      // =================================================
                      // CAMERA BUTTON
                      // =================================================

                      Material(
                        color:
                            const Color(
                                0xFF123C73),
                        elevation: 4,
                        shape:
                            const CircleBorder(),

                        child: InkWell(
                          customBorder:
                              const CircleBorder(),

                          onTap:
                              _isUploadingPhoto
                                  ? null
                                  : () {
                                      _showPhotoOptions(
                                        hasPhoto,
                                      );
                                    },

                          child: Container(
                            width: 42,
                            height: 42,
                            decoration:
                                const BoxDecoration(
                              shape:
                                  BoxShape.circle,
                            ),

                            child: Center(
                              child:
                                  _isUploadingPhoto
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth:
                                                2,
                                            color:
                                                Colors.white,
                                          ),
                                        )
                                      : const Icon(
                                          Icons
                                              .camera_alt,
                                          color:
                                              Colors.white,
                                          size: 20,
                                        ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Tap the camera icon to change your photo',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 18),

                // =================================================
                // NAME
                // =================================================

                Text(
                  name,
                  textAlign:
                      TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF123C73),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  email,
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 28),

                // =================================================
                // CUSTOMER ID
                // =================================================

                Container(
                  padding:
                      const EdgeInsets.all(18),

                  decoration:
                      BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xFF123C73),
                        Color(0xFF1D5A9D),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(
                            18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withAlpha(20),
                        blurRadius: 12,
                        offset:
                            const Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withAlpha(30),
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      13),
                        ),
                        child:
                            const Icon(
                          Icons
                              .badge_outlined,
                          color:
                              Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              'Customer ID',
                              style:
                                  TextStyle(
                                color: Colors
                                    .white70,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(
                              height: 3,
                            ),

                            Text(
                              customerId,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 17,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // PERSONAL INFORMATION
                // =================================================

                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _profileCard(
                  icon:
                      Icons.person_outline,
                  title: 'Full Name',
                  value: name,
                ),

                _profileCard(
                  icon:
                      Icons.email_outlined,
                  title: 'Email Address',
                  value: email,
                ),

                const SizedBox(height: 18),

                // =================================================
                // ACCOUNT INFORMATION
                // =================================================

                const Text(
                  'Account Information',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    side: BorderSide(
                      color:
                          Colors.grey.shade300,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                            15),
                  ),

                  child: ListTile(
                    contentPadding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),

                    leading: const Icon(
                      Icons
                          .credit_card_outlined,
                      color:
                          Color(0xFF123C73),
                    ),

                    title: Text(
                      'Account Number',
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),

                    subtitle: Text(
                      _showAccountNumber
                          ? accountNumber
                          : maskedAccountNumber,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    trailing:
                        IconButton(
                      onPressed: () {
                        setState(() {
                          _showAccountNumber =
                              !_showAccountNumber;
                        });
                      },

                      icon: Icon(
                        _showAccountNumber
                            ? Icons
                                .visibility_off_outlined
                            : Icons
                                .visibility_outlined,
                        color:
                            const Color(
                                0xFF123C73),
                      ),
                    ),
                  ),
                ),

                _profileCard(
                  icon: Icons
                      .account_balance_outlined,
                  title: 'Account Type',
                  value: accountType,
                ),

                const SizedBox(height: 18),

                // =================================================
                // SECURITY
                // =================================================

                const Text(
                  'Security',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    side: BorderSide(
                      color:
                          Colors.grey.shade300,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                            15),
                  ),

                  child: ListTile(
                    contentPadding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),

                    leading: const Icon(
                      Icons.lock_outline,
                      color:
                          Color(0xFF123C73),
                    ),

                    title: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    subtitle: const Text(
                      'Reset your account password',
                    ),

                    trailing:
                        const Icon(
                      Icons
                          .arrow_forward_ios,
                      size: 16,
                    ),

                    onTap:
                        _changePassword,
                  ),
                ),

                const SizedBox(height: 28),

                // =================================================
                // LOGOUT
                // =================================================

                SizedBox(
                  height: 54,

                  child:
                      OutlinedButton.icon(
                    onPressed:
                        _confirmLogout,

                    icon: const Icon(
                      Icons.logout,
                    ),

                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(
                              0xFF123C73),

                      side:
                          const BorderSide(
                        color:
                            Color(0xFF123C73),
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // APP VERSION
                // =================================================

                Text(
                  'AMI E-Passbook',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Version 1.0.0',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}

