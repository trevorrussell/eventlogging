public with sharing abstract class ConfigService {
    private static final String ENVIRONMENT_NAME_KEY_FIELD =  'DeveloperName';
    private static final String PRODUCTION_ENVIRONMENT_NAME = 'Production';
    private static final String DEFAULT_ENVIRONMENT_NAME = 'Default';
    private static final String EXCEPTION_METADATA_RECORD_NOT_FOUND = 'No Custom Metadata Record found. Please add a Default or environment specific entry';

    public class Config {
        private String environmentName = getCurrentEnvironmentName();
        public Map<String, String> configMap = new Map<String, String>();
        public Config(String objectName) {
            Map<String, Schema.SObjectField> objectFields =
                    Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            List<String> listOfFields = new List<String>(objectFields.keySet());
            String fieldsToQuery = String.valueOf(listOfFields);
            fieldsToQuery = fieldsToQuery.remove('(').remove(')');
            String configQueryString = 'SELECT '+fieldsToQuery+
                    ' FROM '+objectName+
                    ' WHERE ('+ENVIRONMENT_NAME_KEY_FIELD+' = :environmentName OR '+
                    ENVIRONMENT_NAME_KEY_FIELD+' = \''+DEFAULT_ENVIRONMENT_NAME+'\')';
            List<SObject> customMetaDataRecords = System.Database.query(configQueryString);
            SObject customMetaDataRecord;
            if(customMetaDataRecords.size()==1){
                customMetaDataRecord = customMetaDataRecords[0];
            }else {
                for (SObject metaDataObject : customMetaDataRecords) {
                    if (metaDataObject.get(ENVIRONMENT_NAME_KEY_FIELD) == environmentName) {
                        customMetaDataRecord = metaDataObject;
                    }
                }
            }
            if(customMetaDataRecord == null){
                throw new configException(EXCEPTION_METADATA_RECORD_NOT_FOUND);
            }
            for(String fieldName : listOfFields){
                configMap.put(fieldName,String.valueOf((Object)customMetaDataRecord.get(fieldName)));
            }
            this.configMap = configMap;
        }
    }

    private static String getCurrentEnvironmentName() {
        String hostName = Url.getSalesforceBaseUrl().getHost();
        Boolean isSandbox = (Pattern.matches('(.*\\.)?cs[0-9]*(-api)?\\..*force.com', hostName));
        if (!isSandbox) {
            return PRODUCTION_ENVIRONMENT_NAME;
        } else {
            hostName = hostName.substringAfter('--'); //remove everything before the --
            hostName = hostName.substringBefore('.');
        }
        return hostName;
    }

    public class configException extends Exception{}
}
