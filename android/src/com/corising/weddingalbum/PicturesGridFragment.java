package com.corising.weddingalbum;

import java.util.ArrayList;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
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
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.Toast;

import com.actionbarsherlock.app.SherlockFragment;
import com.novoda.imageloader.core.ImageManager;
import com.novoda.imageloader.core.model.ImageTagFactory;

public class PicturesGridFragment extends SherlockFragment implements OnItemClickListener
{
	private static final String	TAG	= PicturesGridFragment.class.getName();
	private PictureAdapter		adapter;
	private Activity			activity;
	private ImageManager		imageManager;
	private ImageTagFactory		imageTagFactory;

	private ArrayList<Picture>	pictures;
	private Album				album;
	private String				thumbnailFlag;

	@Override
	public void onAttach(Activity activity)
	{
		super.onAttach(activity);

		this.activity = activity;
	}

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		pictures = new ArrayList<Picture>();
		album = getArguments().getParcelable("album");
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		View v = inflater.inflate(R.layout.album_pictures_grid, container, false);

		GridView grid = (GridView) v.findViewById(R.id.album_pictures_grid);
		adapter = new PictureAdapter(getActivity());
		grid.setAdapter(adapter);

		grid.setOnItemClickListener(this);

		return v;
	}

	@Override
	public void onActivityCreated(Bundle savedInstanceState)
	{
		super.onActivityCreated(savedInstanceState);
		Display display = activity.getWindowManager().getDefaultDisplay();
		@SuppressWarnings("deprecation")
		int screenWidth = display.getWidth(); // 屏幕宽（像素，如：480px）
		// int screenHeight = display.getHeight(); // 屏幕高（像素，如：800p）

		int numCols = getResources().getInteger(R.integer.pictures_grid_num_cols);
		int padding = getResources().getDimensionPixelSize(R.dimen.pictures_grid_padding);
		int horizontalSpacing = getResources().getDimensionPixelSize(R.dimen.pictures_grid_horizontal_spacing);
		int imageWidth = (screenWidth - padding * 2 - horizontalSpacing * (numCols - 1)) / numCols;
		int imageHeight = getResources().getDimensionPixelSize(R.dimen.pictures_grid_item_height);
		imageManager = AlbumApplication.getImageLoader();
		imageTagFactory = ImageTagFactory.newInstance(imageWidth, imageHeight, R.drawable.ic_launcher);

		thumbnailFlag = "=s" + Math.max(imageWidth, imageHeight) + "c";
		Log.i(TAG, "screenWidth = " + screenWidth + "; numCols = " + numCols);
		Log.i(TAG, "imageWidth = "
				+ imageWidth
				+ "; imageHeight ="
				+ imageHeight
				+ "; thumbnailFlag = "
				+ thumbnailFlag);

		PicturesWebServiceAsyncTask task = new PicturesWebServiceAsyncTask(activity);
		task.execute(album);
	}

	public class PictureAdapter extends BaseAdapter
	{
		private LayoutInflater	mInflater;

		public PictureAdapter(Context c)
		{
			mInflater = (LayoutInflater) c.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		}

		public int getCount()
		{
			return pictures == null ? 0 : pictures.size();
		}

		public Object getItem(int position)
		{
			return position;
		}

		public long getItemId(int position)
		{
			return position;
		}

		public View getView(int position, View convertView, ViewGroup parent)
		{
			ImageView imageView;
			if (convertView == null)
			{
				imageView = (ImageView) mInflater.inflate(R.layout.album_pictures_grid_item, parent, false);
			}
			else
			{
				imageView = (ImageView) convertView;
			}

			String thumbnailUrl = pictures.get(position).getUrl() + thumbnailFlag;
			Log.i(TAG, "thumbnailUrl = " + thumbnailUrl);
			imageView.setTag(imageTagFactory.build(thumbnailUrl, activity));
			imageManager.getLoader().load(imageView);

			return imageView;
		}

	}

	@Override
	public void onItemClick(AdapterView<?> adapterView, View view, int position, long id)
	{

		// Fragment newFragment = new PicturesGalleryFragment();
		//
		// Bundle args = new Bundle();
		// args.putParcelable("server", server);
		// args.putParcelable("category", category);
		// args.putString("title", category.getName());
		// newFragment.setArguments(args);
		//
		// FragmentsSupport tabFragmentsSupport = (FragmentsSupport) activity;
		// tabFragmentsSupport.addFragment(newFragment);

		// Intent intent = new Intent(activity, PictureGalleryActivity.class);
		// intent.putExtra("server", server);
		// intent.putExtra("pictures", pictures);
		// intent.putExtra("position", position);
		// intent.putExtra("backTitle", topActionAgency.getTitleValue());
		// startActivity(intent);

	}

	private class PicturesWebServiceAsyncTask extends AsyncTask<Album, Void, ArrayList<Picture>>
	{
		private Context	context;

		public PicturesWebServiceAsyncTask(Context context)
		{
			this.context = context;
		}

		@Override
		protected ArrayList<Picture> doInBackground(Album... params)
		{
			try
			{
				Album album = params[0];
				HttpClient httpclient = new DefaultHttpClient();
				HttpUriRequest get = new HttpGet(context.getString(R.string.server)
						+ "/interface/album/"
						+ album.getKey());
				HttpResponse response = httpclient.execute(get);
				HttpEntity entity = response.getEntity();
				String string = EntityUtils.toString(entity, "utf-8");
				entity.consumeContent();
				JSONObject json = new JSONObject(string);
				JSONArray jsonPictures = json.getJSONArray("pictures");
				ArrayList<Picture> pictures = new ArrayList<Picture>(jsonPictures.length());
				for (int i = 0; i < jsonPictures.length(); i++)
				{
					try
					{
						JSONObject jsonPicture = jsonPictures.getJSONObject(i);
						Picture picture = new Picture();
						picture.setUrl(jsonPicture.getString("url"));
						pictures.add(picture);
					}
					catch (JSONException e)
					{
						Log.e(TAG, e.getMessage(), e);
					}
				}
				return pictures;
			}
			catch (Exception exception)
			{
				Log.e(TAG, exception.getMessage(), exception);
			}
			return null;
		}

		@Override
		protected void onPostExecute(ArrayList<Picture> result)
		{
			super.onPostExecute(result);
			if (result == null || result.size() == 0)
			{
				Toast.makeText(context, "no pictures!", Toast.LENGTH_SHORT).show();
				return;
			}
			pictures = result;
			adapter.notifyDataSetChanged();
		}

	}

}
