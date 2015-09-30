
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

import java.io.FileWriter;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import callGraphTrace.CircularArray;
import callGraphTrace.TraceData;



public aspect SafeFileWriterMonitorAspectOptimized {

	static volatile CircularArray<Object> globalList = new CircularArray<>(50);
	
	//contains a mapping between FileWriter object and SafeFileWriterMonitor object
	static volatile Map<FileWriter, SafeFileWriterMonitor> f_m_map = new ConcurrentHashMap<>();
	static volatile String trace = null;
	static volatile int creation_counter = 0, write_counter = 0;
	

	pointcut SafeFileWriter_open1() : (call(FileWriter.new(..))) && !within(SafeFileWriterMonitor) 
	&& !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	after () returning (FileWriter f) : SafeFileWriter_open1() 
	{
	
		creation_counter++;
		
		if(trace != null && TraceData.ca.toString().equals(trace))
			return;
		
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
		
		trace = TraceData.ca.toString();
	}

	pointcut SafeFileWriter_write1(FileWriter f) : (call(* write(..)) && target(f)) && !within(SafeFileWriterMonitor) && !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	before (FileWriter f) : SafeFileWriter_write1(f) 
	{
		write_counter++;
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
			System.out.print("Monitor is in error state");
			printStat();
		}
		monitor.write(f);	
		
		//monitor at the error state after write

		if(monitor.MOP_fail())
		{
			System.out.print("Monitor is in error state11");
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
	
	pointcut UnsafeIterator_exit1() : (call(* System.exit(..))) && !within(SafeFileWriterMonitor) && !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	before () : UnsafeIterator_exit1() 
	{

		System.out.println("Creation event : " + creation_counter);
		System.out.println("Write event : " + write_counter);
		System.out.println("------------------------------------------------------------------");	
		System.out.println("Total dfa : "+ f_m_map.size());
		System.out.println("------------------------------------------------------------------");
		
		//System.out.println("Universal map : " + globalList.size());
	}

}