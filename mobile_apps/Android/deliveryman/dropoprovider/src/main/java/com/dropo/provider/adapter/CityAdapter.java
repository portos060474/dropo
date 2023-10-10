package com.dropo.provider.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.models.datamodels.Cities;

import java.util.ArrayList;
import java.util.List;

public class CityAdapter extends RecyclerView.Adapter<CityAdapter.CountryViewHolder> implements Filterable {

    private final ArrayList<Cities> cityList;
    private List<Cities> filterCityList;

    public CityAdapter(ArrayList<Cities> cityList) {
        this.cityList = cityList;
        this.filterCityList = cityList;
    }

    @NonNull
    @Override
    public CountryViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_city_name, parent, false);
        return new CountryViewHolder(view);
    }

    @Override
    public void onBindViewHolder(CountryViewHolder holder, int position) {
        holder.tvCityName.setText(filterCityList.get(position).getCityName());
    }

    @Override
    public int getItemCount() {
        return filterCityList.size();
    }

    @Override
    public Filter getFilter() {
        return new Filter() {
            @Override
            protected FilterResults performFiltering(CharSequence constraint) {
                String charString = constraint.toString();
                if (charString.isEmpty()) {
                    filterCityList = cityList;
                } else {
                    List<Cities> filteredList = new ArrayList<>();
                    for (Cities row : cityList) {
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
                filterCityList = (List<Cities>) results.values;
                notifyDataSetChanged();
            }
        };
    }

    public List<Cities> getFilterCities() {
        return filterCityList;
    }

    protected static class CountryViewHolder extends RecyclerView.ViewHolder {
        CustomFontTextView tvCityName;

        public CountryViewHolder(View itemView) {
            super(itemView);
            tvCityName = itemView.findViewById(R.id.tvItemCityName);
        }
    }
}