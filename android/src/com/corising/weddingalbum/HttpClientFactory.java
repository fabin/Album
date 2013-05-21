package com.corising.weddingalbum;

import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;

public class HttpClientFactory
{
	private static final int	REQUEST_TIMEOUT	= 3000;
	private static final int	SO_TIMEOUT		= 30000;
	private static HttpClient	httpClient;

	private static void init()
	{
		BasicHttpParams httpParams = new BasicHttpParams();
		HttpConnectionParams.setConnectionTimeout(httpParams, REQUEST_TIMEOUT);
		HttpConnectionParams.setSoTimeout(httpParams, SO_TIMEOUT);
		httpClient = new DefaultHttpClient(httpParams);
	}

	public static HttpClient getHttpClient()
	{
		if (httpClient == null)
		{
			init();
		}
		return httpClient;
	}
}
