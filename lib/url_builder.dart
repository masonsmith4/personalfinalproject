class UrlBuilder {
  Uri buildUrl(String username, String tag) {
    return Uri.parse('https://americas.api.riotgames.com'
        '/riot/account/v1/accounts/by-riot-id/${Uri.encodeComponent(username)}'
        '/${Uri.encodeComponent(tag)}');
  }
}