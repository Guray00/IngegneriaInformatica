package progetto.server.beans;

import java.util.Date;

public class CostlogView {
    private Integer id;
    private Integer resource_id;
    private Date start_date;
    private Date end_date;
    private Double cost;
    private String resource_name;

    public CostlogView() {
    }

    public CostlogView(Integer id, Integer resource_id, Date start_date, Date end_date, Double cost,
            String resource_name) {
        this.id = id;
        this.resource_id = resource_id;
        this.start_date = start_date;
        this.end_date = end_date;
        this.cost = cost;
        this.resource_name = resource_name;
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
        return start_date;
    }

    public void setStart_date(Date start_date) {
        this.start_date = start_date;
    }

    public Date getEnd_date() {
        return end_date;
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
