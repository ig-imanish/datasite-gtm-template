___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "BetterUmami Analytics",
  "description": "Load BetterUmami Analytics and optional session recording.",
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
    "name": "enableSessionRecording",
    "displayName": "Enable Session Recording",
    "simpleValueType": true,
    "defaultValue": false
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const encodeUriComponent = require('encodeUriComponent');
const isConsentGranted = require('isConsentGranted');
const setInWindow = require('setInWindow');

const websiteId = data.websiteId;
if (!websiteId) {
  data.gtmOnFailure();
  return;
}

if (!isConsentGranted('analytics_storage')) {
  data.gtmOnSuccess();
  return;
}

const config = {
  websiteId: websiteId
};
if (data.performance) config.performance = true;
if (data.doNotTrack) config.doNotTrack = true;
if (data.excludeSearch) config.excludeSearch = true;
if (data.excludeHash) config.excludeHash = true;
setInWindow('umamiConfig', config, true);

let scriptUrl = 'https://app.betterumami.com/script.js?website-id=' +
  encodeUriComponent(websiteId);

if (data.performance) scriptUrl += '&performance=true';
if (data.doNotTrack) scriptUrl += '&do-not-track=true';
if (data.excludeSearch) scriptUrl += '&exclude-search=true';
if (data.excludeHash) scriptUrl += '&exclude-hash=true';
injectScript(scriptUrl, function () {
  if (!data.enableSessionRecording) {
    data.gtmOnSuccess();
    return;
  }

  const recorderUrl = 'https://app.betterumami.com/recorder.js?website-id=' +
    encodeUriComponent(websiteId);
  injectScript(recorderUrl, data.gtmOnSuccess, data.gtmOnFailure);
}, data.gtmOnFailure);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://app.betterumami.com/script.js*"
              },
              {
                "type": 1,
                "string": "https://app.betterumami.com/recorder.js*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "umamiConfig"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Loads BetterUmami tracker with required Website ID
  code: |-
    const mockData = {
      websiteId: 'test-site-id',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    };
    mock('isConsentGranted', function() { return true; });
    mock('setInWindow', function() {});
    mock('injectScript', function(url, success) {
      assertThat(url).contains('https://app.betterumami.com/script.js');
      assertThat(url).contains('website-id=test-site-id');
      success();
    });
    mock('encodeUriComponent', function(value) { return value; });
    runCode(mockData);
- name: Loads recorder after tracker when enabled
  code: |-
    const mockData = {
      websiteId: 'test-site-id',
      enableSessionRecording: true,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    };
    mock('isConsentGranted', function() { return true; });
    mock('setInWindow', function() {});
    const urls = [];
    mock('injectScript', function(url, success) {
      urls.push(url);
      success();
    });
    mock('encodeUriComponent', function(value) { return value; });
    runCode(mockData);
    assertThat(urls.length).equals(2);
    assertThat(urls[1]).contains('https://app.betterumami.com/recorder.js');
    assertThat(urls[1]).contains('website-id=test-site-id');
- name: Maps all privacy and performance options
  code: |-
    const mockData = {
      websiteId: 'test-site-id',
      performance: true,
      doNotTrack: true,
      excludeSearch: true,
      excludeHash: true,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    };
    mock('isConsentGranted', function() { return true; });
    mock('setInWindow', function() {});
    mock('injectScript', function(url, success) {
      assertThat(url).contains('performance=true');
      assertThat(url).contains('do-not-track=true');
      assertThat(url).contains('exclude-search=true');
      assertThat(url).contains('exclude-hash=true');
      success();
    });
    mock('encodeUriComponent', function(value) { return value; });
    runCode(mockData);
- name: Waits for analytics storage consent
  code: |-
    const mockData = {
      websiteId: 'test-site-id',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    };
    mock('isConsentGranted', function(type) {
      return type !== 'analytics_storage';
    });
    mock('injectScript', function() {
      fail('Tracker script was injected without analytics consent');
    });
    mock('encodeUriComponent', function(value) { return value; });
    runCode(mockData);
