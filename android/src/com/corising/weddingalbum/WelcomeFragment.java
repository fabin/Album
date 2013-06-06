package com.corising.weddingalbum;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.app.SherlockFragmentActivity;
import com.corising.weddingalbum.dao.HttpResonseDAO;
import com.corising.weddingalbum.dao.HttpResponseFactory;
import com.novoda.imageloader.core.ImageManager;
import com.novoda.imageloader.core.model.ImageTagFactory;

public class WelcomeFragment extends SherlockFragment
{
	private static final String	TAG	= WelcomeFragment.class.getName();
	private Activity			activity;
	private ImageView			welcomeImage;
	private ImageManager		imageManager;
	private ImageTagFactory		imageTagFactory;
	private int					welcomeImageWidth;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		Display display = activity.getWindowManager().getDefaultDisplay();
		@SuppressWarnings("deprecation")
		int screenWidth = display.getWidth(); // 屏幕宽（像素，如：480px）
		@SuppressWarnings("deprecation")
		int screenHeight = display.getHeight(); // 屏幕高（像素，如：800p）
		Log.i(TAG, "screenWidth = " + screenWidth + "; screenHeight = " + screenHeight);
		if (screenWidth < screenHeight)
		{
			welcomeImageWidth = screenWidth * 2 / 3;
		}
		else
		{
			welcomeImageWidth = screenHeight * 3 / 4;
		}

		imageManager = AlbumApplication.getImageLoader();
		imageTagFactory = ImageTagFactory.newInstance(welcomeImageWidth, welcomeImageWidth, R.drawable.welcome);
	}

	@Override
	public void onAttach(Activity activity)
	{
		super.onAttach(activity);
		this.activity = activity;
	}

	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		View v = inflater.inflate(R.layout.welcome, null);
		welcomeImage = (ImageView) v.findViewById(R.id.welcome_image);
		return v;
	}

	@Override
	public void onActivityCreated(Bundle savedInstanceState)
	{
		super.onActivityCreated(savedInstanceState);
		new WelcomWebServiceAsyncTask(activity, welcomeImage).execute();
	}

	private class WelcomWebServiceAsyncTask extends AsyncTask<Void, Void, JSONObject>
	{

		private Context			context;
		private HttpResonseDAO	httpResonseDAO;
		private ImageView		imageView;

		public WelcomWebServiceAsyncTask(Context context, ImageView imageView)
		{
			this.context = context;
			this.imageView = imageView;
			httpResonseDAO = HttpResponseFactory.getHttpResonseDAO(context);
		}

		@Override
		protected void onPreExecute()
		{
			super.onPreExecute();
			SherlockFragmentActivity activity = (SherlockFragmentActivity) context;
			activity.setSupportProgressBarIndeterminateVisibility(true);
		}

		@Override
		protected JSONObject doInBackground(Void... params)
		{
			String url = context.getString(R.string.server) + "/interface/appSetting";
			String localJson = httpResonseDAO.findByUri(url);
			Log.i(TAG, "localJson = " + localJson);
			if (localJson != null && !localJson.equals(""))
			{
			}
			else
			{
				HttpUriRequest get = new HttpGet(url);
				try
				{
					HttpResponse response = HttpClientFactory.getHttpClient().execute(get);
					HttpEntity entity = response.getEntity();
					localJson = EntityUtils.toString(entity, "utf-8");
					Log.i(TAG, "response.getStatusLine().getStatusCode() == "
							+ response.getStatusLine().getStatusCode());
					Log.i(TAG, "webJson = " + localJson);
					if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK)
					{
						httpResonseDAO.addOrUpdate(url, localJson);
						entity.consumeContent();
					}
					else
					{
					}
				}
				catch (Exception exception)
				{
					Log.e(TAG, exception.getMessage(), exception);
				}

			}
			JSONObject json = processJsonString(localJson);
			return json;
		}

		private JSONObject processJsonString(String string)
		{
			if (string == null || string.equals(""))
			{
				return null;
			}
			JSONObject json = null;
			try
			{
				json = new JSONObject(string);
			}
			catch (JSONException e)
			{
				Log.e(TAG, e.getMessage(), e);
			}
			return json;
		}

		@Override
		protected void onPostExecute(JSONObject result)
		{
			super.onPostExecute(result);
			SherlockFragmentActivity activity = (SherlockFragmentActivity) context;
			activity.setSupportProgressBarIndeterminateVisibility(false);

			if (result == null)
			{
				return;
			}

			try
			{
				String welcomeUrl = result.getString("appWelcome") + "=s" + welcomeImageWidth;

				imageView.setTag(imageTagFactory.build(welcomeUrl, activity));
				imageManager.getLoader().load(imageView);

			}
			catch (JSONException e)
			{
				Log.e(TAG, e.getMessage(), e);
			}
		}
	}

}
