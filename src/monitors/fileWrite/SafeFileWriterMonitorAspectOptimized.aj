
//*************************************************************************************
//*********************************************************************************** *
//author Aritra Dhar 																* *
//Research Engineer																  	* *
//Xerox Research Center India													    * *
//Bangalore, India																    * *
//--------------------------------------------------------------------------------- * * 
///////////////////////////////////////////////// 									* *
//The program will do the following:::: // 											* *
///////////////////////////////////////////////// 									* *
//version 1.0 																		* *
//*********************************************************************************** *
//*************************************************************************************

package monitors.fileWrite;

import java.io.*;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import callGraphTrace.CircularArray;
import callGraphTrace.TraceData;



public aspect SafeFileWriterMonitorAspectOptimized {

	static volatile CircularArray<SafeFileWriterMonitor> globalList = new CircularArray<>(50);
	static volatile Map<Iterator<?>, SafeFileWriterMonitor> f_m_map = new ConcurrentHashMap<>();
	static volatile String trace = null;
	

	pointcut SafeFileWriter_open1() : (call(FileWriter.new(..))) && !within(SafeFileWriterMonitor) && !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	after () returning (FileWriter f) : SafeFileWriter_open1() 
	{
		if(trace !=null)
		{
			if(trace.equals(TraceData.ca.toString()))
				return;
		}
		
		SafeFileWriterMonitor monitor = null;
		
		
	}

	pointcut SafeFileWriter_write1(FileWriter f) : (call(* write(..)) && target(f)) && !within(SafeFileWriterMonitor) && !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	before (FileWriter f) : SafeFileWriter_write1(f) 
	{
		
	}

	pointcut SafeFileWriter_close1(FileWriter f) : (call(* close(..)) && target(f)) && !within(SafeFileWriterMonitor) && !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	after (FileWriter f) : SafeFileWriter_close1(f) 
	{
		
	}
	
	pointcut SafeFileWriterMonitor_optimized_exit() : (call(* System.nanoTime(..))) && !within(SafeFileWriterMonitor) && !within(SafeFileWriterMonitor) && !adviceexecution();
	before () : SafeFileWriterMonitor_optimized_exit() 
	{
		System.out.println("Exit");
	}

}