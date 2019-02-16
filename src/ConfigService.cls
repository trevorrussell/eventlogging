public with sharing class ConfigService {

    private static Config settings {
        get {
            return (settings != null && !Test.isRunningTest()) ? settings : new Config();
        }
    }

    public static Boolean debugEnabled {
        get {
            return settings.debugEnabled;
        }
    }

    private class Config {
        //Default Config Settings
        private Log_Config__mdt defaultLogConfig = Test.isRunningTest() ? null : [
                SELECT Enable_Debug__c
                FROM Log_Config__mdt
                WHERE DeveloperName = 'Default'
        ];
        private Boolean debugEnabled;
        private Config() {
            this.debugEnabled = Test.isRunningTest() ? true : defaultLogConfig.Enable_Debug__c;
        }
    }
}