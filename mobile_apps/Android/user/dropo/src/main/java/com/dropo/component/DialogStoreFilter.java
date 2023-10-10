package com.dropo.component;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;

import com.dropo.user.R;
import com.dropo.models.datamodels.Deliveries;
import com.dropo.models.datamodels.FamousProductsTags;
import com.dropo.models.datamodels.Store;
import com.dropo.utils.AppColor;
import com.dropo.utils.Const;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;

public final class DialogStoreFilter extends BottomSheetDialog implements View.OnClickListener {

    private final ArrayList<Store> storeListFiltered;
    private final ArrayList<Store> storeListOriginal;
    private final ArrayList<String> selectedTagList;
    private final ArrayList<Integer> storePrices;
    private final Deliveries deliveries;
    private final FilterListener filterListener;
    private CustomFontEditTextView etStoreSearch;
    private TagView tagView;
    private int storeTime;
    private double storeDistance;
    private CustomFontTextView tvTag, btnPriceOne, btnPriceTwo, btnPriceThree, btnPriceFour, selectedPrice, selectedTime, selectedDistance, btnTimeThree, btnTimeOne, btnTimeTwo, btnDistanceOne, btnDistanceTwo, btnDistanceThree;
    private CustomFontButton btnResetFilter, btnApplyFilter;

    public DialogStoreFilter(@NonNull Context context, Deliveries deliveries, ArrayList<Store> storeList, @NonNull FilterListener filterListener, FilterPreference filterPreference) {
        super(context);
        storeListOriginal = storeList;
        storeListFiltered = new ArrayList<>();
        if (filterPreference == null) {
            filterPreference = new FilterPreference();
        }
        storePrices = filterPreference.storePrices;
        selectedTagList = filterPreference.selectedTagList;
        storeTime = filterPreference.storeTime;
        storeDistance = filterPreference.storeDistance;
        this.deliveries = deliveries;
        this.filterListener = filterListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_store_filter);
        tvTag = findViewById(R.id.tvTag);
        btnPriceOne = findViewById(R.id.btnPriceOne);
        btnPriceTwo = findViewById(R.id.btnPriceTwo);
        btnPriceThree = findViewById(R.id.btnPriceThree);
        btnPriceFour = findViewById(R.id.btnPriceFour);
        btnApplyFilter = findViewById(R.id.btnApplyFilter);
        btnResetFilter = findViewById(R.id.btnResetFilter);
        btnTimeThree = findViewById(R.id.btnTimeThree);
        btnTimeOne = findViewById(R.id.btnTimeOne);
        btnTimeTwo = findViewById(R.id.btnTimeTwo);
        btnDistanceOne = findViewById(R.id.btnDistanceOne);
        btnDistanceTwo = findViewById(R.id.btnDistanceTwo);
        btnDistanceThree = findViewById(R.id.btnDistanceThree);
        etStoreSearch = findViewById(R.id.etStoreSearch);
        tagView = findViewById(R.id.tag_group);
        initTagView();
        btnPriceOne.setOnClickListener(this);
        btnPriceTwo.setOnClickListener(this);
        btnPriceThree.setOnClickListener(this);
        btnPriceFour.setOnClickListener(this);
        btnTimeOne.setOnClickListener(this);
        btnTimeTwo.setOnClickListener(this);
        btnTimeThree.setOnClickListener(this);
        btnApplyFilter.setOnClickListener(this);
        btnResetFilter.setOnClickListener(this);
        btnDistanceOne.setOnClickListener(this);
        btnDistanceTwo.setOnClickListener(this);
        btnDistanceThree.setOnClickListener(this);
        findViewById(R.id.btnDialogAlertLeft).setOnClickListener(this);
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        BottomSheetBehavior<?> behavior = getBehavior();
        behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        loadFilterPreference();
    }

    /**
     * update ui when select price in filter
     *
     * @param view view
     */
    private void setSelectedPrice(CustomFontTextView view) {
        selectedPrice = view;
        view.setBackground(getDrawableWithColor(ResourcesCompat.getDrawable(getContext().getResources(), R.drawable.shape_filter_button_fill, getContext().getTheme()), AppColor.COLOR_THEME));
        view.setTextColor(ResourcesCompat.getColor(getContext().getResources(), R.color.color_white, getContext().getTheme()));
    }

    /**
     * update ui when select time in filter
     *
     * @param view view
     */
    private void setSelectedTime(CustomFontTextView view) {
        selectedTime = view;
        view.setBackground(getDrawableWithColor(ResourcesCompat.getDrawable(getContext().getResources(), R.drawable.shape_filter_button_fill, getContext().getTheme()), AppColor.COLOR_THEME));
        view.setTextColor(ResourcesCompat.getColor(getContext().getResources(), R.color.color_white, getContext().getTheme()));
    }

    /**
     * update ui when select distance in filter
     *
     * @param view view
     */
    private void setSelectedDistance(CustomFontTextView view) {
        if (view != null) {
            selectedDistance = view;
            view.setBackground(getDrawableWithColor(ResourcesCompat.getDrawable(getContext().getResources(), R.drawable.shape_filter_button_fill, getContext().getTheme()), AppColor.COLOR_THEME));
            view.setTextColor(ResourcesCompat.getColor(getContext().getResources(), R.color.color_white, getContext().getTheme()));
        }
    }

    /**
     * this method manage store filer view according to price
     *
     * @param view view
     */
    private void checkSelectedPrice(View view) {
        int id = view.getId();
        if (id == R.id.btnPriceOne) {
            if (storePrices.contains(Const.Store.STORE_PRICE_ONE)) {
                storePrices.remove((Object) Const.Store.STORE_PRICE_ONE);
                resetSelectedPrice((CustomFontTextView) view);
            } else {
                storePrices.add(Const.Store.STORE_PRICE_ONE);
                setSelectedPrice((CustomFontTextView) view);

            }
        } else if (id == R.id.btnPriceTwo) {
            if (storePrices.contains(Const.Store.STORE_PRICE_TWO)) {
                storePrices.remove((Object) Const.Store.STORE_PRICE_TWO);
                resetSelectedPrice((CustomFontTextView) view);
            } else {
                storePrices.add(Const.Store.STORE_PRICE_TWO);
                setSelectedPrice((CustomFontTextView) view);
            }
        } else if (id == R.id.btnPriceThree) {
            if (storePrices.contains(Const.Store.STORE_PRICE_THREE)) {
                storePrices.remove((Object) Const.Store.STORE_PRICE_THREE);
                resetSelectedPrice((CustomFontTextView) view);
            } else {
                storePrices.add(Const.Store.STORE_PRICE_THREE);
                setSelectedPrice((CustomFontTextView) view);
            }
        } else if (id == R.id.btnPriceFour) {
            if (storePrices.contains(Const.Store.STORE_PRICE_FOUR)) {
                storePrices.remove((Object) Const.Store.STORE_PRICE_FOUR);
                resetSelectedPrice((CustomFontTextView) view);
            } else {
                storePrices.add(Const.Store.STORE_PRICE_FOUR);
                setSelectedPrice((CustomFontTextView) view);
            }
        }
    }

    /**
     * this method manage store filer view according to time
     *
     * @param view view
     */
    private void checkSelectedTime(View view) {
        int id = view.getId();
        if (id == R.id.btnTimeOne) {
            storeTime = Const.Store.STORE_TIME_20;
            resetSelectedTime();
            setSelectedTime((CustomFontTextView) view);
        } else if (id == R.id.btnTimeTwo) {
            storeTime = Const.Store.STORE_TIME_60;
            resetSelectedTime();
            setSelectedTime((CustomFontTextView) view);
        } else if (id == R.id.btnTimeThree) {
            storeTime = Const.Store.STORE_TIME_120;
            resetSelectedTime();
            setSelectedTime((CustomFontTextView) view);
        }
    }

    /**
     * this method manage store filer view according to time
     *
     * @param view view
     */
    private void checkSelectedDistance(View view) {
        int id = view.getId();
        if (id == R.id.btnDistanceOne) {
            storeDistance = Const.Store.STORE_DISTANCE_5;
            resetSelectedDistance();
            setSelectedDistance((CustomFontTextView) view);
        } else if (id == R.id.btnDistanceTwo) {
            storeDistance = Const.Store.STORE_DISTANCE_15;
            resetSelectedDistance();
            setSelectedDistance((CustomFontTextView) view);
        } else if (id == R.id.btnDistanceThree) {
            storeDistance = Const.Store.STORE_DISTANCE_25;
            resetSelectedDistance();
            setSelectedDistance((CustomFontTextView) view);
        }
    }

    /**
     * reset ui select price in filter
     */
    private void resetAllSelectedPrice() {
        if (selectedPrice != null) {
            resetSelectedPrice(btnPriceOne);
            resetSelectedPrice(btnPriceTwo);
            resetSelectedPrice(btnPriceThree);
            resetSelectedPrice(btnPriceFour);
        }
    }

    private void resetSelectedPrice(CustomFontTextView view) {
        view.setBackground(null);
        view.setTextColor(AppColor.getThemeTextColor(getContext()));
    }

    /**
     * reset ui select time in filter
     */
    private void resetSelectedTime() {
        if (selectedTime != null) {
            selectedTime.setBackground(null);
            selectedTime.setTextColor(AppColor.getThemeTextColor(getContext()));
        }
    }

    /**
     * reset ui select distance in filter
     */
    private void resetSelectedDistance() {
        if (selectedDistance != null) {
            selectedDistance.setBackground(null);
            selectedDistance.setTextColor(AppColor.getThemeTextColor(getContext()));
        }
    }

    /**
     * reset store filter ui
     */
    private void resetFilter() {
        resetSelectedTime();
        resetAllSelectedPrice();
        resetSelectedDistance();
        storeDistance = 0;
        storeTime = 0;
        storePrices.clear();
        storeListFiltered.clear();
        tagView.clearSelected();
        selectedTagList.clear();
    }

    private void initTagView() {
        if (deliveries.getFamousProductsTags() == null || deliveries.getFamousProductsTags().isEmpty()) {
            tvTag.setVisibility(View.GONE);
        } else {
            tvTag.setVisibility(View.VISIBLE);
            for (FamousProductsTags famousProductsTags : deliveries.getFamousProductsTags()) {
                if (famousProductsTags != null && famousProductsTags.getTag() != null) {
                    tagView.addTag(famousProductsTags.getTag());
                }
            }
        }
        tagView.setOnTagClickListener((v, position) -> {
            if (selectedTagList.contains(deliveries.getFamousProductsTags().get(position).getTagId())) {
                selectedTagList.remove(deliveries.getFamousProductsTags().get(position).getTagId());
                tagView.setSelect(v, false);
            } else {
                selectedTagList.add(deliveries.getFamousProductsTags().get(position).getTagId());
                tagView.setSelect(v, true);
            }
        });
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();// do with default
        if (id == R.id.btnDialogAlertLeft) {
            dismiss();
        } else if (id == R.id.btnResetFilter) {
            filterListener.onResetFilter();
            filterListener.saveStoreFilterPreference(new FilterPreference());
            resetFilter();
        } else if (id == R.id.btnApplyFilter) {
            applyFiltered(!storePrices.isEmpty(), storeTime > 0, storeDistance > 0, !selectedTagList.isEmpty());
            etStoreSearch.getText().clear();
        }
        checkSelectedPrice(view);
        checkSelectedTime(view);
        checkSelectedDistance(view);
    }

    /**
     * apply store filter to get store list as per filter value
     *
     * @param isAnySelectedStorePrice check is any price selected by user
     * @param isDistanceSelected      check is any distance selected by user
     * @param isTimeSelected          check is any time selected by user
     */
    private void applyFiltered(boolean isAnySelectedStorePrice, boolean isTimeSelected, boolean isDistanceSelected, boolean isAnyTagSelected) {
        if (storeListOriginal.isEmpty()) {
            return;
        }
        storeListFiltered.clear();
        if (!isTimeSelected) {
            storeTime = Integer.MAX_VALUE;
        }
        if (!isDistanceSelected) {
            storeDistance = Double.MAX_VALUE;
        }
        if (!isAnySelectedStorePrice && !isTimeSelected && !isDistanceSelected && !isAnyTagSelected) {
            storeListFiltered.addAll(storeListOriginal);
        } else {
            for (Store store : storeListOriginal) {
                if (store.getDeliveryTime() <= storeTime && store.getDistance() <= storeDistance) {
                    if (isAnySelectedStorePrice) {
                        if (storePrices.contains(store.getPriceRating())) {
                            storeListFiltered.add(store);
                        }
                    } else {
                        storeListFiltered.add(store);
                    }
                }
            }

            if (isAnyTagSelected) {
                ArrayList<Store> arrayList = new ArrayList<>();
                for (Store filterStore : storeListFiltered) {
                    boolean isAdded = false;
                    for (String selectedTag : selectedTagList) {
                        for (String famousProductTags : filterStore.getFamousProductsTagIds()) {
                            if (famousProductTags.contains(selectedTag)) {
                                isAdded = true;
                                break;
                            }
                        }
                    }
                    if (isAdded) {
                        arrayList.add(filterStore);
                    }
                }
                storeListFiltered.clear();
                storeListFiltered.addAll(arrayList);
            }
        }
        filterListener.onStoreFilter(storeListFiltered);
        FilterPreference filterPreference = new FilterPreference(selectedTagList, storeTime, storeDistance, storePrices);
        if (!etStoreSearch.getText().toString().trim().isEmpty()) {
            filterPreference.setSearchItemName(etStoreSearch.getText().toString().trim());
            filterListener.onStoreSearchFilter(etStoreSearch.getText().toString(), getContext().getResources().getString(R.string.text_item));
        } else {
            filterPreference.setSearchItemName(null);
        }
        filterListener.saveStoreFilterPreference(filterPreference);
        dismiss();
    }

    private Drawable getDrawableWithColor(Drawable drawable, int colorCode) {
        if (drawable instanceof GradientDrawable) {
            GradientDrawable gradientDrawable = (GradientDrawable) drawable;
            gradientDrawable.setColor(colorCode);
        }
        return drawable;
    }

    private void loadFilterPreference() {
        if (!selectedTagList.isEmpty()) {
            tagView.setPreviousSelectedTag(selectedTagList);
        }
        if (!storePrices.isEmpty()) {
            for (Integer price : storePrices) {
                if (price == Const.Store.STORE_PRICE_ONE) {
                    resetSelectedPrice(btnPriceOne);
                    setSelectedPrice(btnPriceOne);
                }
                if (price == Const.Store.STORE_PRICE_TWO) {
                    resetSelectedPrice(btnPriceTwo);
                    setSelectedPrice(btnPriceTwo);
                }
                if (price == Const.Store.STORE_PRICE_THREE) {
                    resetSelectedPrice(btnPriceThree);
                    setSelectedPrice(btnPriceThree);
                }
                if (price == Const.Store.STORE_PRICE_FOUR) {
                    resetSelectedPrice(btnPriceFour);
                    setSelectedPrice(btnPriceFour);
                }

            }
        }

        switch (storeTime) {
            case Const.Store.STORE_TIME_20:
                resetSelectedTime();
                setSelectedTime(btnTimeOne);
                break;
            case Const.Store.STORE_TIME_60:
                resetSelectedTime();
                setSelectedTime(btnTimeTwo);
                break;
            case Const.Store.STORE_TIME_120:
                resetSelectedTime();
                setSelectedTime(btnTimeThree);
                break;

        }
        switch ((int) storeDistance) {
            case Const.Store.STORE_DISTANCE_5:
                resetSelectedDistance();
                setSelectedDistance(btnDistanceOne);
                break;
            case Const.Store.STORE_DISTANCE_15:
                resetSelectedDistance();
                setSelectedDistance(btnDistanceTwo);
                break;
            case Const.Store.STORE_DISTANCE_25:
                resetSelectedDistance();
                setSelectedDistance(btnDistanceThree);
                break;
        }
    }

    public interface FilterListener {
        void onStoreFilter(ArrayList<Store> storeListFiltered);

        void onStoreSearchFilter(String filter, String filterBy);

        void onResetFilter();

        void saveStoreFilterPreference(FilterPreference filterPreference);
    }

    public static class FilterPreference {
        private ArrayList<String> selectedTagList = new ArrayList<>();
        private int storeTime = 0;
        private double storeDistance = 0;
        private ArrayList<Integer> storePrices = new ArrayList<>();
        private String searchItemName;

        public FilterPreference(ArrayList<String> selectedTagList, int storeTime, double storeDistance, ArrayList<Integer> storePrices) {
            this.selectedTagList = selectedTagList;
            this.storeTime = storeTime;
            this.storeDistance = storeDistance;
            this.storePrices = storePrices;
        }

        public FilterPreference() {
        }

        public String getSearchItemName() {
            return searchItemName;
        }

        public void setSearchItemName(String searchItemName) {
            this.searchItemName = searchItemName;
        }
    }
}