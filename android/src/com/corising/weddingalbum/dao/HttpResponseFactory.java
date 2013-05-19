package com.corising.weddingalbum.dao;

import android.content.Context;

public class HttpResponseFactory
{
	public static HttpResonseDAO getHttpResonseDAO(Context context)
	{
		return new HttpResponseDAOImpl(context.getApplicationContext());
	}
}
