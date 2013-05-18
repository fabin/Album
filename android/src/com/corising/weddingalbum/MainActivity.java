package com.corising.weddingalbum;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.app.ListFragment;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.view.MenuItem;
import com.slidingmenu.lib.SlidingMenu;
import com.slidingmenu.lib.SlidingMenu.CanvasTransformer;
import com.slidingmenu.lib.app.SlidingFragmentActivity;

public class MainActivity extends SlidingFragmentActivity implements PictureFragmentChangeSupport
{
	private int						mTitleRes;
	private CanvasTransformer		mTransformer;
	protected ListFragment			mFrag;
	private PictureFragmentManager	pictureFragmentManager;

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
		if (savedInstanceState == null)
		{
			FragmentTransaction t = this.getSupportFragmentManager().beginTransaction();
			mFrag = new SampleListFragment();
			t.replace(R.id.menu_frame, mFrag);
			t.commit();

		}
		else
		{
			mFrag = (ListFragment) this.getSupportFragmentManager().findFragmentById(R.id.menu_frame);
		}

		// customize the SlidingMenu
		SlidingMenu sm = getSlidingMenu();
		sm.setShadowWidthRes(R.dimen.shadow_width);
		sm.setShadowDrawable(R.drawable.shadow);
		sm.setBehindOffsetRes(R.dimen.slidingmenu_offset);
		sm.setFadeDegree(0.35f);
		sm.setTouchModeAbove(SlidingMenu.TOUCHMODE_FULLSCREEN);

		getSupportActionBar().setDisplayHomeAsUpEnabled(true);

		// set the Above View
		setContentView(R.layout.content_frame);
		Fragment contentFragment = null;
		if (savedInstanceState == null)
		{
			contentFragment = new WelcomeFragment();
		}
		else
		{
			contentFragment = this.getSupportFragmentManager().findFragmentById(R.id.content_frame);
		}
		getSupportFragmentManager().beginTransaction().replace(R.id.content_frame, contentFragment).commit();

		setSlidingActionBarEnabled(true);
		sm.setBehindScrollScale(0.0f);
		sm.setBehindCanvasTransformer(mTransformer);

		int containerId = R.id.content_frame;
		pictureFragmentManager = new PictureFragmentManager(this, containerId);
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
		pictureFragmentManager.addPictureFragment(tag, clss, args);
	}

	@Override
	public void onPictureFragmentChanged(String tag)
	{
		pictureFragmentManager.onPictureFragmentChanged(tag);
		getSlidingMenu().showContent();
	}

}
