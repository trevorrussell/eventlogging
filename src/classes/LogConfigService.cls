public with sharing class LogConfigService extends ConfigService {
    private static final String OBJECT_NAME = 'Log_Config__mdt';

    private static Config settings {
        get {
            return (settings != null && !Test.isRunningTest()) ? settings : new Config(OBJECT_NAME);
        }
    }

    public static Map<String, String> configMap {
        get {
            return settings.configMap;
        }
    }


//**************** Additional Custom methods to transform specific string fields to other primitives ***************//
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