package com.corising.weddingalbum;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import android.text.method.LinkMovementMethod;
import android.util.Log;
import android.widget.TextView;

import com.actionbarsherlock.app.SherlockActivity;
import com.actionbarsherlock.view.MenuItem;

public class HelpActivity extends SherlockActivity
{

	private static final String	TAG	= HelpActivity.class.getName();

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_help);
		getSupportActionBar().setDisplayHomeAsUpEnabled(true);
		getSupportActionBar().setTitle(R.string.title_activity_help);

		TextView whatDetails = (TextView) findViewById(R.id.help_congratulations_details);
		whatDetails.setText(String.format(getString(R.string.help_categoty_congratulations_details),
				getString(R.string.couple_name_girl), getString(R.string.couple_name_boy)));
		TextView appVersionDesc = (TextView) findViewById(R.id.about_appVersion);
		PackageManager pm = getPackageManager();
		PackageInfo info;
		try
		{
			info = pm.getPackageInfo(getPackageName(), PackageManager.GET_META_DATA);
			appVersionDesc.setText(String.format(getString(R.string.about_appVersion), info.versionName));
		}
		catch (NameNotFoundException e)
		{
			Log.e(TAG, e.getMessage(), e);
			appVersionDesc.setText(String.format(getString(R.string.about_appVersion), "unknown"));
		}

		((TextView) findViewById(R.id.about_thanks)).setMovementMethod(LinkMovementMethod.getInstance());
		((TextView) findViewById(R.id.about_copyright_ch)).setMovementMethod(LinkMovementMethod.getInstance());
		((TextView) findViewById(R.id.about_copyright_en)).setMovementMethod(LinkMovementMethod.getInstance());
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
		switch (item.getItemId())
		{
		case android.R.id.home:
			onBackPressed();
			return true;
		default:
			return false;
		}

	}

	public void onResume()
	{
		super.onResume();
	}

	public void onPause()
	{
		super.onPause();
	}

}
