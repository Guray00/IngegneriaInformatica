package progetto.applicazione.manager.beans;

public class ServiceView {

    private Integer id;
    private String name;
    private String category;

    @Override
    public String toString() {
        return String.format("(ID: %s) %s [%s]", id, name, category);
    }

    public ServiceView(Integer id, String name, String category) {
        this.id = id;
        this.name = name;
        this.category = category;
    }

    public ServiceView() {
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

}