package com.dropo.provider.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Vehicle implements Parcelable {


    public static final Parcelable.Creator<Vehicle> CREATOR = new Parcelable.Creator<Vehicle>() {
        @Override
        public Vehicle createFromParcel(Parcel source) {
            return new Vehicle(source);
        }

        @Override
        public Vehicle[] newArray(int size) {
            return new Vehicle[size];
        }
    };
    @SerializedName("admin_vehicle_id")
    private String adminVehicleId;
    @SerializedName("vehicle_detail")
    private List<VehicleDetail> vehicleDetail;
    private boolean isSelected;
    @SerializedName("is_approved")
    private Boolean isApproved;
    @SerializedName("vehicle_color")
    private String vehicleColor;
    @SerializedName("is_document_uploaded")
    private Boolean isDocumentUploaded;
    @SerializedName("vehicle_model")
    private String vehicleModel;
    @SerializedName("server_token")
    private String serverToken;
    @SerializedName("vehicle_year")
    private String vehiclePassingYear;
    @SerializedName("vehicle_plate_no")
    private String vehiclePlateNo;
    @SerializedName("service_id")
    private String serviceId;
    @SerializedName("provider_id")
    private String providerId;
    @SerializedName("_id")
    private String id;
    @SerializedName("vehicle_id")
    private String vehicleId;
    @SerializedName("vehicle_name")
    private String vehicleName;

    public Vehicle() {
    }

    protected Vehicle(Parcel in) {
        this.isSelected = in.readByte() != 0;
        this.isApproved = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.vehicleColor = in.readString();
        this.isDocumentUploaded = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.vehicleModel = in.readString();
        this.serverToken = in.readString();
        this.vehiclePassingYear = in.readString();
        this.vehiclePlateNo = in.readString();
        this.serviceId = in.readString();
        this.providerId = in.readString();
        this.id = in.readString();
        this.vehicleId = in.readString();
        this.vehicleName = in.readString();
    }

    public String getAdminVehicleId() {
        return adminVehicleId;
    }

    public void setAdminVehicleId(String adminVehicleId) {
        this.adminVehicleId = adminVehicleId;
    }

    public List<VehicleDetail> getVehicleDetail() {
        return vehicleDetail;
    }

    public void setVehicleDetail(List<VehicleDetail> vehicleDetail) {
        this.vehicleDetail = vehicleDetail;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public Boolean getApproved() {
        return isApproved;
    }

    public void setApproved(Boolean approved) {
        isApproved = approved;
    }

    public String getVehicleColor() {
        return vehicleColor;
    }

    public void setVehicleColor(String vehicleColor) {
        this.vehicleColor = vehicleColor;
    }

    public Boolean isIsDocumentUploaded() {
        return isDocumentUploaded;
    }

    public void setIsDocumentUploaded(Boolean isDocumentUploaded) {
        this.isDocumentUploaded = isDocumentUploaded;
    }

    public String getVehicleModel() {
        return vehicleModel;
    }

    public void setVehicleModel(String vehicleModel) {
        this.vehicleModel = vehicleModel;
    }

    public String getServerToken() {
        return serverToken;
    }

    public void setServerToken(String serverToken) {
        this.serverToken = serverToken;
    }

    public String getVehiclePassingYear() {
        return vehiclePassingYear;
    }

    public void setVehiclePassingYear(String vehiclePassingYear) {
        this.vehiclePassingYear = vehiclePassingYear;
    }

    public String getVehiclePlateNo() {
        return vehiclePlateNo;
    }

    public void setVehiclePlateNo(String vehiclePlateNo) {
        this.vehiclePlateNo = vehiclePlateNo;
    }

    public String getServiceId() {
        return serviceId;
    }

    public void setServiceId(String serviceId) {
        this.serviceId = serviceId;
    }

    public String getProviderId() {
        return providerId;
    }

    public void setProviderId(String providerId) {
        this.providerId = providerId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(String vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getVehicleName() {
        return vehicleName;
    }

    public void setVehicleName(String vehicleName) {
        this.vehicleName = vehicleName;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte(this.isSelected ? (byte) 1 : (byte) 0);
        dest.writeValue(this.isApproved);
        dest.writeString(this.vehicleColor);
        dest.writeValue(this.isDocumentUploaded);
        dest.writeString(this.vehicleModel);
        dest.writeString(this.serverToken);
        dest.writeString(this.vehiclePassingYear);
        dest.writeString(this.vehiclePlateNo);
        dest.writeString(this.serviceId);
        dest.writeString(this.providerId);
        dest.writeString(this.id);
        dest.writeString(this.vehicleId);
        dest.writeString(this.vehicleName);
    }
}