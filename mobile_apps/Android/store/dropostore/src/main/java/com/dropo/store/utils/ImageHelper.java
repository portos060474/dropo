package com.dropo.store.utils;

import static com.dropo.store.utils.ServerConfig.BASE_URL;
import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.content.ContentResolver;
import android.content.Context;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import android.os.ParcelFileDescriptor;
import android.text.TextUtils;
import android.widget.ImageView;

import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;
import androidx.core.content.res.ResourcesCompat;

import com.bumptech.glide.request.target.DrawableImageViewTarget;

import com.dropo.store.BuildConfig;
import com.dropo.store.R;
import com.dropo.store.parse.ParseContent;


import java.io.Closeable;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.Locale;

public class ImageHelper {

    public final String TAG = this.getClass().getSimpleName();
    private final ParseContent parseContent;
    private final Context context;

    public ImageHelper(Context context) {
        parseContent = ParseContent.getInstance();
        this.context = context;
    }

    @Nullable
    public static File getFromMediaUriPfd(Context context, ContentResolver resolver, Uri uri) {
        if (uri == null) return null;

        FileInputStream input = null;
        FileOutputStream output = null;
        ParcelFileDescriptor pfd = null;
        try {
            pfd = resolver.openFileDescriptor(uri, "r");
            FileDescriptor fd = pfd.getFileDescriptor();
            input = new FileInputStream(fd);

            String tempFilename = getTempFilename(context);
            output = new FileOutputStream(tempFilename);

            int read;
            byte[] bytes = new byte[4096];
            while ((read = input.read(bytes)) != -1) {
                output.write(bytes, 0, read);
            }
            return new File(tempFilename);
        } catch (IOException ignored) {
            // Nothing we can do
        } finally {
            closeSilently(input);
            closeSilently(output);
            closeSilently(pfd);
        }
        return null;
    }

    private static String getTempFilename(Context context) throws IOException {
        File outputDir = context.getCacheDir();
        File outputFile = File.createTempFile("image", "tmp", outputDir);
        return outputFile.getAbsolutePath();
    }

    private static void closeSilently(@Nullable Closeable c) {
        if (c == null) return;
        try {
            c.close();
        } catch (Throwable t) {
            // Do nothing
        }
    }

    public File getAlbumDir(Context context) {
        return context.getExternalFilesDir("");
    }

    public File createImageFile() {
        // Create an placeholder file name
        Date date = new Date();
        String timeStamp = parseContent.dateFormat.format(date);
        timeStamp = timeStamp + "_" + parseContent.timeFormat.format(date);
        String imageFileName = "IMG_" + timeStamp + ".jpg";
        File albumF = getAlbumDir(context);
        return new File(albumF, imageFileName);
    }

    public Uri createTakePictureUri() {
        File file = createImageFile();
        Uri uri;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            uri = FileProvider.getUriForFile(context, BuildConfig.APPLICATION_ID + ".provider", file);
        } else {
            uri = Uri.fromFile(file);
        }
        return uri;
    }

    /**
     * Gets image url according size.
     *
     * @param url the url
     * @return the image url according size
     */
    public String getImageUrlAccordingSize(String url, ImageView imageView) {
        // image format
        if (TextUtils.isEmpty(url)) {
            return BASE_URL + url;
        } else {
            return BASE_URL + String.format(Locale.US, "resize_image?width=%d&height=%d&format" + "=webp" + "&image=%s", imageView.getLayoutParams().width, imageView.getLayoutParams().height, ServerConfig.IMAGE_URL + url);
        }
    }

    private static class IncomingHandler extends Handler {
        /**
         * The Context.
         */
        Context context;

        /**
         * Instantiates a new Incoming handler.
         *
         * @param context the context
         */
        public IncomingHandler(Context context) {
            this.context = context;
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            DrawableImageViewTarget image = (DrawableImageViewTarget) msg.obj;
            GlideApp.with(context)
                    .load(IMAGE_URL + image.getView().getTag(R.drawable.placeholder))
                    .dontAnimate()
                    .placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .into(image);
        }
    }
}
