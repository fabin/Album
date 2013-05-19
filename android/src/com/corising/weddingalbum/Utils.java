package com.corising.weddingalbum;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.text.DecimalFormat;

import android.content.Context;
import android.os.Environment;
import android.util.Log;

public class Utils
{
	private static final String	TAG	= Utils.class.getName();

	public static String readableFileSize(long byteValue)
	{
		DecimalFormat df = new DecimalFormat();
		df.setMaximumFractionDigits(1);

		double kb = byteValue / 1024L;
		if (kb <= 1)
		{
			return byteValue + "B";
		}

		double m = kb / 1024L;
		if (m <= 1)
		{
			return df.format(kb) + "KB";
		}

		double g = m / 11024L;
		if (g <= 1)
		{
			return df.format(m) + "M";
		}

		return df.format(g) + "G";

	}

	public static File destFileFromUrl(Context context, String downlaodUrl)
	{
		File appDir = appDir(context);

		URL url;
		try
		{
			url = new URL(downlaodUrl);
			// 每个域名一个文件夹
			String host = url.getHost();
			int port = url.getPort();
			if (port >= 0)
			{
				host = host + "-" + port;
			}
			File hostDir = new File(appDir, host);
			String file = url.getFile();
			File destFile = new File(hostDir.getAbsolutePath() + file);
			File folder = destFile.getParentFile();
			if (!folder.exists())
			{
				folder.mkdirs();
			}
			return destFile;
		}
		catch (IOException e)
		{
			Log.e(TAG, e.getMessage(), e);
		}
		return null;
	}

	private static File appDir(Context context)
	{
		File root = Environment.getExternalStorageDirectory();
		File appsDataHome = new File(root, "appsdata");
		File appDir = new File(appsDataHome, context.getPackageName());
		if (!appDir.exists())
		{
			appDir.mkdirs();
		}
		return appDir;
	}

	public static File pictureCacheDir(Context context)
	{
		return appDir(context);
	}

}
