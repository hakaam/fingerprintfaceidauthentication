import 'package:fingerprintfaceidauthentication/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum SupportState {
  unknown,
  supported,
  unSupported,
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  List<BiometricType>? availableBiometrics;

  @override
  void initState() {
    // TODO: implement initState
    auth.isDeviceSupported().then((bool isSupoorted) => setState(() =>
        supportState = isSupoorted ? supportState : SupportState.unSupported));
    checkBiotMetric();
    getAvailableBioMetrics();

    super.initState();
  }

  Future<void> checkBiotMetric() async {
    late bool canCheckBiotMetric;
    try {
      canCheckBiotMetric = await auth.canCheckBiometrics;
      print('Biometric supported: $canCheckBiotMetric');
    } on PlatformException catch (e) {
      print(e);
      canCheckBiotMetric = false;
    }
  }

  Future<void> getAvailableBioMetrics() async {
    late List<BiometricType> bioMetricTypes;
    try {
      bioMetricTypes = await auth.getAvailableBiometrics();
      print(' supported Biometric : $bioMetricTypes');
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      availableBiometrics = bioMetricTypes;
    });
  }

  Future<void> authenticatewithBioMetrics() async {
    try {
      final authenticated = await auth.authenticate(
          localizedReason: 'Authenticate with fingerprint or ID',
          options:
              AuthenticationOptions(stickyAuth: true, biometricOnly: true));
      if (!mounted) {
        return;
      }
      if (authenticated) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HOmePage()));
      }
    } on PlatformException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bio Metric Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(supportState == SupportState.supported
                ? 'Biometric Authenticate is supported on this device'
                : supportState == SupportState.unSupported
                    ? 'Biometric Authenticate is not supported on this device'
                    : 'Cheking biometric support....',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: supportState == SupportState.supported
                    ? Colors.green
                    : supportState == SupportState.unSupported
                    ? Colors.red
                    :Colors.grey

              ),

            ),
            SizedBox(
              height: 20,

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/face_id.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                ElevatedButton(onPressed: authenticatewithBioMetrics,
                    child: Text('Authenticate with Face ID'))


              ],


            )


          ],
        ),
      ),
    );
  }
}
