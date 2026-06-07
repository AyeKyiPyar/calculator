package com.akps.demo.service;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class Calculator 
{  
   
	@Cacheable(value = "sum")
	public int sum(int a, int b)
	{
		try {
				System.out.println("loading ......");
				Thread.sleep(3000);
				System.out.println(".. end ..");
				
			}
			catch (InterruptedException e) {
				e.printStackTrace();
			}
		return a + b;
	}
}