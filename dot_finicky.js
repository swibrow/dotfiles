// Finicky routes URLs to the right browser/profile based on rules.
// Docs: https://github.com/johnste/finicky
export default {
  defaultBrowser: {
    name: "Google Chrome",
    profile: "Samuel (private)", // sam.wibrow@gmail.com
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
        /(^|\.)tamedia\.ch(\/|$)/,
        /(^|\.)tamedia\.tech(\/|$)/,
        /(^|\.)tx\.group(\/|$)/,
        /(^|\.)atlassian\.com(\/|$)/,
        /(^|\.)atlassian\.net(\/|$)/,
        /(^|\.)datadoghq\.com(\/|$)/,
        /(^|\.)datadoghq\.eu(\/|$)/,
        /github\.com\/dnd-it($|[/?#])/i,
        /github\.com\/tx-pts-dai($|[/?#])/i,
        /github\.com\/tx-group-adm($|[/?#])/i,
        /github\.com\/20minuten($|[/?#])/i,
      ],
      browser: {
        name: "Google Chrome",
        profile: "Samuel Wibrow (main)", // samuel.wibrow@tamedia.ch
      },
    },
  ],
};
