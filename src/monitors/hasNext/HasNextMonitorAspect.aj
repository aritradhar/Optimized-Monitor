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


package monitors.hasNext;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import callGraphTrace.CircularArray;
import callGraphTrace.TraceData;

@SuppressWarnings("rawtypes")
public aspect HasNextMonitorAspect 
{
	static volatile CircularArray<HasNextMonitor> globalList = new CircularArray<>(50);
	static volatile Map<Iterator<?>, HasNextMonitor> i_m_map = new ConcurrentHashMap<>();
	
	static volatile String trace = null;
	
	static volatile int creation_counter = 0, next_counter = 0;
	
	static List makeList()
	{
		return new ArrayList();
	}

	
	static Map indexing_lock = new HashMap();


	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) 
	&& !within(HasNextMonitor) && !within(HasNextMonitorAspect) && !adviceexecution();
	after (Iterator i) : HasNext_hasnext1(i) 
	{
		creation_counter++;
		
		if(trace !=null)
		{
			if(trace.equals(TraceData.ca.toString()))
				return;
		}
		
		HasNextMonitor monitor = null;
		
		if(i_m_map.containsKey(i))
			monitor = i_m_map.get(i);
		
		else
			monitor = new HasNextMonitor();
		
		synchronized (monitor) 
		{
			monitor.hasnext(i);
			i_m_map.put(i, monitor);
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

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) 
	&& !within(HasNextMonitor) && !within(HasNextMonitorAspect) && !adviceexecution();
	before (Iterator i) : HasNext_next1(i) 
	{
		next_counter++;
		
		if(!i_m_map.containsKey(i))
		{
			//System.err.print("Improper usage");
			return;
		}
		
		HasNextMonitor monitor = i_m_map.get(i);		

		monitor.next(i);		

		
		if(monitor.MOP_fail)
		{
			//System.err.print("Improper usage");
		}
		
		synchronized (monitor) 
		{
			globalList.delete(monitor);
			globalList.add(monitor);
		}
	}
	
	pointcut UnsafeIterator_exit1() : (call(* System.exit(..))) && !within(HasNextMonitor) && !within(HasNextMonitorAspect) && !adviceexecution();
	before () : UnsafeIterator_exit1() 
	{

		System.out.println("Creation event : " + creation_counter);
		System.out.println("Next event : " + next_counter);
		System.out.println("------------------------------------------------------------------");	
		System.out.println("Total dfa : "+i_m_map.size());
		System.out.println("------------------------------------------------------------------");
		
		//System.out.println("Universal map : " + globalList.size());
	}


}

