// Prism: built-in branding and locked-down defaults for this fork.
use hbb_common::config;

pub const APP_NAME: &str = "Prism";

const BUILTIN: &[(&str, &str)] = &[
    ("hide-network-settings", "Y"),
    ("hide-server-settings", "Y"),
    ("hide-proxy-settings", "Y"),
    ("hide-websocket-settings", "Y"),
    ("hide-stop-service", "Y"),
    ("hide-help-cards", "Y"),
    ("hide-powered-by-me", "Y"),
    ("disable-change-id", "Y"),
];

const OVERWRITE: &[(&str, &str)] = &[("enable-lan-discovery", "N")];

const DEFAULT: &[(&str, &str)] = &[
    ("verification-method", "use-both-passwords"),
    ("approve-mode", "password-click"),
];

const HARD: &[(&str, &str)] = &[("disable-ab", "Y"), ("disable-account", "Y")];

const OVERWRITE_LOCAL: &[(&str, &str)] = &[
    ("disable-discovery-panel", "Y"),
    ("disable-group-panel", "Y"),
];

const DEFAULT_LOCAL: &[(&str, &str)] = &[("lang", "ru"), ("theme", "dark")];

const DEFAULT_DISPLAY: &[(&str, &str)] = &[("show_quality_monitor", "Y")];

fn insert(map: &std::sync::RwLock<std::collections::HashMap<String, String>>, kv: &[(&str, &str)]) {
    let mut m = map.write().unwrap();
    for (k, v) in kv {
        m.insert((*k).to_owned(), (*v).to_owned());
    }
}

pub fn apply_defaults() {
    *config::APP_NAME.write().unwrap() = APP_NAME.to_owned();
    insert(&config::BUILTIN_SETTINGS, BUILTIN);
    insert(&config::OVERWRITE_SETTINGS, OVERWRITE);
    insert(&config::DEFAULT_SETTINGS, DEFAULT);
    insert(&config::OVERWRITE_LOCAL_SETTINGS, OVERWRITE_LOCAL);
    insert(&config::DEFAULT_LOCAL_SETTINGS, DEFAULT_LOCAL);
    insert(&config::HARD_SETTINGS, HARD);
    insert(&config::DEFAULT_DISPLAY_SETTINGS, DEFAULT_DISPLAY);
}
