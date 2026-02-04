package com.akps.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.RestController;

import com.akps.demo.service.Calculator;

@RestController
public class CalculatorController 
{
	@Autowired
	private Calculator calculator;
	
	@GetMapping("/add")
	public String sum(@RequestParam("a") Integer a, @RequestParam("b") Integer b) 
	{
		return String.valueOf(calculator.sum(a, b));
		}
	
	
}
