package com.corising.weddingalbum.dao;

public class DatabaseConfig
{
	public static final String	TABLE_HTTP_RESPONSE		= "T_HTTP_RESPONSE";
	public static final String	DDL_TABLE_HTTP_RESPONSE	= "create table "
																+ TABLE_HTTP_RESPONSE
																+ "("
																+ "   URI text not null primary key unique,"
																+ "   RESPONSE text not null"
																+ ")";

}
