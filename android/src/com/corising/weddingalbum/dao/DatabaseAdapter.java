package com.corising.weddingalbum.dao;

import android.content.Context;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import com.corising.weddingalbum.R;

public class DatabaseAdapter
{
	private DatabaseHelper	dbHelper;

	public DatabaseAdapter(Context context)
	{
		int databaseVersion = context.getResources().getInteger(R.integer.database_version);
		this.dbHelper = new DatabaseHelper(context, databaseVersion);
	}

	/**
	 * 打开数据库
	 * 
	 * @return
	 * @throws SQLException
	 */
	public synchronized SQLiteDatabase open() throws SQLException
	{
		return dbHelper.getWritableDatabase();
	}

	/**
	 * 关闭数据库
	 */
	public synchronized void close()
	{
		dbHelper.close();
	}

	private static class DatabaseHelper extends SQLiteOpenHelper
	{
		private static final String	DATABASE_NAME	= "wedding-album.db";
		private Context				context;

		DatabaseHelper(Context context, int database_version)
		{
			super(context, DATABASE_NAME, null, database_version);
			this.context = context;
		}

		@Override
		public void onCreate(SQLiteDatabase db)
		{
			db.execSQL(DatabaseConfig.DDL_TABLE_HTTP_RESPONSE);
		}

		@Override
		public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion)
		{
		}

	}
}
