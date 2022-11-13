/**
 * @file isql.java
 *
 * a java SQL client, implements the same function as ILE RPG program ISQL
 *
 * javac -encoding ibm-935 *.java
 * javah isqlsvr
 */

public class isql {

    static {

        System.loadLibrary("ISQLSVR");
    }

    public static final String _usage =
        "usage info: java isql \"SQL statement to run.\"";

    public static void main(String[] args) {

        isql client = new isql();
        client.run(args);

    }

    protected void run(String[] args) {

        if(args.length < 1) {

            System.out.println(_usage);
            return;
        }

        String msg = "";
        try {

            // send request to ISQLSVR
            int sqlcod = isqlsvr.sendRequest(args[0]);

            // compose msg
            if(sqlcod < 0)
                msg = "SQL statement failed with SQLCOD " + sqlcod;
            else
                msg = "SQL statement succeeded with SQLCOD " + sqlcod;

        } catch(Exception e) {

            System.out.println(e.getMessage());
            return;
        }

        // report execuation result
        System.out.println(msg);
    }

}

/* eof - isql.java */
