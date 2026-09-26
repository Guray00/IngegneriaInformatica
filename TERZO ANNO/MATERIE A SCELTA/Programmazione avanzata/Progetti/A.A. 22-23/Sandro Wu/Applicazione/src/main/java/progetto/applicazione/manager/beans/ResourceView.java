package progetto.applicazione.manager.beans;

public class ResourceView {
    private Integer id;
    private String name;
    private String service;
    private String category;
    private String subscription;
    private String plan;
    private String status;

    public ResourceView(Integer id, String name, String service, String category, String subscription, String plan,
            String status) {
        this.id = id;
        this.name = name;
        this.service = service;
        this.category = category;
        this.subscription = subscription;
        this.plan = plan;
        this.status = status;
    }

    public ResourceView() {
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

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSubscription() {
        return subscription;
    }

    public void setSubscription(String subscription) {
        this.subscription = subscription;
    }

    public String getPlan() {
        return plan;
    }

    public void setPlan(String plan) {
        this.plan = plan;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
