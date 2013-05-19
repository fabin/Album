package com.corising.weddingalbum;

import java.util.Calendar;
import java.util.Date;

import android.os.Parcel;
import android.os.Parcelable;

public class Picture implements Parcelable
{
	private String	name;
	private String	url;
	private Date	date;

	public Picture(Parcel in)
	{
		this.name = in.readString();
		this.url = in.readString();
		long longTime = in.readLong();
		if (longTime > 0)
		{
			Calendar calendar = Calendar.getInstance();
			calendar.setTimeInMillis(longTime);
			this.date = calendar.getTime();
		}
	}

	public Picture()
	{
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getUrl()
	{
		return url;
	}

	public void setUrl(String url)
	{
		this.url = url;
	}

	public Date getDate()
	{
		return date;
	}

	public void setDate(Date date)
	{
		this.date = date;
	}

	@Override
	public int describeContents()
	{
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags)
	{
		dest.writeString(name);
		dest.writeString(url);
		dest.writeLong(date == null ? 0L : date.getTime());
	}

	public static final Parcelable.Creator<Picture>	CREATOR	= new Parcelable.Creator<Picture>()
															{
																@Override
																public Picture createFromParcel(Parcel in)
																{
																	return new Picture(in);
																}

																@Override
																public Picture[] newArray(int size)
																{
																	return new Picture[size];
																}

															};

}
