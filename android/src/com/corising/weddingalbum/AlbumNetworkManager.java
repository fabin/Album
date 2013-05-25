/**
 * Copyright 2012 Novoda Ltd
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */
package com.corising.weddingalbum;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

import android.util.Log;

import com.novoda.imageloader.core.LoaderSettings;
import com.novoda.imageloader.core.exception.ImageNotFoundException;
import com.novoda.imageloader.core.file.util.FileUtil;
import com.novoda.imageloader.core.network.NetworkManager;

/**
 * A NetworkManager reference to UrlNetwrokManager
 */
public class AlbumNetworkManager implements NetworkManager
{

	private static final int	TEMP_REDIRECT	= 307;

	private static final String	TAG				= AlbumNetworkManager.class.getName();

	private FileUtil			fileUtil;
	private LoaderSettings		settings;
	private int					manualRedirects;

	private String				optionImageServerDomain;

	public AlbumNetworkManager(LoaderSettings settings, String optionImageServerDomain)
	{
		this(settings, new FileUtil());
		this.optionImageServerDomain = optionImageServerDomain;
	}

	public AlbumNetworkManager(LoaderSettings settings, FileUtil fileUtil)
	{
		this.settings = settings;
		this.fileUtil = fileUtil;
	}

	@Override
	public void retrieveImage(String url, File f)
	{
		try
		{
			retrieveImageTry(url, f);
		}
		catch (Exception e)
		{
			Log.e(TAG+"1", e.getMessage(), e);
			if (optionImageServerDomain != null && !optionImageServerDomain.equals(""))
			{
				String newUrl = url.replace("ggpht.com", optionImageServerDomain);
				Log.d(TAG, "newUrl = " + newUrl);
				Log.d(TAG, "optionImageServerDomainl = " + optionImageServerDomain);
				try
				{
					retrieveImageTry(newUrl, f);
				}
				catch (Exception e1)
				{
					Log.e(TAG+"2", e1.getMessage(), e1);
				}
			}
			else
			{
				Log.e(TAG + "3", "optionImageServerDomain == " + optionImageServerDomain);
			}
		}
	}

	private void retrieveImageTry(String url, File f) throws Exception
	{

		// url = url.replace("ggpht.com", "binshidai.com");
		Log.d(TAG, "retrieveImageTry(...) url = " + url + "; file = " + f.getAbsolutePath());
		InputStream is = null;
		OutputStream os = null;
		HttpURLConnection conn = null;
		applyChangeonSdkVersion(settings.getSdkVersion());
		try
		{
			conn = openConnection(url);
			conn.setConnectTimeout(settings.getConnectionTimeout());
			conn.setReadTimeout(settings.getReadTimeout());

			handleHeaders(conn);

			if (conn.getResponseCode() == TEMP_REDIRECT)
			{
				redirectManually(f, conn);
			}
			else
			{
				is = conn.getInputStream();
				os = new FileOutputStream(f);
				fileUtil.copyStream(is, os);
			}
		}
		finally
		{
			if (conn != null && settings.getDisconnectOnEveryCall())
			{
				conn.disconnect();
			}
			fileUtil.closeSilently(is);
			fileUtil.closeSilently(os);
		}

	}

	private void handleHeaders(HttpURLConnection conn)
	{
		Map<String, String> headers = settings.getHeaders();
		if (headers != null)
		{
			for (String key : headers.keySet())
			{
				conn.setRequestProperty(key, headers.get(key));
			}
		}
	}

	public void redirectManually(File f, HttpURLConnection conn)
	{
		if (manualRedirects++ < 3)
		{
			retrieveImage(conn.getHeaderField("Location"), f);
		}
		else
		{
			manualRedirects = 0;
		}
	}

	@Override
	public InputStream retrieveInputStream(String url)
	{
		HttpURLConnection conn = null;
		try
		{
			conn = openConnection(url);
			conn.setConnectTimeout(settings.getConnectionTimeout());
			conn.setReadTimeout(settings.getReadTimeout());
			return conn.getInputStream();
		}
		catch (FileNotFoundException fnfe)
		{
			throw new ImageNotFoundException();
		}
		catch (Throwable ex)
		{
			return null;
		}
	}

	protected HttpURLConnection openConnection(String url) throws IOException
	{
		return (HttpURLConnection) new URL(url).openConnection();
	}

	private void applyChangeonSdkVersion(String sdkVersion)
	{
		if (Integer.parseInt(sdkVersion) < 8)
		{
			System.setProperty("http.keepAlive", "false");
		}
	}

}
