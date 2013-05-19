package com.corising.weddingalbum;

import java.util.Set;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.app.ListFragment;
import android.util.Log;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.view.MenuItem;
import com.slidingmenu.lib.SlidingMenu;
import com.slidingmenu.lib.SlidingMenu.CanvasTransformer;
import com.slidingmenu.lib.app.SlidingFragmentActivity;

public class MainActivity extends SlidingFragmentActivity implements AlbumFragmentChangeSupport
{
	private static final String		TAG	= MainActivity.class.getName();
	private int						mTitleRes;
	private CanvasTransformer		mTransformer;
	protected ListFragment			mFrag;
	private AlbumsFragmentManager	albumsFragmentManager;

	public MainActivity()
	{
		this(R.string.anim_scale);
		// this(R.string.anim_scale, new CanvasTransformer()
		// {
		// @Override
		// public void transformCanvas(Canvas canvas, float percentOpen)
		// {
		// float scale = (float) (percentOpen * 0.25 + 0.75);
		// canvas.scale(scale, scale, canvas.getWidth() / 2, canvas.getHeight() / 2);
		// }
		// });
	}

	public MainActivity(int titleRes)
	{
		mTitleRes = titleRes;
	}

	public MainActivity(int titleRes, CanvasTransformer transformer)
	{
		this(titleRes);
		mTransformer = transformer;
	}

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		setTitle(mTitleRes);

		// set the Behind View
		setBehindContentView(R.layout.menu_frame);
		FragmentTransaction t = this.getSupportFragmentManager().beginTransaction();
		Log.i(TAG, "savedInstanceState == null ? " + savedInstanceState);
		if (savedInstanceState == null)
		{
			mFrag = new MenuFragment();
			t.replace(R.id.menu_frame, mFrag);
			t.commit();
		}
		else
		{
			logBundle(savedInstanceState, "\t");
			mFrag = (ListFragment) this.getSupportFragmentManager().findFragmentById(R.id.menu_frame);
			Log.i(TAG, "mFrag = " + mFrag);
		}

		// customize the SlidingMenu
		SlidingMenu sm = getSlidingMenu();
		sm.setShadowWidthRes(R.dimen.shadow_width);
		sm.setShadowDrawable(R.drawable.shadow);
		sm.setBehindOffsetRes(R.dimen.slidingmenu_offset);
		sm.setFadeDegree(0.35f);
		sm.setTouchModeAbove(SlidingMenu.TOUCHMODE_FULLSCREEN);

		getSupportActionBar().setDisplayHomeAsUpEnabled(true);
		setSlidingActionBarEnabled(true);
		sm.setBehindScrollScale(0.0f);
		sm.setBehindCanvasTransformer(mTransformer);

		// set the Above View
		setContentView(R.layout.content_frame);
		int containerId = R.id.content_frame;
		albumsFragmentManager = new AlbumsFragmentManager(this, containerId);
		albumsFragmentManager.onCreate(savedInstanceState);
		String fragemtTag = null;
		if (savedInstanceState == null)
		{
			fragemtTag = WelcomeFragment.class.getName();
			albumsFragmentManager.addPictureFragment(fragemtTag, WelcomeFragment.class, null);
		}
		else
		{
			fragemtTag = albumsFragmentManager.getLastTag();
		}
		albumsFragmentManager.onPictureFragmentChanged(fragemtTag);

	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
		switch (item.getItemId())
		{
		case android.R.id.home:
			toggle();
			return true;
		}
		return super.onOptionsItemSelected(item);
	}

	@Override
	public void addPictureFragment(String tag, Class<?> clss, Bundle args)
	{
		albumsFragmentManager.addPictureFragment(tag, clss, args);
	}

	@Override
	public void onPictureFragmentChanged(String tag)
	{
		albumsFragmentManager.onPictureFragmentChanged(tag);
		getSlidingMenu().showContent();
	}

	@Override
	protected void onSaveInstanceState(Bundle outState)
	{
		super.onSaveInstanceState(outState);
		Log.i(TAG, "onSaveInstanceState(...)");
		outState.putString("lastFragmentTag", albumsFragmentManager.getLastTag());
		albumsFragmentManager.onSaveInstanceState(outState);
	}

	private void logBundle(Bundle bundle, String pre)
	{
		Set<String> keys = bundle.keySet();
		for (String key : keys)
		{
			Object value = bundle.get(key);
			if (value instanceof Bundle)
			{
				Log.i(TAG, "\t" + key + ":");
				if (value instanceof Bundle)
				{
					Bundle newBundle = (Bundle) value;
					logBundle(newBundle, pre + key + ":");
				}
			}
			else
			{
				Log.i(TAG, pre + key + " = " + value);
			}
		}
	}
}
