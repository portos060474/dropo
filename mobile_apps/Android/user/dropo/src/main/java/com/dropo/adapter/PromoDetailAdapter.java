package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.models.datamodels.PromoCodes;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ParseContent;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;
import com.dropo.utils.PreferenceHelper;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public abstract class PromoDetailAdapter extends RecyclerView.Adapter<PromoDetailAdapter.CategoryViewHolder> {

    private final List<PromoCodes> promoCodes;
    private final Context context;
    private final ImageHelper imageHelper;
    private final boolean isApply;
    private final ParseContent parseContent;
    private final int promoImageHeight;
    private int promoImageWidth;

    public PromoDetailAdapter(Context context, List<PromoCodes> promoCodes, boolean isApply) {
        this.context = context;
        this.promoCodes = promoCodes;
        this.imageHelper = new ImageHelper(context);
        this.isApply = isApply;
        parseContent = ParseContent.getInstance();
        int screenPadding = context.getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding); // screen padding
        promoImageWidth = context.getResources().getDisplayMetrics().widthPixels;
        promoImageWidth = ((promoImageWidth - (screenPadding * 5)) / 4);
        promoImageHeight = (int) (promoImageWidth / ImageHelper.ASPECT_RATIO);
    }

    @NonNull
    @Override
    public CategoryViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new CategoryViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_promo_detail, parent, false));
    }

    @SuppressLint("StringFormatInvalid")
    @Override
    public void onBindViewHolder(@NonNull CategoryViewHolder holder, int position) {
        PromoCodes promo = promoCodes.get(position);
        holder.ivPromo.getLayoutParams().width = promoImageWidth;
        holder.ivPromo.getLayoutParams().height = promoImageHeight;
        GlideApp.with(context)
                .load(imageHelper.getImageUrlAccordingSize(promo.getImageUrl(), holder.ivPromo))
                .addListener(imageHelper.registerGlideLoadFiledListener(holder.ivPromo, promo.getImageUrl()))
                .dontAnimate()
                .placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                .fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                .into(holder.ivPromo);
        holder.tvPromoCode.setText(promo.getPromoCodeName());
        holder.tvPromoCodeDetail.setText(promo.getPromoDetails());
        holder.btnTC.setVisibility(View.GONE);
        holder.div.setVisibility(View.VISIBLE);

        if (promo.getPromoApplyAfterCompletedOrder() > 0 && promo.isPromoApplyOnCompletedOrder()) {
            holder.tvCompleteOrder.setVisibility(View.VISIBLE);
            holder.btnTC.setVisibility(View.VISIBLE);
            holder.div.setVisibility(View.VISIBLE);
            holder.tvCompleteOrder.setText(context.getResources().getString(R.string.text_promo_appy_after_complete_order, String.valueOf(promo.getPromoApplyAfterCompletedOrder())));
        } else {
            holder.tvCompleteOrder.setVisibility(View.GONE);
        }
        if (promo.getPromoRecursionType() > 0 && promo.isPromoRequiredUses()) {
            holder.btnTC.setVisibility(View.VISIBLE);
            holder.div.setVisibility(View.VISIBLE);
            holder.tvFirstUser.setVisibility(View.VISIBLE);
            holder.tvFirstUser.setText(context.getResources().getString(R.string.text_promo_appy_first_users, String.valueOf(promo.getPromoRecursionType())));
        } else {
            holder.tvFirstUser.setVisibility(View.GONE);
        }

        if (promo.getPromoCodeApplyOnMinimumAmount() > 0 && promo.isPromoHaveMinimumAmountLimit()) {
            holder.btnTC.setVisibility(View.VISIBLE);
            holder.div.setVisibility(View.VISIBLE);
            holder.tvMinOrderPrice.setVisibility(View.VISIBLE);
            holder.tvMinOrderPrice.setText(context.getResources().getString(R.string.text_promo_appy_min_order, CurrentBooking.getInstance().getCurrency() + promo.getPromoCodeApplyOnMinimumAmount()));
        } else {
            holder.tvMinOrderPrice.setVisibility(View.GONE);
        }

        if (promo.getPromoCodeMaxDiscountAmount() > 0 && promo.isPromoHaveMaxDiscountLimit()) {
            holder.btnTC.setVisibility(View.VISIBLE);
            holder.div.setVisibility(View.VISIBLE);
            holder.tvUpToDiscount.setVisibility(View.VISIBLE);
            holder.tvUpToDiscount.setText(context.getResources().getString(R.string.text_promo_discount, promo.getPromoCodeType() == Const.Type.PERCENTAGE ? promo.getPromoCodeMaxDiscountAmount() + "%" : CurrentBooking.getInstance().getCurrency() + promo.getPromoCodeMaxDiscountAmount()));
        } else {
            holder.tvUpToDiscount.setVisibility(View.GONE);
        }
        if (promo.getPromoCodeApplyOnMinimumItemCount() > 0 && promo.isPromoHaveItemCountLimit()) {
            holder.btnTC.setVisibility(View.VISIBLE);
            holder.div.setVisibility(View.VISIBLE);
            holder.tvMinItem.setVisibility(View.VISIBLE);
            holder.tvMinItem.setText(context.getResources().getString(R.string.text_promo_min_item, String.valueOf(promo.getPromoCodeApplyOnMinimumItemCount())));
        } else {
            holder.tvMinItem.setVisibility(View.GONE);
        }
        if (isApply) {
            holder.btnApplyPromo.setVisibility(View.VISIBLE);
            if (TextUtils.isEmpty(PreferenceHelper.getInstance(context).getUserId())) {
                holder.btnApplyPromo.setAlpha(0.5f);
            } else {
                holder.btnApplyPromo.setAlpha(1);
                holder.btnApplyPromo.setOnClickListener(view -> promoApply(promo));
            }
        } else {
            holder.btnApplyPromo.setVisibility(View.GONE);
        }

        if (promo.isPromoHaveDate() && !TextUtils.isEmpty(promo.getPromoStartDate()) && !TextUtils.isEmpty(promo.getPromoExpireDate())) {
            try {
                Date webStart = parseContent.webFormat.parse(promo.getPromoStartDate());
                Date webEnd = parseContent.webFormat.parse(promo.getPromoExpireDate());
                if (webStart != null && webEnd != null) {
                    holder.tvPromoDate.setText(context.getResources().getString(R.string.text_promo_date, parseContent.dateFormat3.format(webStart), parseContent.dateFormat3.format(webEnd)));
                }
                holder.tvPromoDate.setVisibility(View.VISIBLE);
                holder.btnTC.setVisibility(View.VISIBLE);
                holder.div.setVisibility(View.VISIBLE);
            } catch (ParseException e) {
                e.printStackTrace();
                holder.tvPromoDate.setVisibility(View.GONE);
            }
        } else {
            holder.tvPromoDate.setVisibility(View.GONE);
        }

        if (promo.isPromoHaveDate() && !TextUtils.isEmpty(promo.getPromoStartTime()) && !TextUtils.isEmpty(promo.getPromoEndTime())) {
            try {
                String[] startTime = promo.getPromoStartTime().split(":");
                String[] endTime = promo.getPromoEndTime().split(":");
                Calendar calendarStart = Calendar.getInstance();
                calendarStart.set(Calendar.HOUR_OF_DAY, Integer.parseInt(startTime[0]));
                calendarStart.set(Calendar.MINUTE, Integer.parseInt(startTime[1]));
                calendarStart.set(Calendar.SECOND, 0);
                calendarStart.set(Calendar.MILLISECOND, 0);

                Calendar calendarEnd = Calendar.getInstance();
                calendarEnd.set(Calendar.HOUR_OF_DAY, Integer.parseInt(endTime[0]));
                calendarEnd.set(Calendar.MINUTE, Integer.parseInt(endTime[1]));
                calendarEnd.set(Calendar.SECOND, 0);
                calendarEnd.set(Calendar.MILLISECOND, 0);
                holder.tvPromoTime.setText(context.getResources().getString(R.string.text_promo_time, parseContent.timeFormat_am.format(calendarStart.getTime()), parseContent.timeFormat_am.format(calendarEnd.getTime())));
                holder.tvPromoTime.setVisibility(View.VISIBLE);
                holder.btnTC.setVisibility(View.VISIBLE);
                holder.div.setVisibility(View.VISIBLE);
            } catch (NumberFormatException e) {
                AppLog.handleException(Const.Tag.CHECKOUT_ACTIVITY, e);
                holder.tvPromoTime.setVisibility(View.GONE);
            }
        } else {
            holder.tvPromoTime.setVisibility(View.GONE);
        }

        if (promo.getWeeks() != null && !promo.getWeeks().isEmpty()) {
            StringBuilder weeks = new StringBuilder();
            int size = promo.getWeeks().size();
            for (int i = 0; i < size; i++) {
                if (i == size - 1) {
                    weeks.append(promo.getWeeks().get(i));
                } else {
                    weeks.append(promo.getWeeks().get(i)).append(", ");
                }
            }
            holder.tvPromoWeek.setText(context.getResources().getString(R.string.text_promo_week, weeks.toString()));
            holder.tvPromoWeek.setVisibility(View.VISIBLE);
            holder.btnTC.setVisibility(View.VISIBLE);
            holder.div.setVisibility(View.VISIBLE);
        } else {
            holder.tvPromoWeek.setVisibility(View.GONE);
        }
        if (promo.getMonths() != null && !promo.getMonths().isEmpty()) {
            StringBuilder months = new StringBuilder();
            int size = promo.getMonths().size();
            for (int i = 0; i < size; i++) {
                if (i == size - 1) {
                    months.append(promo.getMonths().get(i));
                } else {
                    months.append(promo.getMonths().get(i)).append(", ");
                }
            }
            holder.tvPromoMonth.setText(context.getResources().getString(R.string.text_promo_month, months.toString()));
            holder.tvPromoMonth.setVisibility(View.VISIBLE);
            holder.btnTC.setVisibility(View.VISIBLE);
            holder.div.setVisibility(View.VISIBLE);
        } else {
            holder.tvPromoMonth.setVisibility(View.GONE);
        }
        if (promo.getDays() != null && !promo.getDays().isEmpty()) {
            StringBuilder days = new StringBuilder();
            int size = promo.getDays().size();
            for (int i = 0; i < size; i++) {
                if (i == size - 1) {
                    days.append(promo.getDays().get(i));
                } else {
                    days.append(promo.getDays().get(i)).append(", ");
                }
            }
            holder.tvPromoDay.setText(context.getResources().getString(R.string.text_promo_day, days.toString()));
            holder.tvPromoDay.setVisibility(View.VISIBLE);
            holder.btnTC.setVisibility(View.VISIBLE);
            holder.div.setVisibility(View.VISIBLE);
        } else {
            holder.tvPromoDay.setVisibility(View.GONE);
        }
    }


    @Override
    public int getItemCount() {
        return promoCodes.size();
    }

    public abstract void promoApply(PromoCodes promoCodes);

    public static class CategoryViewHolder extends RecyclerView.ViewHolder {
        ImageView ivPromo;
        TextView tvPromoCode, tvPromoCodeDetail, btnApplyPromo, tvCompleteOrder, tvFirstUser, tvMinOrderPrice, tvUpToDiscount, tvMinItem, btnTC, tvPromoDate, tvPromoTime, tvPromoDay, tvPromoWeek, tvPromoMonth;
        View div;

        public CategoryViewHolder(@NonNull View itemView) {
            super(itemView);
            ivPromo = itemView.findViewById(R.id.ivPromo);
            tvPromoCode = itemView.findViewById(R.id.tvPromoCode);
            tvPromoCodeDetail = itemView.findViewById(R.id.tvPromoCodeDetail);
            btnApplyPromo = itemView.findViewById(R.id.btnApplyPromo);
            tvCompleteOrder = itemView.findViewById(R.id.tvCompleteOrder);
            tvFirstUser = itemView.findViewById(R.id.tvFirstUser);
            tvMinOrderPrice = itemView.findViewById(R.id.tvMinOrderPrice);
            tvUpToDiscount = itemView.findViewById(R.id.tvUpToDiscount);
            tvMinItem = itemView.findViewById(R.id.tvMinItem);
            tvPromoDate = itemView.findViewById(R.id.tvPromoDate);
            tvPromoDate.setVisibility(View.GONE);
            tvPromoTime = itemView.findViewById(R.id.tvPromoTime);
            tvPromoTime.setVisibility(View.GONE);
            tvPromoDay = itemView.findViewById(R.id.tvPromoDay);
            tvPromoDay.setVisibility(View.GONE);
            tvPromoWeek = itemView.findViewById(R.id.tvPromoWeek);
            tvPromoWeek.setVisibility(View.GONE);
            tvPromoMonth = itemView.findViewById(R.id.tvPromoMonth);
            tvPromoMonth.setVisibility(View.GONE);
            div = itemView.findViewById(R.id.div);
            btnTC = itemView.findViewById(R.id.btnTC);
        }
    }
}