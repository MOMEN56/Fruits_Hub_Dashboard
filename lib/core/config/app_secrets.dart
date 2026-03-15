class AppSecrets {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  static void validateSupabaseConfig() {
    if (supabaseUrl.trim().isEmpty || supabaseAnonKey.trim().isEmpty) {
      throw StateError(
        'Missing Supabase configuration. Run with --dart-define=SUPABASE_URL=... '
        'and --dart-define=SUPABASE_ANON_KEY=...',
      );
    }
  }
}
