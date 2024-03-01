package progetto.applicazione.manager.beans;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateFormatted extends Date {

    private static DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

    public DateFormatted(Date d) {
        this.setTime(d.getTime());
    }

    @Override
    public String toString() {
        String strDate = dateFormat.format(this);
        return strDate;
    }
}