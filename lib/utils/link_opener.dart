import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_snackbar.dart';

/// Ouvre un lien externe : site web (https), e-mail (mailto) ou
/// téléphone (tel). Si aucune application ne peut l'ouvrir, on prévient
/// l'utilisateur au lieu d'échouer en silence.
Future<void> openLink(BuildContext context, Uri uri) async {
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    opened = false;
  }
  if (!opened && context.mounted) {
    showAppSnackBar(context, "Impossible d'ouvrir ce lien.", isError: true);
  }
}
