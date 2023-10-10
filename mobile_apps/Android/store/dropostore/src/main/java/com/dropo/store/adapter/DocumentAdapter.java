package com.dropo.store.adapter;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.os.Build;
import android.text.Html;
import android.text.Spanned;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.Documents;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;


import java.text.ParseException;
import java.util.List;

public class DocumentAdapter extends RecyclerView.Adapter<DocumentAdapter.DocumentViewHolder> {

    private final String TAG = this.getClass().getSimpleName();
    private final List<Documents> documentsList;
    private final ParseContent parseContent;
    private Context context;
    private String colorLabel, colorText;

    public DocumentAdapter(List<Documents> documentsList) {
        this.documentsList = documentsList;
        parseContent = ParseContent.getInstance();

    }

    @SuppressWarnings("deprecation")
    public static Spanned fromHtml(String source) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            return Html.fromHtml(source, Html.FROM_HTML_MODE_LEGACY);
        } else {
            return Html.fromHtml(source);
        }
    }

    @NonNull
    @Override
    public DocumentViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_document, parent, false);
        colorLabel = "#" + Integer.toHexString(ResourcesCompat.getColor(context.getResources(), R.color.color_app_label_light, null) & 0x00ffffff);
        colorText = "#" + Integer.toHexString(AppColor.getThemeTextColor(context) & 0x00ffffff);
        return new DocumentViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull DocumentViewHolder holder, int position) {
        Documents documents = documentsList.get(position);
        if (documents.getDocumentDetails().isIsUniqueCode()) {
            holder.tvIdNumber.setVisibility(View.VISIBLE);
            if (!TextUtils.isEmpty(documents.getUniqueCode())) {
                holder.tvIdNumber.setText(fromHtml(getColoredSpanned(context.getResources().getString(R.string.text_id_number), documents.getUniqueCode())));
            } else {
                holder.tvIdNumber.setText(fromHtml(getColoredSpanned(context.getResources().getString(R.string.text_id_number), "")));
            }
        } else {
            holder.tvIdNumber.setVisibility(View.GONE);
        }

        if (documents.getDocumentDetails().isIsExpiredDate()) {
            holder.tvExpireDate.setVisibility(View.VISIBLE);
            try {
                if (!TextUtils.isEmpty(documents.getExpiredDate())) {
                    holder.tvExpireDate.setText(fromHtml(getColoredSpanned(context.getResources().getString(R.string.text_expire_date), parseContent.dateFormat.format(parseContent.webFormat.parse(documents.getExpiredDate())))));
                } else {
                    holder.tvExpireDate.setText(fromHtml(getColoredSpanned(context.getResources().getString(R.string.text_expire_date), "")));
                }
            } catch (ParseException e) {
                Utilities.handleThrowable(TAG, e);
            }

        } else {
            holder.tvExpireDate.setVisibility(View.GONE);
        }

        if (documents.getDocumentDetails().isIsMandatory()) {
            holder.tvOption.setVisibility(View.VISIBLE);
        } else {
            holder.tvOption.setVisibility(View.GONE);
        }

        holder.tvDocumentTittle.setText(documents.getDocumentDetails().getDocumentName());
        GlideApp.with(context)
                .load(IMAGE_URL + documents.getImageUrl())
                .dontAnimate()
                .placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.uploading, null))
                .fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.uploading, null))
                .into(holder.ivDocumentImage);
    }

    @Override
    public int getItemCount() {
        return documentsList.size();
    }

    private String getColoredSpanned(String text1, String text2) {
        return "<font color=" + colorLabel + ">" + text1 + " " + "</font>" + "<font " + "color=" + colorText + ">" + text2 + "</font>";
    }

    protected static class DocumentViewHolder extends RecyclerView.ViewHolder {
        CustomTextView tvDocumentTittle, tvIdNumber, tvExpireDate, tvOption;
        ImageView ivDocumentImage;

        public DocumentViewHolder(View itemView) {
            super(itemView);
            tvOption = itemView.findViewById(R.id.tvOption);
            tvDocumentTittle = itemView.findViewById(R.id.tvDocumentTittle);
            tvIdNumber = itemView.findViewById(R.id.tvIdNumber);
            tvExpireDate = itemView.findViewById(R.id.tvExpireDate);
            ivDocumentImage = itemView.findViewById(R.id.ivDocumentImage);
        }
    }
}