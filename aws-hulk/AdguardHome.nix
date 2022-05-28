{
  auth_attempts = 5;
  beta_bind_port = 0;
  bind_host = "0.0.0.0";
  bind_port = 3000;
  block_auth_min = 15;
  clients = [ ];
  debug_pprof = false;
  dhcp = {
    dhcpv4 = {
      gateway_ip = "";
      icmp_timeout_msec = 1000;
      lease_duration = 86400;
      options = [ ];
      range_end = "";
      range_start = "";
      subnet_mask = "";
    };
    dhcpv6 = {
      lease_duration = 86400;
      ra_allow_slaac = false;
      ra_slaac_only = false;
      range_start = "";
    };
    enabled = false;
    interface_name = "";
  };
  dns = {
    aaaa_disabled = false;
    all_servers = false;
    allowed_clients = [ ];
    anonymize_client_ip = false;
    bind_hosts = [ "0.0.0.0" ];
    blocked_hosts = [ "version.bind" "id.server" "hostname.bind" ];
    blocked_response_ttl = 10;
    blocked_services = [ ];
    blocking_ipv4 = "";
    blocking_ipv6 = "";
    blocking_mode = "default";
    bogus_nxdomain = [ ];
    bootstrap_dns = [ "127.0.0.1:5353" ];
    cache_optimistic = false;
    cache_size = 0;
    cache_time = 30;
    cache_ttl_max = 86400;
    cache_ttl_min = 0;
    disallowed_clients = [ ];
    edns_client_subnet = true;
    enable_dnssec = false;
    fastest_addr = false;
    fastest_timeout = "1s";
    filtering_enabled = true;
    filters_update_interval = 1;
    ipset = [ ];
    local_domain_name = "lan";
    local_ptr_upstreams = [ "127.0.0.1:5353" ];
    max_goroutines = 300;
    parental_block_host = "family-block.dns.adguard.com";
    parental_cache_size = 1048576;
    parental_enabled = false;
    port = 53;
    protection_enabled = true;
    querylog_enabled = true;
    querylog_file_enabled = true;
    querylog_interval = "720h";
    querylog_size_memory = 1000;
    ratelimit = 0;
    ratelimit_whitelist = [ ];
    refuse_any = true;
    resolve_clients = true;
    rewrites = [ ];
    safebrowsing_block_host = "standard-block.dns.adguard.com";
    safebrowsing_cache_size = 1048576;
    safebrowsing_enabled = false;
    safesearch_cache_size = 1048576;
    safesearch_enabled = false;
    statistics_interval = 30;
    trusted_proxies = [ "127.0.0.0/8" "::1/128" ];
    upstream_dns = [ "127.0.0.1:5353" ];
    upstream_dns_file = "";
    upstream_timeout = "10s";
    use_private_ptr_resolvers = true;
  };
  filters = [
    {
      enabled = true;
      id = 1652343775;
      name = "AdGuard DNS filter";
      url =
        "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
    }
    {
      enabled = true;
      id = 1652343776;
      name = "Perflyst and Dandelion Sprout's Smart-TV Blocklist";
      url =
        "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV-AGH.txt";
    }
    {
      enabled = true;
      id = 1652343777;
      name = "Online Malicious URL Blocklist";
      url =
        "https://curben.gitlab.io/malware-filter/urlhaus-filter-agh-online.txt";
    }
    {
      enabled = true;
      id = 1652343779;
      name = "Peter Lowe";
      url =
        "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&mimetype=plaintext&useip=0.0.0.0";
    }
    {
      enabled = true;
      id = 1652343780;
      name = "OISD Blocklist Basic";
      url = "https://abp.oisd.nl/basic/";
    }
    {
      enabled = true;
      id = 1652343781;
      name = "1Hosts (mini)";
      url = "https://o0.pages.dev/mini/adblock.txt";
    }
    {
      enabled = true;
      id = 1652343783;
      name = "AdGuard Filter unblocking search ads and self-promotion";
      url = "https://filters.adtidy.org/extension/chromium/filters/10.txt";
    }
    {
      enabled = true;
      id = 1652343784;
      name = "Personal Whitelist";
      url =
        "https://raw.githubusercontent.com/colinxs/public/master/adfilter/whitelist/build/adguard.txt";
    }
  ];
  http_proxy = "";
  language = "";
  log_compress = false;
  log_file = "";
  log_localtime = false;
  log_max_age = 3;
  log_max_backups = 0;
  log_max_size = 100;
  os = {
    group = "";
    rlimit_nofile = 0;
    user = "";
  };
  schema_version = 12;
  tls = {
    allow_unencrypted_doh = false;
    certificate_chain = "";
    certificate_path = "";
    dnscrypt_config_file = "";
    enabled = false;
    force_https = false;
    port_dns_over_quic = 784;
    port_dns_over_tls = 853;
    port_dnscrypt = 0;
    port_https = 443;
    private_key = "";
    private_key_path = "";
    server_name = "";
    strict_sni_check = false;
  };
  user_rules = [ "" ];
  users = [{
    name = "root";
    password = "2y$05$S/UIqSmkJvjdxs9hSwdxDOAnNG.Y/VuTaPnGKoAru1WRiRKD5B1xS";
  }];
  verbose = false;
  web_session_ttl = 720;
  whitelist_filters = [ ];
}
