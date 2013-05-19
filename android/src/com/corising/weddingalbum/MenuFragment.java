package com.corising.weddingalbum;

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
import android.support.v4.app.ListFragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class MenuFragment extends ListFragment implements OnItemClickListener
{
	private static final String	TAG	= MenuFragment.class.getName();
	private Activity			activity;

	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		return inflater.inflate(R.layout.list, null);
	}

	public void onActivityCreated(Bundle savedInstanceState)
	{
		super.onActivityCreated(savedInstanceState);
		new AlbumsWebServiceAsyncTask(getActivity(), this).execute();
		getListView().setOnItemClickListener(this);
	}

	@Override
	public void onAttach(Activity activity)
	{
		super.onAttach(activity);
		this.activity = activity;
	}

	public static class SampleAdapter extends ArrayAdapter<Album>
	{

		public SampleAdapter(Context context)
		{
			super(context, 0);
		}

		public View getView(int position, View convertView, ViewGroup parent)
		{
			if (convertView == null)
			{
				convertView = LayoutInflater.from(getContext()).inflate(R.layout.row, null);
			}
			Album album = getItem(position);
			ImageView icon = (ImageView) convertView.findViewById(R.id.row_icon);
			icon.setImageResource(album.getIconRes());
			TextView title = (TextView) convertView.findViewById(R.id.row_title);
			title.setText(album.getName());
			convertView.setTag(album);

			return convertView;
		}

	}

	private static class AlbumsWebServiceAsyncTask extends AsyncTask<Void, Void, JSONArray>
	{
		private ListFragment	listFragment;
		private Context			context;

		public AlbumsWebServiceAsyncTask(Context context, ListFragment listFragment)
		{
			this.context = context;
			this.listFragment = listFragment;

		}

		@Override
		protected JSONArray doInBackground(Void... params)
		{
			try
			{
				HttpClient httpclient = new DefaultHttpClient();
				HttpUriRequest get = new HttpGet(context.getString(R.string.server) + "/interface/albums");
				HttpResponse response = httpclient.execute(get);
				HttpEntity entity = response.getEntity();
				String string = EntityUtils.toString(entity, "utf-8");
				entity.consumeContent();
				JSONArray json = new JSONArray(string);
				return json;
			}
			catch (Exception exception)
			{
				Log.e(TAG, exception.getMessage(), exception);
			}
			return null;
		}

		@Override
		protected void onPostExecute(JSONArray result)
		{
			super.onPostExecute(result);
			if (result == null || result.length() < 1)
			{
				Toast.makeText(context, "no albums!", Toast.LENGTH_SHORT).show();
				return;
			}
			SampleAdapter adapter = new SampleAdapter(context);
			for (int i = 0; i < result.length(); i++)
			{
				try
				{
					JSONObject album = result.getJSONObject(i);
					Album albumEntity = new Album(album.getString("name"), android.R.drawable.ic_menu_search);
					String key = album.getString("key");
					albumEntity.setKey(key);
					adapter.add(albumEntity);
					Bundle args = new Bundle();
					args.putParcelable("album", albumEntity);
					((AlbumFragmentChangeSupport) context).addPictureFragment(key, PicturesGridFragment.class, args);
				}
				catch (JSONException e)
				{
					Log.e(TAG, e.getMessage(), e);
				}
			}
			listFragment.setListAdapter(adapter);
		}

	}

	@Override
	public void onItemClick(AdapterView<?> adapterView, View view, int position, long id)
	{
		Album album = (Album) view.getTag();
		((AlbumFragmentChangeSupport) activity).onPictureFragmentChanged(album.getKey());
	}
}
