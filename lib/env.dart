//configuration

bool useRealSystemTime = true;

DateTime get systemTime => useRealSystemTime ? DateTime.now() : DateTime.parse("2023-10-22T13:00:00");

int OVERHEAD_STARTING_TIME_MINUTE = 5; //change the value

//lower value means more realtime
Duration REALTIME_REFRESH_DURATION = Duration(seconds: 1);

bool NEW_DATABASE_EVERY_RUN = false; //will recreate new database everytime the app run




