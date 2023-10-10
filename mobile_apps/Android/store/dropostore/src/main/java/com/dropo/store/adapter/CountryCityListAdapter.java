package com.dropo.store.adapter;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.Category;
import com.dropo.store.models.datamodel.City;
import com.dropo.store.models.datamodel.Country;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.GlideApp;


import java.util.ArrayList;

public class CountryCityListAdapter extends RecyclerView.Adapter<CountryCityListAdapter.ViewHolder> {

    private final Context context;
    private ArrayList<Country> countryList;
    private ArrayList<City> cityList;
    private ArrayList<Category> deliveryList;
    private boolean isCountryList;
    private int deliveryCode;

    public CountryCityListAdapter(Context context, ArrayList<Country> countryList, boolean isCountryList) {
        this.countryList = countryList;
        this.context = context;
        this.isCountryList = isCountryList;
    }

    public CountryCityListAdapter(Context context, ArrayList<City> cityList) {
        this.cityList = cityList;
        this.context = context;
    }

    public CountryCityListAdapter(Context context, ArrayList<Category> deliveryList, int deliveryCode) {
        this.context = context;
        this.deliveryList = deliveryList;
        this.deliveryCode = deliveryCode;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.adapter_general, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        if (deliveryCode != 0) {
            Category category = deliveryList.get(position);
            holder.tvName.setText(category.getDeliveryName());
            GlideApp.with(context).load(IMAGE_URL + category.getImageUrl())
                    .placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .error(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .into(holder.ivType);
            holder.tvCode.setVisibility(View.GONE);
            if (category.getDeliveryType() == Constant.DeliveryType.COURIER) {
                holder.itemView.setVisibility(View.GONE);
            } else {
                holder.itemView.setVisibility(View.VISIBLE);
            }
        } else {
            if (isCountryList) {
                Country country = countryList.get(position);
                holder.tvName.setText(country.getCountryName());
                holder.tvCode.setText(country.getCountryPhoneCode());
                holder.tvCode.setVisibility(View.VISIBLE);
                holder.ivType.setVisibility(View.GONE);
            } else {
                City city = cityList.get(position);
                holder.tvName.setText(city.getCityName());
                holder.tvCode.setVisibility(View.GONE);
                holder.ivType.setVisibility(View.GONE);
            }
        }
    }

    @Override
    public int getItemCount() {
        if (deliveryCode > 0) {
            return deliveryList.size();
        } else {
            if (isCountryList) {
                return countryList.size();
            } else {
                return cityList.size();
            }
        }
    }

    protected static class ViewHolder extends RecyclerView.ViewHolder {
        TextView tvCode, tvName;
        ImageView ivType;

        ViewHolder(View itemView) {
            super(itemView);
            tvCode = itemView.findViewById(R.id.tvCode);
            tvName = itemView.findViewById(R.id.tvName);
            ivType = itemView.findViewById(R.id.ivType);
        }
    }
}