@IsTest(SeeAllData=false)
private with sharing class LogTest {

    @IsTest
    private static void logTest() {
        Log.push('MyClass.methodA');
        insert new Account(Name = 'Test');
        Log.push('MyClass.methodB');
        Log.message('Doing something');
        insert new Account(Name = 'Test');
        Log.pop();
        List<Account> accounts = [select Id from Account];
        Log.message('Doing something more');
        Log.pop();
        Log.emit();
    }

    @IsTest
    private static void test_debug() {
        Log.debug('test message');
        Log.debug('test Decimal', 12345.0945);
        Log.debug('test String', 'My String');
        Log.debug('test Integer', 123);
        Log.debug('testObject', new Account());
        Log.debug('testList', new List<Account>{new Account()});
        try {
            Decimal divByZero = 5 / 0;
        } catch (Exception e) {
            Log.debug('test Exception', e);
        }
    }
}