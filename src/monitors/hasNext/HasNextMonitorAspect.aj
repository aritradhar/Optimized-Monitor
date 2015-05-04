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

import org.apache.commons.collections.map.*;

public aspect HasNextMonitorAspect 
{
	static Map makeMap(Object key){
		if (key instanceof String) {
			return new HashMap();
		} else {
			return new ReferenceIdentityMap(AbstractReferenceMap.WEAK, AbstractReferenceMap.HARD, true);
		}
	}
	static List makeList(){
		return new ArrayList();
	}

	static Map indexing_lock = new HashMap();

	static Map HasNext_i_Map = null;

	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) && !within(HasNextMonitor) && !within(HasNextMonitorAspect) && !adviceexecution();
	after (Iterator i) : HasNext_hasnext1(i) {
		boolean skipAroundAdvice = false;
		Object obj = null;

		HasNextMonitor monitor = null;
		boolean toCreate = false;

		Map m = HasNext_i_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = HasNext_i_Map;
				if(m == null) m = HasNext_i_Map = makeMap(i);
			}
		}

		synchronized(HasNext_i_Map) {
			obj = m.get(i);

			monitor = (HasNextMonitor) obj;
			toCreate = (monitor == null);
			if (toCreate){
				monitor = new HasNextMonitor();
				m.put(i, monitor);
			}

		}

		{
			monitor.hasnext(i);
			if(monitor.MOP_fail()) {
				System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				monitor.reset();
			}

		}
	}

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(HasNextMonitor) && !within(HasNextMonitorAspect) && !adviceexecution();
	before (Iterator i) : HasNext_next1(i) {
		boolean skipAroundAdvice = false;
		Object obj = null;

		HasNextMonitor monitor = null;
		boolean toCreate = false;

		Map m = HasNext_i_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = HasNext_i_Map;
				if(m == null) m = HasNext_i_Map = makeMap(i);
			}
		}

		synchronized(HasNext_i_Map) {
			obj = m.get(i);

			monitor = (HasNextMonitor) obj;
			toCreate = (monitor == null);
			if (toCreate){
				monitor = new HasNextMonitor();
				m.put(i, monitor);
			}

		}

		{
			monitor.next(i);
			if(monitor.MOP_fail()) {
				System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				monitor.reset();
			}

		}
	}

}

