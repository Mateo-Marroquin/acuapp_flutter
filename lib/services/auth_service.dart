import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String menssageLogin = '';
  User? get currentUser => _auth.currentUser;
  String? get userName => currentUser?.displayName;
  String? get userEmail => currentUser?.email;
  String? get userPhotoUrl => currentUser?.photoURL;

  Future<User?> signInWithGoogle() async {
    try {
      FirebaseAuth.instance.setLanguageCode('es');

      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;

    } on FirebaseAuthException catch (e) {

      switch (e.code) {
        case 'account-exists-with-different-credential':
          menssageLogin = 'La cuenta ya existe con un proveedor diferente.';
          break;
        case 'invalid-credential':
          menssageLogin = 'Las credenciales no son válidas.';
          break;
        case 'user-disabled':
          menssageLogin = 'El usuario ha sido deshabilitado.';
          break;
        case 'user-not-found':
          menssageLogin = 'Usuario no encontrado.';
          break;
        case 'wrong-password':
          menssageLogin = 'Contraseña incorrecta.';
          break;
        case 'invalid-verification-code':
          menssageLogin = 'Código de verificación inválido.';
          break;
        case 'invalid-verification-id':
          menssageLogin = 'ID de verificación inválido.';
          break;
        default:
          print('Error de FirebaseAuth: ${e.message}');
      }
      return null;

    } catch (error) {
      print("Error en el inicio de sesión: $error");

      if(error.toString().contains('network_error')){
        menssageLogin = "Verifica tu conexión a internet";
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    try {
      await FirebaseAuth.instance.signOut();
      print("Sesión cerrada exitosamente.");
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
    await _auth.signOut();
  }
}