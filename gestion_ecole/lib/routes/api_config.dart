class ApiConfig {
  static const String baseUrl = "http://192.168.1.64/gestion_ecole_api";

  static const String syncAnnees = "$baseUrl/sync_annees.php";
  static const String syncOptions = "$baseUrl/sync_options.php";
  static const String syncClasses = "$baseUrl/sync_classes.php";
  static const String syncInscriptions = "$baseUrl/sync_inscriptions.php";
  static const String syncPaiements = "$baseUrl/sync_paiements.php";
  static const String syncUtilisateurs = "$baseUrl/sync_utilisateurs.php";
  static const String syncTypesFrais = "$baseUrl/sync_types_frais.php";
  static const String syncTarifsFrais = "$baseUrl/sync_tarifs_frais.php";
  static const String syncFactures = "$baseUrl/sync_factures.php";
}
