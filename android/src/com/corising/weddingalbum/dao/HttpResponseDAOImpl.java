package com.corising.weddingalbum.dao;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

public class HttpResponseDAOImpl implements HttpResonseDAO
{
	private static final String	TABLE_NAME	= DatabaseConfig.TABLE_HTTP_RESPONSE;
	private DatabaseAdapter		databaseAdapter;

	protected HttpResponseDAOImpl(Context context)
	{
		this.databaseAdapter = new DatabaseAdapter(context);
	}

	@Override
	public void addOrUpdate(String uri, String response)
	{
		SQLiteDatabase db = databaseAdapter.open();

		if (!contantsKey(db, uri))
		{
			ContentValues values = new ContentValues();
			values.put("uri", uri);
			values.put("response", response);

			db.insert(TABLE_NAME, null, values);
		}
		else
		{

			String whereClause = "uri = ?";
			String[] whereArgs = new String[]
			{ uri };
			ContentValues values = new ContentValues();
			values.put("response", response);
			db.update(TABLE_NAME, values, whereClause, whereArgs);
		}
		db.close();
	}

	@Override
	public String findByUri(String uri)
	{
		String response = null;
		String whereClause = "uri = ?";
		String[] whereArgs = new String[]
		{ uri };
		SQLiteDatabase db = databaseAdapter.open();
		Cursor c = db.query(TABLE_NAME, new String[]
		{ "response" }, whereClause, whereArgs, null, null, null);
		if (c != null && c.moveToFirst())
		{
			response = c.getString(0);
		}
		c.close();
		db.close();
		return response;
	}

	private boolean contantsKey(SQLiteDatabase db, String key)
	{
		int count = 0;

		String[] columns = new String[]
		{ "count(*)" };
		String uri = "uri = ?";
		String[] selectionArgs = new String[]
		{ key };
		Cursor c = db.query(TABLE_NAME, columns, uri, selectionArgs, null, null, null);
		if (c != null && c.moveToFirst())
		{
			count = c.getInt(0);
		}
		c.close();
		return count > 0;
	}

}
