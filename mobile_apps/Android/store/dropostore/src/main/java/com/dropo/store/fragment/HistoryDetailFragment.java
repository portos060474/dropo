package com.dropo.store.fragment;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.dropo.store.FeedbackActivity;
import com.dropo.store.R;
import com.dropo.store.models.datamodel.OrderPaymentDetail;
import com.dropo.store.models.datamodel.ProviderDetail;
import com.dropo.store.models.datamodel.UserDetail;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomFontTextViewTitle;
import com.dropo.store.widgets.CustomTextView;

import java.text.ParseException;
import java.util.Date;

public class HistoryDetailFragment extends BaseHistoryFragment {

    private CustomTextView tvAddressHistory, tvTimeHistory, tvDistanceHistory, tvCreatedDate,
            tvDeliveredDate, tvUserRatings, tvProviderRatings;
    private ImageView ivClientHistory, ivProviderHistory;
    private LinearLayout llRateUser, llRateProvider, llOrderReceiveBy;
    private CustomFontTextViewTitle tvClientNameHistory, tvProviderNameHistory, tvOrderReceiverName;
    private CustomTextView tvTagDeliveryDetails;
    private LinearLayout llDriverDetail, llDeliveryTime;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_history_detail, container, false);
        llRateProvider = view.findViewById(R.id.llRateProvider);
        llRateUser = view.findViewById(R.id.llRateUser);
        tvTagDeliveryDetails = view.findViewById(R.id.tvTagDeliveryDetails);
        tvClientNameHistory = view.findViewById(R.id.tvClientNameHistory);
        tvProviderNameHistory = view.findViewById(R.id.tvProviderNameHistory);
        tvAddressHistory = view.findViewById(R.id.tvAddressHistory);
        tvTimeHistory = view.findViewById(R.id.tvTimeHistory);
        tvDistanceHistory = view.findViewById(R.id.tvDistanceHistory);
        ivClientHistory = view.findViewById(R.id.ivClientHistory);
        ivProviderHistory = view.findViewById(R.id.ivProviderHistory);
        tvCreatedDate = view.findViewById(R.id.tvCreatedDate);
        tvDeliveredDate = view.findViewById(R.id.tvDeliveredDate);
        llOrderReceiveBy = view.findViewById(R.id.llOrderReceiveBy);
        tvOrderReceiverName = view.findViewById(R.id.tvOrderReceiverName);
        llDriverDetail = view.findViewById(R.id.llDriverDetail);
        llDeliveryTime = view.findViewById(R.id.llDeliveryTime);
        tvProviderRatings = view.findViewById(R.id.tvProviderRatings);
        tvUserRatings = view.findViewById(R.id.tvUserRatings);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        llRateUser.setOnClickListener(this);
        llRateProvider.setOnClickListener(this);
        setHistoryDetails();
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.llRateProvider) {
            if (!activity.detailsResponse.getOrder().isStoreRatedToProvider())
                goToFeedbackActivity(null, activity.detailsResponse.getProviderDetail(), Constant.REQUEST_PROVIDER_RATING);
        } else if (id == R.id.llRateUser) {
            if (!activity.detailsResponse.getOrder().isStoreRatedToUser())
                if (activity.detailsResponse.getUserDetail() != null) {
                    goToFeedbackActivity(activity.detailsResponse.getUserDetail(), null, Constant.REQUEST_USER_RATING);
                } else {
                    Utilities.showToast(activity, getString(R.string.msg_user_data_not_found));
                }
        }
    }

    private void setHistoryDetails() {
        if (activity.detailsResponse.getUserDetail() != null && activity.detailsResponse.getUserDetail().getFirstName() != null
                && activity.detailsResponse.getUserDetail().getLastName() != null) {
            tvClientNameHistory.setText(String.format("%s %s", activity.detailsResponse.getUserDetail().getFirstName(), activity.detailsResponse.getUserDetail().getLastName()));
        } else {
            tvClientNameHistory.setText("");
        }
        Glide.with(this).load(IMAGE_URL + (activity.detailsResponse.getUserDetail() == null ? "" : activity.detailsResponse.getUserDetail().getImageUrl())).placeholder(R.drawable.placeholder).dontAnimate().fallback(R.drawable.placeholder).into(ivClientHistory);
        tvProviderNameHistory.setText(activity.detailsResponse.getProviderDetail() == null ? "" : activity.detailsResponse.getProviderDetail().getFirstName() + " " + activity.detailsResponse.getProviderDetail().getLastName());
        Glide.with(this).load(IMAGE_URL + (activity.detailsResponse.getProviderDetail() == null ? "" : activity.detailsResponse.getProviderDetail().getImageUrl())).placeholder(R.drawable.placeholder).dontAnimate().fallback(R.drawable.placeholder).into(ivProviderHistory);

        OrderPaymentDetail orderPaymentDetail = activity.detailsResponse.getOrder().getOrderPaymentDetail();
        tvTimeHistory.setText(Utilities.minuteToHoursMinutesSeconds(orderPaymentDetail.getTotalItem()));
        String unit = activity.detailsResponse.getOrder().getOrderPaymentDetail().isIsDistanceUnitMile() ? getResources().getString(R.string.unit_mile) : getResources().getString(R.string.unit_km);
        tvDistanceHistory.setText(String.format("%s %s", ParseContent.getInstance().decimalTwoDigitFormat.format(orderPaymentDetail.getTotalDistance()), unit));
        try {
            Date date = ParseContent.getInstance().webFormat.parse(activity.detailsResponse.getOrder().getCreatedAt());
            Date date1 = ParseContent.getInstance().webFormat.parse(activity.detailsResponse.getOrder().getCompletedAt());
            if (date != null) {
                tvCreatedDate.setText(String.format("%s %s", Utilities.getDayOfMonthSuffix(Integer.parseInt(ParseContent.getInstance().day.format(date))), ParseContent.getInstance().dateFormatMonth.format(date)));
            }
            if (date1 != null) {
                tvDeliveredDate.setText(String.format("%s %s", Utilities.getDayOfMonthSuffix(Integer.parseInt(ParseContent.getInstance().day.format(date1))), ParseContent.getInstance().dateFormatMonth.format(date1)));
            }
        } catch (ParseException e) {
            Utilities.handleException(Constant.Tag.HISTORY_DETAILS_ACTIVITY, e);
        }

        tvAddressHistory.setText(activity.detailsResponse.getOrder().getCartDetail().getDestinationAddresses().get(0).getAddress());

        // is update detail UI when provider detail not available
        if (activity.detailsResponse.getOrder().getOrderPaymentDetail().isUserPickUpOrder() || activity.detailsResponse.getOrder().getOrderStatus() == Constant.USER_CANCELED_ORDER || activity.detailsResponse.getOrder().getOrderStatus() == Constant.STORE_ORDER_CANCELLED || activity.detailsResponse.getOrder().getDeliveryType() == Constant.DeliveryType.TABLE_BOOKING) {
            llDriverDetail.setVisibility(View.GONE);
            llDeliveryTime.setVisibility(View.GONE);
            tvTagDeliveryDetails.setVisibility(View.GONE);
        } else {
            llDriverDetail.setVisibility(View.VISIBLE);
            llDeliveryTime.setVisibility(View.VISIBLE);
            tvTagDeliveryDetails.setVisibility(View.VISIBLE);
        }
        if (activity.detailsResponse.getOrder().isStoreRatedToUser() || activity.detailsResponse.getOrder().getOrderStatus() != Constant.DELIVERY_MAN_COMPLETE_DELIVERY) {
            llRateUser.setVisibility(View.GONE);
        } else {
            llRateUser.setVisibility(View.VISIBLE);
        }

        if (activity.detailsResponse.getOrder().isStoreRatedToUser()) {
            tvUserRatings.setVisibility(View.VISIBLE);
            tvUserRatings.setText(String.valueOf(activity.detailsResponse.getOrder().getReviewDetail().getStoreRatingToUser()));
        } else {
            tvUserRatings.setVisibility(View.GONE);
        }

        if (activity.detailsResponse.getOrder().isStoreRatedToProvider()) {
            llRateProvider.setVisibility(View.GONE);
        } else {
            llRateProvider.setVisibility(View.VISIBLE);
        }

        if (activity.detailsResponse.getOrder().isStoreRatedToProvider()) {
            tvProviderRatings.setVisibility(View.VISIBLE);
            tvProviderRatings.setText(String.valueOf(activity.detailsResponse.getOrder().getReviewDetail().getStoreRatingToProvider()));
        } else {
            tvProviderRatings.setVisibility(View.GONE);
        }

        if (TextUtils.isEmpty(activity.detailsResponse.getOrder().getCartDetail().getDestinationAddresses().get(0).getUserDetails().getName())) {
            llOrderReceiveBy.setVisibility(View.GONE);
        } else {
            llOrderReceiveBy.setVisibility(View.VISIBLE);
            tvOrderReceiverName.setText(activity.detailsResponse.getOrder().getCartDetail().getDestinationAddresses().get(0).getUserDetails().getName());
        }
    }

    private void goToFeedbackActivity(UserDetail userDetail, ProviderDetail providerDetail, int requestCode) {
        Intent intent = new Intent(activity, FeedbackActivity.class);
        intent.putExtra(Constant.ORDER_ID, activity.detailsResponse.getOrder().getId());
        intent.putExtra(Constant.USER_DETAIL, userDetail);
        intent.putExtra(Constant.PROVIDER_DETAIL, providerDetail);
        startActivityForResult(intent, requestCode);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case Constant.REQUEST_PROVIDER_RATING:
                    llRateProvider.setVisibility(View.GONE);
                    activity.detailsResponse.getOrder().setStoreRatedToProvider(true);
                    break;
                case Constant.REQUEST_USER_RATING:
                    llRateUser.setVisibility(View.GONE);
                    activity.detailsResponse.getOrder().setStoreRatedToUser(true);
                    break;
                default:
                    break;
            }
        }

    }
}