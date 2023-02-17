package progetto.applicazione.manager.beans;

import java.util.Date;

public class CostlogView {

    private Integer id;
    private Integer resource_id;
    private String resource_name;
    private Date start_date;
    private Date end_date;
    private Double cost;

    public CostlogView(Integer id, Integer resource_id, String resource_name, Date start_date, Date end_date,
            Double cost) {
        this.id = id;
        this.resource_id = resource_id;
        this.resource_name = resource_name;
        this.start_date = start_date;
        this.end_date = end_date;
        this.cost = cost;
    }

    public CostlogView() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getResource_id() {
        return resource_id;
    }

    public void setResource_id(Integer resource_id) {
        this.resource_id = resource_id;
    }

    public String getResource_name() {
        return resource_name;
    }

    public void setResource_name(String resource_name) {
        this.resource_name = resource_name;
    }

    public Date getStart_date() {
        return new DateFormatted(start_date);
    }

    public void setStart_date(Date start_date) {
        this.start_date = start_date;
    }

    public Date getEnd_date() {
        return new DateFormatted(end_date);
    }

    public void setEnd_date(Date end_date) {
        this.end_date = end_date;
    }

    public Double getCost() {
        return cost;
    }

    public void setCost(Double cost) {
        this.cost = cost;
    }

}