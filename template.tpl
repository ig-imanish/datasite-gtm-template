___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Datasite Analytics",
  "description": "Load Datasite Analytics and optional session recording.",
  "categories": ["ANALYTICS"],
  "containerContexts": ["WEB"]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "websiteId",
    "displayName": "Website ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "performance",
    "displayName": "Performance",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "doNotTrack",
    "displayName": "Do Not Track",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "excludeSearch",
    "displayName": "Exclude Search",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "excludeHash",
    "displayName": "Exclude Hash",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "noVisitorId",
    "displayName": "No Visitor ID",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "enableSessionRecording",
    "displayName": "Enable Session Recording",
    "simpleValueType": true,
    "defaultValue": false
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const encodeUriComponent = require('encodeUriComponent');
const requireConsent = require('requireConsent');

requireConsent('analytics_storage');

const websiteId = data.websiteId;
let scriptUrl = 'https://datasite.sh/script.js?website-id=' +
  encodeUriComponent(websiteId);

if (data.performance) scriptUrl += '&performance=true';
if (data.doNotTrack) scriptUrl += '&do-not-track=true';
if (data.excludeSearch) scriptUrl += '&exclude-search=true';
if (data.excludeHash) scriptUrl += '&exclude-hash=true';
if (data.noVisitorId) scriptUrl += '&no-visitor-id=true';

injectScript(scriptUrl, function () {
  if (!data.enableSessionRecording) {
    data.gtmOnSuccess();
    return;
  }

  const recorderUrl = 'https://datasite.sh/recorder.js?website-id=' +
    encodeUriComponent(websiteId);
  injectScript(recorderUrl, data.gtmOnSuccess, data.gtmOnFailure);
}, data.gtmOnFailure);


___WEB_PERMISSIONS___

[
  {
    "type": "require_consent",
    "consentType": "analytics_storage"
  },
  {
    "type": "inject_script",
    "allowedUrls": [
      "https://datasite.sh/script.js",
      "https://datasite.sh/recorder.js",
      "https://app.datasite.sh/script.js",
      "https://app.datasite.sh/recorder.js"
    ]
  }
]


___TESTS___

[
  {
    "name": "Loads the Datasite tracker with required Website ID",
    "runCode": "const mockData = { websiteId: 'test-site-id', gtmOnSuccess: () => {}, gtmOnFailure: () => {} }; let loadedUrl = ''; mock('injectScript', (url, success) => { loadedUrl = url; success(); }); mock('encodeUriComponent', value => value); mock('requireConsent', () => {}); runCode(mockData); assertThat(loadedUrl).contains('https://datasite.sh/script.js'); assertThat(loadedUrl).contains('website-id=test-site-id');"
  },
  {
    "name": "Loads recorder after tracker when enabled",
    "runCode": "const mockData = { websiteId: 'test-site-id', enableSessionRecording: true, gtmOnSuccess: () => {}, gtmOnFailure: () => {} }; let urls = []; mock('injectScript', (url, success) => { urls.push(url); success(); }); mock('encodeUriComponent', value => value); mock('requireConsent', () => {}); runCode(mockData); assertThat(urls[1]).contains('https://datasite.sh/recorder.js');"
  },
  {
    "name": "Maps all privacy and performance options",
    "runCode": "const mockData = { websiteId: 'test-site-id', performance: true, doNotTrack: true, excludeSearch: true, excludeHash: true, noVisitorId: true, gtmOnSuccess: () => {}, gtmOnFailure: () => {} }; let loadedUrl = ''; mock('injectScript', (url, success) => { loadedUrl = url; success(); }); mock('encodeUriComponent', value => value); mock('requireConsent', () => {}); runCode(mockData); assertThat(loadedUrl).contains('performance=true'); assertThat(loadedUrl).contains('do-not-track=true'); assertThat(loadedUrl).contains('exclude-search=true'); assertThat(loadedUrl).contains('exclude-hash=true'); assertThat(loadedUrl).contains('no-visitor-id=true');"
  }
]
