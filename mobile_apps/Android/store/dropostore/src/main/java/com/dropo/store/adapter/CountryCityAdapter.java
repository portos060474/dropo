package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.City;
import com.dropo.store.models.datamodel.Country;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;
import java.util.List;

public class CountryCityAdapter extends RecyclerView.Adapter<CountryCityAdapter.CountryViewHolder> implements Filterable {

    private final ArrayList<Country> countryList;
    private final ArrayList<City> cityList;
    private List<Country> filterCountryList;
    private List<City> filterCityList;
    private final boolean isCountry;

    public CountryCityAdapter(ArrayList<Country> countryList, ArrayList<City> cityList, boolean isCountry) {
        this.countryList = countryList;
        this.filterCountryList = countryList;
        this.cityList = cityList;
        this.filterCityList = cityList;
        this.isCountry = isCountry;
    }

    @NonNull
    @Override
    public CountryViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_country_city, parent, false);
        return new CountryViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull CountryViewHolder holder, int position) {
        if (isCountry) {
            holder.tvItemCountryCode.setVisibility(View.VISIBLE);

            holder.tvCountryName.setText(filterCountryList.get(position).getCountryName());
            holder.tvItemCountryCode.setText(filterCountryList.get(position).getCountryPhoneCode());
        } else {
            holder.tvItemCountryCode.setVisibility(View.GONE);
            holder.tvCountryName.setText(filterCityList.get(position).getCityName());
        }
    }

    @Override
    public int getItemCount() {
        return isCountry ? filterCountryList.size() : filterCityList.size();
    }

    @Override
    public Filter getFilter() {
        return isCountry ? countryFilter : cityFilter;
    }

    private final Filter countryFilter = new Filter() {
        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            String charString = constraint.toString();
            if (charString.isEmpty()) {
                filterCountryList = countryList;
            } else {
                List<Country> filteredList = new ArrayList<>();
                for (Country row : countryList) {
                    if (row.getCountryName().toLowerCase().contains(charString.toLowerCase())) {
                        filteredList.add(row);
                    }
                }

                filterCountryList = filteredList;
            }

            FilterResults filterResults = new FilterResults();
            filterResults.values = filterCountryList;
            return filterResults;
        }

        @SuppressLint("NotifyDataSetChanged")
        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            filterCountryList = (List<Country>) results.values;
            notifyDataSetChanged();
        }
    };

    private final Filter cityFilter = new Filter() {
        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            String charString = constraint.toString();
            if (charString.isEmpty()) {
                filterCityList = cityList;
            } else {
                List<City> filteredList = new ArrayList<>();
                for (City row : cityList) {
                    if (row.getCityName().toLowerCase().contains(charString.toLowerCase())) {
                        filteredList.add(row);
                    }
                }

                filterCityList = filteredList;
            }

            FilterResults filterResults = new FilterResults();
            filterResults.values = filterCityList;
            return filterResults;
        }

        @SuppressLint("NotifyDataSetChanged")
        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            filterCityList = (List<City>) results.values;
            notifyDataSetChanged();
        }
    };

    public List<Country> getFilterCountries() {
        return filterCountryList;
    }

    public List<City> getFilterCities() {
        return filterCityList;
    }

    protected static class CountryViewHolder extends RecyclerView.ViewHolder {
        CustomTextView tvCountryName, tvItemCountryCode;

        public CountryViewHolder(View itemView) {
            super(itemView);
            tvCountryName = itemView.findViewById(R.id.tvItemCountryName);
            tvItemCountryCode = itemView.findViewById(R.id.tvItemCountryCode);
        }
    }
}