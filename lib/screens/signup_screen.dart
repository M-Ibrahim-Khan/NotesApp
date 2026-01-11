import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await ref.read(authRepositoryProvider).signUp(
                      emailController.text,
                      passwordController.text,
                    );
                    if(context.mounted) {
                Navigator.pop(context);
                    }
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class Signup extends StatefulWidget {
//   const Signup({super.key});

//   @override
//   State<Signup> createState() => _SignupState();
// }

// class _SignupState extends State<Signup> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController    = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _isLoading = false;

//   Future<void> _signup() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       Navigator.pop(context);
//     } on FirebaseAuthException catch (e) {
//       final msg = (e.code == 'weak-password')
//         ? 'The password provided is too weak.'
//         : (e.code == 'email-already-in-use')
//           ? 'An account already exists for that email.'
//           : e.message ?? 'An error occurred.';
//       ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(msg)));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//           child: Center(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   'Create Account',
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 const SizedBox(height: 32),

//                 // Email
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     prefixIcon: const Icon(Icons.email),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[50],
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 12),
//                   ),
//                   validator: (v) => (v == null || !v.contains('@'))
//                       ? 'Enter a valid email.'
//                       : null,
//                 ),
//                 const SizedBox(height: 16),

//                 // Password
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon: const Icon(Icons.lock),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[50],
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 12),
//                   ),
//                   validator: (v) => (v == null || v.length < 8)
//                       ? 'Password must be at least 8 characters.'
//                       : null,
//                 ),
//                 const SizedBox(height: 24),

//                 // Sign Up Button
//                 _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           minimumSize: const Size.fromHeight(48),
//                         ),
//                         onPressed: _signup,
//                         child: const Text('Sign Up'),
//                       ),
//                 const SizedBox(height: 16),

//                 // Log In Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Already have an account?'),
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Log in'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           ),
//         ),
//       ),
//     );
//   }
// }