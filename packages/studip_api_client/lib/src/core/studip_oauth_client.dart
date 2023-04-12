import 'package:oauth2_client/oauth2_client.dart';

class StudIpOAuth2Client extends OAuth2Client {
  StudIpOAuth2Client({required String baseUrl})
      : super(
          authorizeUrl: '$baseUrl/dispatch.php/api/oauth2/authorize',
          tokenUrl: '$baseUrl/dispatch.php/api/oauth2/token',
          redirectUri: 'de.hsflensburg.studipadawan://redirect',
          customUriScheme: 'de.hsflensburg.studipadawan',
        );
}
