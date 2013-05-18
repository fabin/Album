package com.corising.weddingalbum;

import java.util.ArrayList;
import java.util.HashMap;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;

public class PictureFragmentManager implements PictureFragmentChangeSupport
{
	private static final String					KEY_FRAGMENTS		= PictureFragmentManager.class.getName();
	private static final String					KEY_LAST_FRAGMENT	= PictureFragmentManager.class.getName()
																			+ ":lastFramgent";
	private final FragmentActivity				mActivity;
	private final int							mContainerId;
	private final HashMap<String, FragmentInfo>	fragments			= new HashMap<String, FragmentInfo>();
	private FragmentInfo						mLastFragment;

	public static final class FragmentInfo implements Parcelable
	{
		private static final String	TAG	= FragmentInfo.class.getName();
		private final String		tag;
		private Class<?>			clazz;
		private final Bundle		args;
		private Fragment			fragment;

		FragmentInfo(String tag, Class<?> clazz, Bundle args)
		{
			this.tag = tag;
			this.clazz = clazz;
			this.args = args;
		}

		public FragmentInfo(Parcel in)
		{
			this.tag = in.readString();
			try
			{
				this.clazz = Class.forName(in.readString());
			}
			catch (ClassNotFoundException e)
			{
				Log.e(TAG, e.getMessage(), e);
			}
			this.args = in.readBundle();
		}

		public String getTag()
		{
			return tag;
		}

		public Class<?> getClazz()
		{
			return clazz;
		}

		public Bundle getArgs()
		{
			return args;
		}

		@Override
		public int describeContents()
		{
			return 0;
		}

		@Override
		public void writeToParcel(Parcel dest, int flags)
		{
			dest.writeString(tag);
			dest.writeString(clazz.getName());
			dest.writeBundle(args);
		}

		public static final Parcelable.Creator<FragmentInfo>	CREATOR	= new Parcelable.Creator<FragmentInfo>()
																		{
																			@Override
																			public FragmentInfo createFromParcel(
																					Parcel in)
																			{
																				return new FragmentInfo(in);
																			}

																			@Override
																			public FragmentInfo[] newArray(int size)
																			{
																				return new FragmentInfo[size];
																			}

																		};
	}

	public PictureFragmentManager(FragmentActivity activity, int containerId)
	{
		mActivity = activity;
		mContainerId = containerId;
	}

	public String getLastTag()
	{
		return mLastFragment == null ? null : mLastFragment.getTag();
	}

	@Override
	public void addPictureFragment(String tag, Class<?> clss, Bundle args)
	{
		if (fragments.containsKey(tag))
		{
			return;
		}
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

	public void onSaveInstanceState(Bundle outState)
	{
		ArrayList<FragmentInfo> fragmentInfos = new ArrayList<PictureFragmentManager.FragmentInfo>(fragments.values());
		outState.putParcelableArrayList(KEY_FRAGMENTS, fragmentInfos);
		outState.putParcelable(KEY_LAST_FRAGMENT, mLastFragment);
	}

	public void onCreate(Bundle savedInstanceState)
	{
		if (savedInstanceState != null)
		{
			ArrayList<FragmentInfo> framgentInfos = savedInstanceState.getParcelableArrayList(KEY_FRAGMENTS);
			for (FragmentInfo fragmentInfo : framgentInfos)
			{
				addPictureFragment(fragmentInfo.getTag(), fragmentInfo.getClazz(), fragmentInfo.getArgs());
			}

			mLastFragment = savedInstanceState.getParcelable(KEY_LAST_FRAGMENT);
		}

	}

}
