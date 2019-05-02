public with sharing abstract class ConfigService {
    public static String objectName { get; set; }

    public ConfigService(){

    }

    public class Config {
        private String environmentName = getCurrentEnvironmentName();
        private Map<String, Schema.SObjectField> objectFields= Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        private List<String> listOfFields = new List<String>(objectFields.keySet());
        public Map<String, String> configMap = new Map<String, String>();
        public Config() {
            String fieldsToQuery = String.valueOf(listOfFields);
            fieldsToQuery = fieldsToQuery.remove('(').remove(')');
            String configQueryString = 'SELECT '+fieldsToQuery+' FROM '+objectName+' WHERE DeveloperName = :environmentName';
            SObject customMetaDataRecord = System.Database.query(configQueryString);
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
            return 'Production';
        } else {
            hostName = hostName.substringAfter('--'); //remove everything before the --
            hostName = hostName.substringBefore('.');
        }
        return hostName;
    }
}
