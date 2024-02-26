/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.server.database.table;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 *
 * @author sandro
 */
@Entity
@Table(name = "resource")
public class Resource {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Integer id;

	@Column(name = "name")
	private String name;

	@Column(name = "subscription_id")
	private Integer subscriptionId;

	@Column(name = "service_id")
	private Integer serviceId;

	@Column(name = "status")
	private String status;

	@Column(name = "plan")
	private String plan;

	public Resource() {
	}

	public Resource(String name, Integer subscriptionId, Integer serviceId, String status, String plan) {
		this.name = name;
		this.subscriptionId = subscriptionId;
		this.serviceId = serviceId;
		this.status = status;
		this.plan = plan;
	}

	public Resource(Integer id, String name, Integer subscriptionId, Integer serviceId, String status, String plan) {
		this.id = id;
		this.name = name;
		this.subscriptionId = subscriptionId;
		this.serviceId = serviceId;
		this.status = status;
		this.plan = plan;
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

	public Integer getSubscriptionId() {
		return subscriptionId;
	}

	public void setSubscriptionId(Integer subscriptionId) {
		this.subscriptionId = subscriptionId;
	}

	public Integer getServiceId() {
		return serviceId;
	}

	public void setServiceId(Integer serviceId) {
		this.serviceId = serviceId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPlan() {
		return plan;
	}

	public void setPlan(String plan) {
		this.plan = plan;
	}

}
