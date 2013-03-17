$:.insert(0, "#{File.dirname(__FILE__)}/../lib")

EXAMPLE_DATABASE = "#{File.dirname(__FILE__)}/sample.db"
EXAMPLE_TABLE = :garbage_collection_routes
EXAMPLE_COL = :PK_UID
EXAMPLE_COL_VALUE_EXISTS = 1
EXAMPLE_COL_VALUE_NOT_EXISTS = -314159
