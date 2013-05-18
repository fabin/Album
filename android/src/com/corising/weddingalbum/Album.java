package com.corising.weddingalbum;

import android.os.Parcel;
import android.os.Parcelable;

class Album implements Parcelable
{
	private String	key;
	private String	name;
	private String	cover;
	private String	description;
	private int		iconRes;

	public void setKey(String key)
	{
		this.key = key;
	}

	public String getKey()
	{
		return key;
	}

	public Album(String name, int iconRes)
	{
		this.name = name;
		this.iconRes = iconRes;
	}

	public Album(Parcel in)
	{
		key = in.readString();
		name = in.readString();
		cover = in.readString();
		description = in.readString();
		iconRes = in.readInt();
	}

	public String getName()
	{
		return name;
	}

	public int getIconRes()
	{
		return iconRes;
	}

	@Override
	public int describeContents()
	{
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags)
	{
		dest.writeString(key);
		dest.writeString(name);
		dest.writeString(cover);
		dest.writeString(description);
		dest.writeInt(iconRes);
	}

	public static final Parcelable.Creator<Album>	CREATOR	= new Parcelable.Creator<Album>()
															{
																@Override
																public Album createFromParcel(Parcel in)
																{
																	return new Album(in);
																}

																@Override
																public Album[] newArray(int size)
																{
																	return new Album[size];
																}

															};
}
