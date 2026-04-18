// Finicky routes URLs to the right browser/profile based on rules.
// Docs: https://github.com/johnste/finicky
module.exports = {
  defaultBrowser: {
    name: "Google Chrome",
    profile: "Profile 6", // Personal (sam.wibrow@gmail.com)
  },
  handlers: [
    {
      // AWS console / SSO → Zen
      match: [
        /signin\.aws\.amazon\.com/,
        /console\.aws\.amazon\.com/,
        /.*\.console\.aws\.amazon\.com/,
        /.*\.awsapps\.com\/start/,
        /.*\.sso\..*\.amazonaws\.com/,
      ],
      browser: "Zen",
    },
    {
      // Work URLs → Chrome Profile 1 (samuel.wibrow@tamedia.ch)
      match: [
        "*.tamedia.ch/*",
        "*.tx.group/*",
        "*.dnd.tx.group/*",
        "github.com/dnd-it/*",
        "github.com/tx-pts-dai/*",
        "github.com/tx-group-adm/*",
        "github.com/20minuten/*",
      ],
      browser: {
        name: "Google Chrome",
        profile: "Profile 1",
      },
    },
  ],
};
