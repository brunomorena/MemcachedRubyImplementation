HOSTNAME = 'localhost'
PORT = 11211

MAX_TIME = 60*60*24*30 # number of seconds in 30 days

# messages
ERROR = "ERROR\r\n"
STORED = "STORED\r\n"
ARGUMENTS_NUMBER = "NOT_STORED_WRONG_NUMBER_OF_ARGUMENTS\r\n" 
ARGUMENTS_TYPE = "NOT_STORED_WRONG_TYPE_OF_ARGUMENTS\r\n" 
BYTES_NOT_MATCH = "NOT_STORED_BYTES_NOT_MATCH\r\n"
MAX_EXPTIME = "NOT_STORED_MAX_TIME_EXCEED\r\n"
KEY_ALREADY_STORED = "NOT_STORED_KEY_ALREADY_STORED\r\n"
NO_KEY_STORED = "NOT_STORED_NO_KEY_FOUND\r\n"
EXPIRED_KEY = "NOT_STORED_NO_KEY_FOUND\r\n"
GET_ARGUMENTS_NUMBER = "WRONG_NUMBER_OF_ARGUMENTS\r\n"
EXISTS = "EXISTS\r\n"
NO_KEY_FOUND = "NO_KEY_FOUND\r\n"
PURGED_EXP_KEYS = "PURGED_EXPIRED_KEYS\r\n"