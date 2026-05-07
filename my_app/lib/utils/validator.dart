class AppValidator {
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return "Nama harus diisi";
    }
    if (value.length < 3) {
      return "Nama minimal 3 karakter";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "Email harus diisi";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
      return "Email tidak valid";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password harus diisi";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}$').hasMatch(value)) {
      return "Harus ada huruf besar, kecil, dan angka";
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return "Konfirmasi password harus diisi";
    }
    if (value != password) {
      return "Password tidak sama";
    }
    return null;
  }
}