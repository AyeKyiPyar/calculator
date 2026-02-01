package com.akps.demo.service;

import org.springframework.stereotype.Service;

@Service
public class Calculator 
{
	public int sum(int a, int b)
	{
		return a + b;
	}
}