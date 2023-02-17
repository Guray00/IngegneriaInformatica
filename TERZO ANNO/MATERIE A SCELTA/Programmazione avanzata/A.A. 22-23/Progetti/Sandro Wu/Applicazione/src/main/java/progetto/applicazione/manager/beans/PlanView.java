package progetto.applicazione.manager.beans;

public class PlanView {
    private Integer id;
    private String name;
    private Double cost;

    public PlanView(Integer id, String name, Double cost) {
        this.id = id;
        this.name = name;
        this.cost = cost;
    }

    public PlanView() {
    }

    @Override
    public String toString() {
        // return String.format("(ID: %s) %s - price: %s", id, name, cost);
        return String.format("[%s] %s", id, name);
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getCost() {
        return cost;
    }

    public void setCost(Double cost) {
        this.cost = cost;
    }
}
