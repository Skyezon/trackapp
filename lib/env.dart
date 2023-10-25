//configuration

//if this is set to false, adjust the parse datetime below accordingly
bool useRealSystemTime = true;

DateTime get systemTime => useRealSystemTime ? DateTime.now() : DateTime.parse("2023-10-22T13:00:00");

int OVERHEAD_STARTING_TIME_MINUTE = 5; //change the value

//lower value means more faster refresh
Duration REALTIME_REFRESH_DURATION = Duration(seconds: 1);

//if true will recreate new database everytime the app run
//if false, database will persist
bool NEW_DATABASE_EVERY_RUN = false;