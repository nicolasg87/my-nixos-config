{ pkgs, ... }:
let
  vivaldiPolicies = {
    # --- Não virar navegador padrão ---
    DefaultBrowserSettingEnabled = false;

    # --- Privacidade ---
    BlockThirdPartyCookies = true;                  # bool no Vivaldi (profile.cookie_controls_mode)
    MetricsReportingEnabled = false;
    UrlKeyedAnonymizedDataCollectionEnabled = false;
    SafeBrowsingExtendedReportingEnabled = false;
    PasswordManagerEnabled = false;
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    PromotionsEnabled = false;
    BackgroundModeEnabled = false;
    EnableMediaRouter = false;
    DefaultNotificationsSetting = 3;                # 1=allow, 2=block, 3=ask
    DefaultGeolocationSetting = 3;

    # --- Busca (só o que o Vivaldi realmente honra) ---
    SearchSuggestEnabled = false;

    # --- Limpeza ---
    BrowsingDataLifetime = [
      {
        data_types = [ "browsing_history" "download_history" ];
        time_to_live_in_hours = 24;
      }
    ];
    ClearBrowsingDataOnExitList = [
      "browsing_history"
      "download_history"
      "cached_images_and_files"
      # "cookies_and_other_site_data"  # <- descomente para deslogar de tudo ao fechar
      # "site_settings"                # <- descomente para resetar permissões ao fechar
    ];

    # --- DNS ---
    DnsOverHttpsMode = "secure";
    DnsOverHttpsTemplates = "https://mozilla.cloudflare-dns.com/dns-query";
  };
in
{
  flake.modules.homeManager."apps/browsers/vivaldi" = { ... }: {
    programs.vivaldi = {
      enable = true;
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--password-store=gnome-libsecret"
      ];
      # uBlock Origin Lite (MV3)
      extensions = [ "ddkjiahejlhfcafbddmgiahcphecmpfh" ];
      # dictionaries = [ pkgs.hunspellDictsChromium.pt_BR ];
    };
  };

  flake.modules.nixos."apps/browsers/vivaldi" = { ... }: {
    programs.chromium = {
      enable = true;
      extraOpts = vivaldiPolicies;
    };
  };
}
