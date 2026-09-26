package progetto.applicazione.manager.beans;

public class SubscriptionView {
    public Integer id;
    public String name;
    public String status;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return String.format("[%s] %s", id, name);
    }

    public SubscriptionView(Integer id, String name, String status) {
        this.id = id;
        this.name = name;
        this.status = status;
    }

    public SubscriptionView(Integer id, String name) {
        this.id = id;
        this.name = name;
    }

    public SubscriptionView() {
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

}
