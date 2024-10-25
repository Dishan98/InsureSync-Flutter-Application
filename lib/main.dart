import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enterprise_mobility_assignment/policy_form.dart';
import 'package:enterprise_mobility_assignment/sign_up_page.dart';
import 'package:enterprise_mobility_assignment/submit_claim.dart';
import 'package:enterprise_mobility_assignment/view_policies_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.enablePersistence();
  runApp(InsureTechApp());
}

class InsureTechApp extends StatelessWidget {
  const InsureTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsureSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/policyForm': (context) => PolicyForm(),
        '/viewPolicies': (context) => ViewPoliciesPage(),
        '/submitClaim': (context) => SubmitClaimPage(),
      },
    );
  }
}
