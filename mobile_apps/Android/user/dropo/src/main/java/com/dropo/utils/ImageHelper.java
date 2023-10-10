package com.dropo.utils;

import android.content.ContentResolver;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.os.ParcelFileDescriptor;
import android.text.TextUtils;
import android.widget.ImageView;

import androidx.annotation.Nullable;
import androidx.core.content.res.ResourcesCompat;

import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.DrawableImageViewTarget;
import com.bumptech.glide.request.target.Target;
import com.dropo.user.R;
import com.dropo.parser.ParseContent;

import java.io.Closeable;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.Locale;

public class ImageHelper {

    public static final double ASPECT_RATIO = 1.25;
    public static final int CHOOSE_PHOTO_FROM_GALLERY = 1;
    public static final int TAKE_PHOTO_FROM_CAMERA = 2;
    private final Context context;
    private final ParseContent parseContent;
    private final IncomingHandler incomingHandler;
    private final RequestListener<Drawable> requestListener;

    /**
     * Instantiates a new Image helper.
     *
     * @param context the context
     */
    public ImageHelper(Context context) {
        parseContent = ParseContent.getInstance();
        incomingHandler = new IncomingHandler(context);
        this.context = context;
        requestListener = new RequestListener<Drawable>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                Message message = new Message();
                message.obj = target;
                incomingHandler.sendMessage(message);
                return true;
            }

            @Override
            public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                return false;
            }
        };
    }

    /**
     * Gets from media uri pfd.
     *
     * @param context  the context
     * @param resolver the resolver
     * @param uri      the uri
     * @return the from media uri pfd
     */
    @Nullable
    public static File getFromMediaUriPfd(Context context, ContentResolver resolver, Uri uri) {
        if (uri == null) {
            return null;
        }

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
        if (c == null) {
            return;
        }
        try {
            c.close();
        } catch (Throwable t) {
            // Do nothing
        }
    }

    /**
     * Gets album dir.
     *
     * @param context the context
     * @return the album dir
     */
    public File getAlbumDir(Context context) {
        File storageDir = null;

        if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())) {
            storageDir = context.getExternalFilesDir(Environment.DIRECTORY_PICTURES);

            if (!storageDir.mkdirs() && !storageDir.exists()) {
                return null;
            }

        }
        return storageDir;
    }

    /**
     * Create image file file.
     *
     * @return the file
     */
    public File createImageFile() {
        // Create an placeholder file name
        Date date = new Date();
        String timeStamp = parseContent.dateFormat.format(date);
        timeStamp = timeStamp + "_" + parseContent.timeFormat.format(date);
        String imageFileName = "IMG_" + timeStamp + ".jpg";
        File albumF = getAlbumDir(context);
        return new File(albumF, imageFileName);
    }

    /**
     * Register glide load filed listener request listener.
     *
     * @param imageView the image view
     * @param url       the url
     * @return the request listener
     */
    public RequestListener<Drawable> registerGlideLoadFiledListener(ImageView imageView, String url) {
        imageView.setTag(R.drawable.placeholder, url);
        return requestListener;
    }

    public String getImageUrlAccordingSize(String url, ImageView imageView) {
        // image format
        if (TextUtils.isEmpty(url)) {
            return ServerConfig.BASE_URL + url;
        } else {
            return ServerConfig.BASE_URL + String.format(Locale.US, "resize_image?width=%d&height=%d&format=webp&image=%s", imageView.getLayoutParams().width, imageView.getLayoutParams().height, TextUtils.equals(ServerConfig.IMAGE_URL, ServerConfig.BASE_URL) ? "" : ServerConfig.IMAGE_URL + url);
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
            GlideApp.with(context).load(ServerConfig.IMAGE_URL + image.getView().getTag(R.drawable.placeholder)).dontAnimate().placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null)).into(image);
        }
    }
}