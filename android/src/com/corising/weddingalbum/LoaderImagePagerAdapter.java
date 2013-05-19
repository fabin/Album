package com.corising.weddingalbum;

import java.util.List;

import ru.truba.touchgallery.GalleryWidget.BasePagerAdapter;
import ru.truba.touchgallery.GalleryWidget.GalleryViewPager;
import ru.truba.touchgallery.TouchView.TouchImageView;
import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.novoda.imageloader.core.ImageManager;
import com.novoda.imageloader.core.OnImageLoadedListener;
import com.novoda.imageloader.core.cache.CacheManager;
import com.novoda.imageloader.core.model.ImageTag;
import com.novoda.imageloader.core.model.ImageTagFactory;

public class LoaderImagePagerAdapter extends BasePagerAdapter implements OnImageLoadedListener
{

	private static final String	TAG	= LoaderImagePagerAdapter.class.getName();
	private ImageManager		imageManager;
	private ImageTagFactory		imageTagFactory;

	public LoaderImagePagerAdapter(Context context, List<String> images)
	{
		super(context, images);
		imageManager = AlbumApplication.getImageLoader();
		imageManager.setOnImageLoadedListener(this);
		imageTagFactory = ImageTagFactory.newInstance(1600, 1600, R.drawable.ic_launcher);
	}

	@Override
	public void setPrimaryItem(ViewGroup container, int position, Object object)
	{
		super.setPrimaryItem(container, position, object);
		((GalleryViewPager) container).mCurrentView = (TouchImageView) object;
	}

	@Override
	public Object instantiateItem(ViewGroup collection, int position)
	{
		Log.i(TAG, "instantiateItem(...) position = " + position);
		final TouchImageView iv = new TouchImageView(mContext);
		iv.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
				ViewGroup.LayoutParams.MATCH_PARENT));
		iv.setTag(imageTagFactory.build(mResources.get(position), mContext));
		iv.setMaxScale(4f);
		imageManager.getLoader().load(iv);
		collection.addView(iv, 0);
		return iv;
	}

	@Override
	public void destroyItem(ViewGroup collection, int position, Object view)
	{
		Log.i(TAG, "destroyItem(...) position = " + position);
		TouchImageView iv = (TouchImageView) view;
		ImageTag tag = (ImageTag) iv.getTag();

		CacheManager cacheManager = imageManager.getCacheManager();
		String url = tag.getUrl();
		Bitmap bitmap = cacheManager.get(url, tag.getWidth(), tag.getHeight());
		if (bitmap != null)
		{
			bitmap.recycle();
			Log.i(TAG, "bitmap.recycle()ed!");
		}
		cacheManager.clean(url);

		super.destroyItem(collection, position, view);
		
		view = null;
	}

	@Override
	public void onImageLoaded(ImageView imageView)
	{
		ImageTag tag = (ImageTag) imageView.getTag();
		String url = tag.getUrl();
		Log.i(TAG, "downloaded: " + url);
	}

}
