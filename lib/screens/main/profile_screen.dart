import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/auth_provider.dart' as ap;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController    = TextEditingController();
  final phoneController   = TextEditingController();
  final addressController = TextEditingController();

  bool isLoading      = false;
  bool isSaving       = false;
  bool _dataLoaded    = false;
  bool _notifications = true;
  bool _darkMode      = false;

  
  static const bgColor     = Color(0xFF1A0F0A);
  static const cardColor   = Color(0xFF2C1A12);
  static const accentColor = Color(0xFFD7A86E);
  static const textLight   = Color(0xFFFFF8F0);
  static const textMuted   = Color(0xFF9E7B5E);
  static const inputFill   = Color(0xFF3B2318);

  Future<void> loadUserData(String uid) async {
    if (_dataLoaded) return;
    _dataLoaded = true;
    setState(() => isLoading = true);

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = doc.data();
    if (data != null && mounted) {
      setState(() {
        nameController.text    = data['name'] ?? '';
        phoneController.text   = data['phone'] ?? '';
        addressController.text = data['address'] ?? '';
      });
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> saveProfile(String uid, String email, String? photo) async {
    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name':    nameController.text,
        'phone':   phoneController.text,
        'address': addressController.text,
        'email':   email,
        'photo':   photo,
        'role':    'customer',
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: accentColor,
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text("Profile saved!", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    if (mounted) setState(() => isSaving = false);
  }

  Future<void> handleLogout(ap.AuthProvider auth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Logout", style: TextStyle(color: textLight)),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel", style: TextStyle(color: textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    await auth.logout();
  }

  
  void _showAboutUs() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5ECD7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF3E2723),
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                      const Expanded(
                        child: Text(
                          "About Us",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // balance back button
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    children: [

                      
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF3E2723),
                          border: Border.all(color: accentColor, width: 3),
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      
                      const Text(
                        "KapeTayo ☕",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723),
                        ),
                      ),

                      const SizedBox(height: 14),

                      
                      const Text(
                        "A mobile coffee ordering application that allows customers to browse, order, and enjoy their favorite coffee anytime and anywhere.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5D3A1A),
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE0CC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFD7A86E).withOpacity(0.4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            
                            const Center(
                              child: Text(
                                "Developed By",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            
                            _developerRow("Jonna Icawat"),
                            const SizedBox(height: 12),
                            
                            _developerRow("Jasmine Rose Padilla"),
                            const SizedBox(height: 12),
                            
                            _developerRow("Rica Icaro"),

                            const SizedBox(height: 6),

                            
                            const Padding(
                              padding: EdgeInsets.only(left: 52),
                              child: Text(
                                "BS Information Technology  3rd Year\nCATSU",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF7A4A2A),
                                  height: 1.5,
                                ),
                              ),
                            ),

                            const Divider(
                              color: Color(0xFFD7A86E),
                              height: 28,
                              thickness: 0.5,
                            ),

                            
                            Row(
                              children: const [
                                Icon(Icons.email_outlined,
                                    color: Color(0xFF3E2723), size: 18),
                                SizedBox(width: 10),
                                Text(
                                  "kapetayo.dev@gmail.com",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF5D3A1A),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            
                            Row(
                              children: const [
                                Icon(Icons.phone_outlined,
                                    color: Color(0xFF3E2723), size: 18),
                                SizedBox(width: 10),
                                Text(
                                  "09XXXXXXXXX",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF5D3A1A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                     
                      const Text(
                        "© 2026 KapeTayo App\nAll Rights Reserved",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E7B5E),
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 
  Widget _developerRow(String name) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF3E2723),
          child: const Icon(Icons.person, color: Colors.white70, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<ap.AuthProvider>(context);
    final user = auth.user ?? FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("No user logged in"));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => loadUserData(user.uid));

    return Container(
      color: bgColor,
      child: isLoading
          ? const Center(child: CircularProgressIndicator(color: accentColor))
          : SingleChildScrollView(
              child: Column(
                children: [

                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3E2723), Color(0xFF1A0F0A)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: accentColor, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: cardColor,
                                backgroundImage: user.photoURL != null
                                    ? NetworkImage(user.photoURL!)
                                    : null,
                                child: user.photoURL == null
                                    ? const Icon(Icons.person,
                                        size: 50, color: accentColor)
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.coffee,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          nameController.text.isEmpty
                              ? "Coffee Lover ☕"
                              : nameController.text,
                          style: const TextStyle(
                            color: textLight,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: accentColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            user.email ?? "",
                            style: const TextStyle(color: accentColor, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        
                        _sectionCard(
                          icon: Icons.person_outline,
                          title: "Personal Information",
                          child: Column(
                            children: [
                              _darkTextField(
                                controller: nameController,
                                label: "Full Name",
                                icon: Icons.badge_outlined,
                              ),
                              const SizedBox(height: 12),
                              _darkTextField(
                                controller: phoneController,
                                label: "Phone Number",
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                       
                        _sectionCard(
                          icon: Icons.location_on_outlined,
                          title: "Delivery Address",
                          child: _darkTextField(
                            controller: addressController,
                            label: "Your Address",
                            icon: Icons.home_outlined,
                            maxLines: 2,
                          ),
                        ),

                        const SizedBox(height: 12),

                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: isSaving
                                ? null
                                : () => saveProfile(
                                      user.uid,
                                      user.email ?? "",
                                      user.photoURL,
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                              shadowColor: accentColor.withOpacity(0.4),
                            ),
                            icon: isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save_outlined),
                            label: Text(
                              isSaving ? "Saving..." : "Save Profile",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        
                        _sectionCard(
                          icon: Icons.tune_outlined,
                          title: "Preferences",
                          child: Column(
                            children: [
                              _settingsRow(
                                icon: Icons.location_on_outlined,
                                label: "Saved Addresses",
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Saved Addresses coming soon!")),
                                  );
                                },
                              ),
                              _divider(),
                              _settingsRowToggle(
                                icon: Icons.notifications_outlined,
                                label: "Notifications",
                                value: _notifications,
                                onChanged: (val) =>
                                    setState(() => _notifications = val),
                              ),
                              _divider(),
                              _settingsRowToggle(
                                icon: Icons.dark_mode_outlined,
                                label: "Dark Mode",
                                value: _darkMode,
                                onChanged: (val) =>
                                    setState(() => _darkMode = val),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        
                        _sectionCard(
                          icon: Icons.help_outline,
                          title: "Support",
                          child: Column(
                            children: [
                              _settingsRow(
                                icon: Icons.help_center_outlined,
                                label: "Help Center",
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Help Center coming soon!")),
                                  );
                                },
                              ),
                              _divider(),

                              
                              _settingsRow(
                                icon: Icons.info_outline,
                                label: "About App",
                                onTap: _showAboutUs,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => handleLogout(auth),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                            ),
                            icon: const Icon(Icons.logout),
                            label: const Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Version 1.0.0",
                          style: TextStyle(color: textMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Developed by JJR 🖥️",
                          style: TextStyle(color: textMuted, fontSize: 12),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  
  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3D2314)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  
  Widget _settingsRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: textMuted, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: textLight, fontSize: 14),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: textMuted),
          ],
        ),
      ),
    );
  }

  
  Widget _settingsRowToggle({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        children: [
          Icon(icon, color: textMuted, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: textLight, fontSize: 14),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: accentColor,
            activeTrackColor: accentColor.withOpacity(0.4),
            inactiveThumbColor: textMuted,
            inactiveTrackColor: const Color(0xFF4A2C1A),
          ),
        ],
      ),
    );
  }

  
  Widget _divider() => const Divider(color: Color(0xFF3D2314), height: 1);

  
  Widget _darkTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: textLight),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textMuted),
        prefixIcon: Icon(icon, color: textMuted, size: 20),
        filled: true,
        fillColor: inputFill,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4A2C1A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accentColor, width: 1.5),
        ),
      ),
    );
  }
}