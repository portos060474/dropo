package com.dropo.adapter;

import static com.dropo.utils.ServerConfig.IMAGE_URL;


import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.models.datamodels.Documents;
import com.dropo.parser.ParseContent;
import com.dropo.utils.AppLog;
import com.dropo.utils.GlideApp;

import java.text.ParseException;
import java.util.List;

public class DocumentAdapter extends RecyclerView.Adapter<DocumentAdapter.DocumentViewHolder> {

    private final List<Documents> documentsList;
    private final ParseContent parseContent;
    private Context context;

    public DocumentAdapter(List<Documents> documentsList) {
        this.documentsList = documentsList;
        parseContent = ParseContent.getInstance();
    }

    @NonNull
    @Override
    public DocumentViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_document, parent, false);
        return new DocumentViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull DocumentViewHolder holder, int position) {
        Documents documents = documentsList.get(position);
        if (documents.getDocumentDetails().isIsUniqueCode()) {
            holder.tvIdNumber.setVisibility(View.VISIBLE);
            String id = context.getResources().getString(R.string.text_id_number);
            if (!TextUtils.isEmpty(documents.getUniqueCode())) {
                id = id + " " + documents.getUniqueCode();
                holder.tvIdNumber.setText(id);
            } else {
                holder.tvIdNumber.setText(id);
            }
        } else {
            holder.tvIdNumber.setVisibility(View.GONE);
        }
        if (documents.getDocumentDetails().isIsExpiredDate()) {
            String date = context.getResources().getString(R.string.text_expire_date);
            holder.tvExpireDate.setVisibility(View.VISIBLE);
            try {
                if (!TextUtils.isEmpty(documents.getExpiredDate())) {
                    date = date + " " + parseContent.dateFormat.format(parseContent.webFormat.parse(documents.getExpiredDate()));
                    holder.tvExpireDate.setText(date);
                } else {
                    holder.tvExpireDate.setText(date);
                }
            } catch (ParseException e) {
                AppLog.handleException(DocumentAdapter.class.getName(), e);
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
                .placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.uploading, null))
                .fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.uploading, null))
                .into(holder.ivDocumentImage);
    }

    @Override
    public int getItemCount() {
        return documentsList.size();
    }

    protected static class DocumentViewHolder extends RecyclerView.ViewHolder {
        CustomFontTextView tvDocumentTittle, tvIdNumber, tvExpireDate, tvOption;
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