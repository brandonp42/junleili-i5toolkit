/**
 * @file isql2.java
 *
 * a java SQL client, implements the same function as ILE RPG program ISQL2
 */

class usrq {

    public void enq_request(
                            String sql
                            ) throws Exception
    {
        // here
    }

    public int enq_reply() {
    }

}

public class isql2 {

    public static final String _usage =
        "usage info: java isql2 \"SQL statement to run.\"";

    public static void main(String[] args) {

        isql2 client = new isql2();
        client.run(args);

    }

    protected void run(String[] args) {

        if(args.length < 1) {

            System.out.println(_usage);
            return;
        }

        String msg = "";
        try {

            // enqueue reqeust USRQ: ISQL2

            // dequeue reply USRQ: ISQLR2

            // compose msg

        } catch(Exception e) {

            System.out.println(e.getMessage());
            return;
        }

        // report execuation result
        System.out.println(msg);
    }

}

/* eof - isql2.java */
