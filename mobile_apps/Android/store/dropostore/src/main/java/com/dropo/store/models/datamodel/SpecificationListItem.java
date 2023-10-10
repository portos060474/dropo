package com.dropo.store.models.datamodel;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

@Generated("com.robohorse.robopojogenerator")
public class SpecificationListItem {

    @SerializedName("is_user_selected")
    @Expose
    private boolean isUserSelected;

    @SerializedName("price")
    @Expose
    private double price;

    @SerializedName("name")
    @Expose
    private String name;

    @SerializedName("_id")
    @Expose
    private String id;

    @SerializedName("is_default_selected")
    @Expose
    private boolean isDefaultSelected;

    public boolean isIsUserSelected() {
        return isUserSelected;
    }

    public void setIsUserSelected(boolean isUserSelected) {
        this.isUserSelected = isUserSelected;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isIsDefaultSelected() {
        return isDefaultSelected;
    }

    public void setIsDefaultSelected(boolean isDefaultSelected) {
        this.isDefaultSelected = isDefaultSelected;
    }
}