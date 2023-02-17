package progetto.server.database.table;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "action_log")
public class ActionLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "time")
    private Date time;

    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "action")
    private String action;

    public ActionLog(Date time, Integer userId, String action) {
        this.time = time;
        this.userId = userId;
        this.action = action;
    }

    public ActionLog(Integer id, Date time, Integer userId, String action) {
        this.id = id;
        this.time = time;
        this.userId = userId;
        this.action = action;
    }

    public ActionLog() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

}
