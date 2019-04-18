public with sharing class LogConfigService {

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
    public static Boolean loggingEnabled {
        get {
            return settings.loggingEnabled;
        }
    }


    private class Config {
        //Default Config Settings
        private Log_Config__mdt defaultLogConfig = Test.isRunningTest() ? null : [
                SELECT Enable_Debug__c, Enable_Logging__c
                FROM Log_Config__mdt
                WHERE DeveloperName = 'Default'
        ];
        private Boolean debugEnabled;
        private Boolean loggingEnabled;
        private Config() {
            this.debugEnabled = Test.isRunningTest() ? true : defaultLogConfig.Enable_Debug__c;
            this.loggingEnabled = Test.isRunningTest() ? true : defaultLogConfig.Enable_Logging__c;
        }
    }
}