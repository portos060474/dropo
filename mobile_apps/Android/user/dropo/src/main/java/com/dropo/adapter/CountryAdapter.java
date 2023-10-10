package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.models.datamodels.Country;

import java.util.ArrayList;
import java.util.List;

public class CountryAdapter extends RecyclerView.Adapter<CountryAdapter.CountryViewHolder> implements Filterable {
    private final ArrayList<Country> countryList;
    private List<Country> filterList;

    public CountryAdapter(ArrayList<Country> countryList) {
        this.countryList = countryList;
        this.filterList = countryList;
    }

    @NonNull
    @Override
    public CountryViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_country_code, parent, false);
        return new CountryViewHolder(view);
    }

    @Override
    public void onBindViewHolder(CountryViewHolder holder, int position) {
        holder.tvCountryName.setText(filterList.get(position).getName());
        holder.tvItemCountryCode.setText(filterList.get(position).getCallingCode());
    }

    @Override
    public int getItemCount() {
        return filterList.size();
    }

    @Override
    public Filter getFilter() {
        return new Filter() {
            @Override
            protected FilterResults performFiltering(CharSequence constraint) {
                String charString = constraint.toString();
                if (charString.isEmpty()) {
                    filterList = countryList;
                } else {
                    List<Country> filteredList = new ArrayList<>();
                    for (Country row : countryList) {
                        if (row.getName().toLowerCase().contains(charString.toLowerCase())) {
                            filteredList.add(row);
                        }
                    }

                    filterList = filteredList;
                }

                FilterResults filterResults = new FilterResults();
                filterResults.values = filterList;
                return filterResults;
            }

            @SuppressLint("NotifyDataSetChanged")
            @Override
            protected void publishResults(CharSequence constraint, FilterResults results) {
                filterList = (List<Country>) results.values;
                notifyDataSetChanged();
            }
        };
    }

    public List<Country> getFilterCountries() {
        return filterList;
    }

    protected static class CountryViewHolder extends RecyclerView.ViewHolder {
        CustomFontTextView tvCountryName, tvItemCountryCode;

        public CountryViewHolder(View itemView) {
            super(itemView);
            tvCountryName = itemView.findViewById(R.id.tvItemCountryName);
            tvItemCountryCode = itemView.findViewById(R.id.tvItemCountryCode);
        }
    }
}