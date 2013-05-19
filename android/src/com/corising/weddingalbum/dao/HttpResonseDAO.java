package com.corising.weddingalbum.dao;

public interface HttpResonseDAO
{
	public void addOrUpdate(String uri, String response);

	public String findByUri(String uri);
}
