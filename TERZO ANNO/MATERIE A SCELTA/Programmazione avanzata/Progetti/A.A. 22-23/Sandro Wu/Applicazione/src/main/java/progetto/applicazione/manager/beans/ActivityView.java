package progetto.applicazione.manager.beans;

import java.util.Date;

public class ActivityView {

    private Integer id;
    private String user;
    private Date time;
    private String action;

    public ActivityView(Integer id, String user, Date time, String action) {
        this.id = id;
        this.user = user;
        this.time = time;
        this.action = action;
    }

    public ActivityView() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public Date getTime() {
        return new DateFormatted(time);
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

}