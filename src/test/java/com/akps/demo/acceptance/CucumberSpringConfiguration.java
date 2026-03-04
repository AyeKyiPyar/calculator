package com.akps.demo.acceptance;

import io.cucumber.spring.CucumberContextConfiguration;
import org.springframework.boot.test.context.SpringBootTest;

import com.akps.demo.CalculatorJenkinsApplication;

@CucumberContextConfiguration
@SpringBootTest(classes = CalculatorJenkinsApplication.class,
        webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
public class CucumberSpringConfiguration 
{
}