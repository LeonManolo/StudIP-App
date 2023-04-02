import 'package:oauth2_client/oauth2_client.dart';

class StudIpOAuth2Client extends OAuth2Client {
  static String baseURL = "miezhaus.feste-ip.net:55109";

  StudIpOAuth2Client({required redirectUri, required customUriScheme}
      ) : super(
    authorizeUrl: 'http://$baseURL/dispatch.php/api/oauth2/authorize',
    tokenUrl: 'http://$baseURL/dispatch.php/api/oauth2/token',
    redirectUri: redirectUri,
    customUriScheme: customUriScheme,
  );

}