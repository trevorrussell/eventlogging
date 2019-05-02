public with sharing class LogConfigService extends ConfigService {
    private static LogConfigService service;

    private LogConfigService() {
        objectName = 'Log_Config__mdt';
    }

    public static Map<String, String> configMap {
        get {
            return settings.configMap;
        }
    }

    private static Config settings {
        get {
            if(service == null){
                service = new LogConfigService();
            }
            return (settings != null && !Test.isRunningTest()) ? settings : new Config();
        }
    }

    public static Boolean debugEnabled {
        get {
            return Boolean.valueOf(configMap.get('enable_debug__c'));
        }
    }
    public static Boolean loggingEnabled {
        get {
            return Boolean.valueOf(configMap.get('enable_logging__c'));
        }
    }
}