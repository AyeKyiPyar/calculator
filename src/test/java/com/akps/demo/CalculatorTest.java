package com.akps.demo;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import com.akps.demo.service.Calculator;

public class CalculatorTest 
{
	private Calculator calculator = new Calculator();
	
	@Test
	public void testSum() 
	{
		assertEquals(5, calculator.sum(2, 3));
	}

}
