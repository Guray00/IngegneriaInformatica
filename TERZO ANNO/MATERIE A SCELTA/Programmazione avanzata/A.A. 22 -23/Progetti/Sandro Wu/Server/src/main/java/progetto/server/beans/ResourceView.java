package progetto.server.beans;

public class ResourceView {
    private Integer id;
    private String name;
    private String status;
    private String plan;
    private Integer subscription;
    private Integer service;
    private String category;

    public ResourceView(Integer id, String name, String status, String plan,
            Integer subscription, Integer service,
            String category) {
        this.id = id;
        this.name = name;
        this.status = status;
        this.plan = plan;
        this.subscription = subscription;
        this.service = service;
        this.category = category;
    }

    public Integer getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getStatus() {
        return status;
    }

    public String getPlan() {
        return plan;
    }

    public Integer getSubscription() {
        return subscription;
    }

    public Integer getService() {
        return service;
    }

    public String getCategory() {
        return category;
    }

}
