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

import org.apache.commons.collections.map.*;

import callGraphTrace.CircularArray;
import callGraphTrace.TraceData;

@SuppressWarnings("rawtypes")
public aspect HasNextMonitorAspect 
{
	static volatile CircularArray<HasNextMonitor> globalList = new CircularArray<>(50);
	static volatile Map<Iterator<?>, HasNextMonitor> i_m_map = new ConcurrentHashMap<>();
	
	static volatile String trace = null;
	
	Map makeMap(Object key)
	{
		if (key instanceof String) 
		{
			return new HashMap();
		} 
		else 
		{
			return new ReferenceIdentityMap(AbstractReferenceMap.WEAK, AbstractReferenceMap.HARD, true);
		}
	}
	static List makeList()
	{
		return new ArrayList();
	}

	
	static Map indexing_lock = new HashMap();


	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) 
	&& !within(HasNextMonitor) && !within(HasNextMonitorAspect) && !adviceexecution();
	after (Iterator i) : HasNext_hasnext1(i) 
	{
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
		
		monitor.hasnext(i);
		i_m_map.put(i, monitor);
		trace = TraceData.ca.toString();
		
		if(!globalList.search(monitor))
			globalList.add(monitor);
		
		else
		{
			globalList.delete(monitor);
			globalList.add(monitor);
		}
	}

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) 
	&& !within(HasNextMonitor) && !within(HasNextMonitorAspect) && !adviceexecution();
	before (Iterator i) : HasNext_next1(i) 
	{
		
	}

}

