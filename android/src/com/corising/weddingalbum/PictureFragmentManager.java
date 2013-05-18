package com.corising.weddingalbum;

import java.util.HashMap;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;

public class PictureFragmentManager implements PictureFragmentChangeSupport
{
	private final FragmentActivity				mActivity;
	private final int							mContainerId;
	private final HashMap<String, FragmentInfo>	fragments	= new HashMap<String, FragmentInfo>();
	FragmentInfo								mLastFragment;

	static final class FragmentInfo
	{
		private final String	tag;
		private final Class<?>	clazz;
		private final Bundle	args;
		private Fragment		fragment;

		FragmentInfo(String tag, Class<?> clazz, Bundle args)
		{
			this.tag = tag;
			this.clazz = clazz;
			this.args = args;
		}
	}

	public PictureFragmentManager(FragmentActivity activity, int containerId)
	{
		mActivity = activity;
		mContainerId = containerId;
	}

	@Override
	public void addPictureFragment(String tag, Class<?> clss, Bundle args)
	{
		FragmentInfo info = new FragmentInfo(tag, clss, args);

		// Check to see if we already have a fragment for this tab, probably
		// from a previously saved state. If so, deactivate it, because our
		// initial state is that a tab isn't shown.
		info.fragment = mActivity.getSupportFragmentManager().findFragmentByTag(tag);
		if (info.fragment != null && !info.fragment.isDetached())
		{
			FragmentTransaction ft = mActivity.getSupportFragmentManager().beginTransaction();
			ft.detach(info.fragment);
			ft.commit();
		}

		fragments.put(tag, info);
	}

	@Override
	public void onPictureFragmentChanged(String tag)
	{
		FragmentInfo newFragment = fragments.get(tag);
		if (mLastFragment != newFragment)
		{
			FragmentTransaction ft = mActivity.getSupportFragmentManager().beginTransaction();
			if (mLastFragment != null)
			{
				if (mLastFragment.fragment != null)
				{
					ft.detach(mLastFragment.fragment);
				}
			}
			if (newFragment != null)
			{
				if (newFragment.fragment == null)
				{
					newFragment.fragment = Fragment.instantiate(mActivity, newFragment.clazz.getName(),
							newFragment.args);
					ft.add(mContainerId, newFragment.fragment, newFragment.tag);
				}
				else
				{
					ft.attach(newFragment.fragment);
				}
			}

			mLastFragment = newFragment;
			ft.commit();
			mActivity.getSupportFragmentManager().executePendingTransactions();
		}
	}

}
