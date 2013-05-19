package com.corising.weddingalbum;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.NetworkInfo.State;

public class NetworkChangedReceiver extends BroadcastReceiver
{
	private static NetworkInfo	netWorkInfo;

	@Override
	public void onReceive(Context context, Intent intent)
	{
		netWorkInfo = (NetworkInfo) intent.getParcelableExtra(ConnectivityManager.EXTRA_NETWORK_INFO);
	}

	private static NetworkInfo getNetWorkInfo(Context context)
	{
		if (netWorkInfo == null)
		{
			ConnectivityManager connectivityManager = (ConnectivityManager) context
					.getSystemService(Context.CONNECTIVITY_SERVICE);
			netWorkInfo = connectivityManager.getActiveNetworkInfo();
		}

		return netWorkInfo;
	}

	public static boolean isNetworkAvailable(Context context)
	{
		NetworkInfo info = getNetWorkInfo(context);
		return info != null && info.getState() == State.CONNECTED;
	}
}
