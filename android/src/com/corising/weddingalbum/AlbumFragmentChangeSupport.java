package com.corising.weddingalbum;

import android.os.Bundle;

public interface AlbumFragmentChangeSupport
{
	public void addPictureFragment(String tag, Class<?> clss, Bundle args);
	public void onPictureFragmentChanged(String tag);
}
