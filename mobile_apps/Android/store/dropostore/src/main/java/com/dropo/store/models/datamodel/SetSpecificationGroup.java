package com.dropo.store.models.datamodel;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

import javax.annotation.Generated;

@Generated("com.robohorse.robopojogenerator")
public class SetSpecificationGroup {

    @SerializedName("store_id")
    @Expose
    private String storeId;

    @SerializedName("product_id")
    @Expose
    private String productId;

    @SerializedName("server_token")
    @Expose
    private String serverToken;
    @SerializedName("specification_group_name")
    @Expose
    private List<List<String>> specificationGroup;
    @SerializedName("name")
    @Expose
    private List<String> name;
    @SerializedName("sequence_number")
    @Expose
    private Long sequenceNumber;
    @SerializedName("sp_id")
    @Expose
    private String spId;
    @SerializedName("specification_price")
    @Expose
    private String specificationPrice;

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getServerToken() {
        return serverToken;
    }

    public void setServerToken(String serverToken) {
        this.serverToken = serverToken;
    }

    public void setSpecificationGroup(List<List<String>> specificationGroup) {
        this.specificationGroup = specificationGroup;
    }

    public String getSpecificationPrice() {
        return specificationPrice;
    }

    public void setSpecificationPrice(String specificationPrice) {
        this.specificationPrice = specificationPrice;
    }

    public List<String> getName() {
        return name;
    }

    public void setName(List<String> name) {
        this.name = name;
    }

    public String getSpId() {
        return spId;
    }

    public void setSpId(String spId) {
        this.spId = spId;
    }

    public Long getSequenceNumber() {
        return sequenceNumber;
    }

    public void setSequenceNumber(long sequenceNumber) {
        this.sequenceNumber = sequenceNumber;
    }
}