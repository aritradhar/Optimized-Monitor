
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

import monitors.hasNext.HasNextMonitor;
import callGraphTrace.CircularArray;
import callGraphTrace.TraceData;



public aspect SafeFileWriterMonitorAspectOptimized {

	static volatile CircularArray<SafeFileWriterMonitor> globalList = new CircularArray<>(50);
	//contains a mapping between FileWriter object and SafeFileWriterMonitor object
	static volatile Map<FileWriter, SafeFileWriterMonitor> f_m_map = new ConcurrentHashMap<>();
	static volatile String trace = null;
	

	pointcut SafeFileWriter_open1() : (call(FileWriter.new(..))) && !within(SafeFileWriterMonitor) 
	&& !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	after () returning (FileWriter f) : SafeFileWriter_open1() 
	{
		
		if(trace !=null)
		{
			if(trace.equals(TraceData.ca.toString()))
			{}	
		}
		
		SafeFileWriterMonitor monitor = null;
		
		if(f_m_map.containsKey(f))
			monitor = f_m_map.get(f);
		
		else
		{
			monitor = new SafeFileWriterMonitor();
			System.out.println("Monitor created");
		}
		
		if(monitor.MOP_fail())
		{
			System.out.println("Monitor is at error state");
			printStat();
		}
		
		synchronized (monitor) 
		{
			monitor.open(f);
			f_m_map.put(f, monitor);
			trace = TraceData.ca.toString();
		}
		
		if(!globalList.search(monitor))
		{
			synchronized (monitor) 
			{
				globalList.add(monitor);
			}
		}
		
		else
		{
			synchronized (monitor) 
			{
				globalList.delete(monitor);
				globalList.add(monitor);
			}
		}
	}

	pointcut SafeFileWriter_write1(FileWriter f) : (call(* write(..)) && target(f)) && !within(SafeFileWriterMonitor) && !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	before (FileWriter f) : SafeFileWriter_write1(f) 
	{
		
		System.out.println("write event");
		if(!f_m_map.containsKey(f))
		{
			System.out.print("Improper usage");
			printStat();
			return;
		}
		
		SafeFileWriterMonitor monitor = f_m_map.get(f);		

		//if the monitor is already at error state
		if(monitor.MOP_fail())
		{
			System.err.print("Monitor is in error state");
			printStat();
		}
		monitor.write(f);	
		
		//monitor at the error state after write

		if(monitor.MOP_fail())
		{
			System.out.print("Monitor is in error state");
			printStat();
		}
		
		synchronized (monitor) 
		{
			globalList.delete(monitor);
			globalList.add(monitor);
		}
	}

	pointcut SafeFileWriter_close1(FileWriter f) : (call(* close(..)) && target(f)) && !within(SafeFileWriterMonitor) && !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	after (FileWriter f) : SafeFileWriter_close1(f) 
	{
		if(!f_m_map.containsKey(f))
		{
			System.out.print("Improper usage");
			printStat();
			return;
		}
		
		SafeFileWriterMonitor monitor = f_m_map.get(f);		

		monitor.close(f);
	}
	
	pointcut SafeFileWriterMonitor_optimized_exit() : (call(* System.exit(..))) && !within(SafeFileWriterMonitor) && !within(SafeFileWriterMonitor) && !adviceexecution();
	before () : SafeFileWriterMonitor_optimized_exit() 
	{
		printStat();	
	}
	
	public static void printStat()
	{
		System.out.println("\nExit");
		System.out.println("Total monitors : " + f_m_map.size());
	}

}