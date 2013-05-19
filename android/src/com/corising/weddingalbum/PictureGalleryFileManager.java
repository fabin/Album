package com.corising.weddingalbum;

import java.io.File;

import com.novoda.imageloader.core.LoaderSettings;
import com.novoda.imageloader.core.file.BasicFileManager;

public class PictureGalleryFileManager extends BasicFileManager
{

	public PictureGalleryFileManager(LoaderSettings settings)
	{
		super(settings);
	}

	@Override
	public File getFile(String url)
	{
		url = processUrl(url);
		int index = url.lastIndexOf('/');
		String filename = url.substring(index + 1);
		return new File(loaderSettings.getCacheDir(), filename);
	}

}
