import ballerina.data.sql;

struct ResultMap {
    map INT_ARRAY;
    map LONG_ARRAY;
    map FLOAT_ARRAY;
    map BOOLEAN_ARRAY;
    map STRING_ARRAY;
}

function main (string[] args) {
    endpoint<sql:ClientConnector> testDB {
        create sql:ClientConnector(sql:HSQLDB_FILE, "./target/tempdb/",
                                   0, "TEST_DATA_TABLE_DB", "SA", "", {maximumPoolSize:1});
    }
    int ret = testDB.update("CREATE TABLE ArrayTypesTest(row_id INTEGER,int_array INTEGER ARRAY,
                                long_array BIGINT ARRAY, float_array FLOAT ARRAY, double_array DOUBLE ARRAY,
                                boolean_array BOOLEAN ARRAY, string_array  VARCHAR(50) ARRAY)", null);
    println("Table creation status:" + ret);
    int[] dataint = [1, 2, 3];
    float[] datafloat = [33.4, 55.4];
    string[] datastring = ["hello", "world"];
    boolean[] databoolean = [true, false, false, true, true];

    sql:Parameter paraID = {sqlType:"integer", value:4, direction:0};
    sql:Parameter paraInt = {sqlType:"array", value:dataint};
    sql:Parameter paraLong = {sqlType:"array", value:dataint};
    sql:Parameter paraFloat = {sqlType:"array", value:datafloat};
    sql:Parameter paraString = {sqlType:"array", value:datastring};
    sql:Parameter paraBool = {sqlType:"array", value:databoolean};
    sql:Parameter[] parameters = [paraID, paraInt, paraLong, paraFloat, paraString, paraBool];

    ret = testDB.update("insert into ArrayTypesTest(row_id, int_array, long_array, float_array, string_array, 
							boolean_array) values (?,?,?,?,?,?)", parameters);
    println("Data insert status:" + ret);
    datatable dt = testDB.select("SELECT int_array, long_array, float_array, boolean_array, string_array from 
									ArrayTypesTest where row_id = 4", null);
    ResultMap rs;
    while (dt.hasNext()) {
        any dataStruct = dt.getNext();
        rs, _ = (ResultMap)dataStruct;
        map int_arr = rs.INT_ARRAY;
        println(int_arr);
        map long_arr = rs.LONG_ARRAY;
        println(long_arr);
        map float_arr = rs.FLOAT_ARRAY;
        println(float_arr);
        map boolean_arr = rs.BOOLEAN_ARRAY;
        println(boolean_arr);
        map string_arr = rs.STRING_ARRAY;
        println(string_arr);
        println("Lengths:" + int_arr.length() + "|" + long_arr.length() + "|" + float_arr.length() + "|"
                + boolean_arr.length() + "|" + string_arr.length());
    }
    testDB.close();
}
