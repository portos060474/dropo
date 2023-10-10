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
import com.dropo.provider.models.datamodels.Countries;

import java.util.ArrayList;
import java.util.List;

public class CountryAdapter extends RecyclerView.Adapter<CountryAdapter.CountryViewHolder> implements Filterable {

    private final ArrayList<Countries> countryList;
    private List<Countries> filterCountryList;


    public CountryAdapter(ArrayList<Countries> countryList) {
        this.countryList = countryList;
        this.filterCountryList = countryList;
    }

    @NonNull
    @Override
    public CountryViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_country_code, parent, false);
        return new CountryViewHolder(view);
    }

    @Override
    public void onBindViewHolder(CountryViewHolder holder, int position) {
        holder.tvCountryCodeDigit.setText(filterCountryList.get(position).getCountryPhoneCode());
        holder.tvCountryName.setText(filterCountryList.get(position).getCountryName());
    }

    @Override
    public int getItemCount() {
        return filterCountryList.size();
    }

    @Override
    public Filter getFilter() {
        return new Filter() {
            @Override
            protected FilterResults performFiltering(CharSequence constraint) {
                String charString = constraint.toString();
                if (charString.isEmpty()) {
                    filterCountryList = countryList;
                } else {
                    List<Countries> filteredList = new ArrayList<>();
                    for (Countries row : countryList) {
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
                filterCountryList = (List<Countries>) results.values;
                notifyDataSetChanged();
            }
        };
    }

    public List<Countries> getFilterCountries() {
        return filterCountryList;
    }

    protected static class CountryViewHolder extends RecyclerView.ViewHolder {
        CustomFontTextView tvCountryCodeDigit, tvCountryName;

        public CountryViewHolder(View itemView) {
            super(itemView);
            tvCountryCodeDigit = itemView.findViewById(R.id.tvCountryCodeDigit);
            tvCountryName = itemView.findViewById(R.id.tvItemCountryName);
        }
    }
}