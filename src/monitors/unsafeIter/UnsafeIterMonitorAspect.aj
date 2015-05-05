//*************************************************************************************
//*********************************************************************************** *
//author Aritra Dhar																* *
//MT12004																			* *
//M.TECH CSE																		* * 
//INFORMATION SECURITY																* *
//IIIT-Delhi																		* *	 
//---------------------------------------------------------------------------------	* *																				* *
/////////////////////////////////////////////////									* *
//The program will do the following::::         //									* *
/////////////////////////////////////////////////									* *
//version 1.0																		* *
//*********************************************************************************** * 
//*************************************************************************************

package monitors.unsafeIter;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import callGraphTrace.CircularArray;
import callGraphTrace.TraceData;


public aspect UnsafeIterMonitorAspect 
{
	static volatile String trace;
	//this is thw monitor object reference. Whenever  suitable monitor
	//object isfetched, it will be assigned to this
	UnsafeIteratorDfa monitor=null;

	//keep a local pool of monitors in a circular array
	
	static volatile CircularArray<Object> localCircularArray = new CircularArray<>(100);
	
	//This HashMap will contain a mapping from a Iterator object to a
	//monitor object.As we need to follow each iteratoe, I thought it
	//would be better way to manage them
	static volatile Set<Object> monitorSet = new HashSet<>();
	static volatile HashMap<Object, UnsafeIteratorDfa> monitor_map= new HashMap<>();
	static volatile HashMap<Object, Object> Universe=new HashMap<>();


	static long counter=0;
	static long creation_counter=0;
	static long update_counter=0;
	static long next_counter=0;

	static int transition=0;

	static Integer dfa_counter=0;

	/*static Map makeMap(Object key){
			if (key instanceof String) {
				return new HashMap();
			} else {
				return new ReferenceIdentityMap(AbstractReferenceMap.WEAK, AbstractReferenceMap.HARD, true);
			}
		}
	 */
	static List<Object> makeList(){
		return new ArrayList<Object>();
	}


	static HashMap<Object, Object> zero_Map = new HashMap<Object, Object>();
	static HashMap<Object, Object> one_Map= new HashMap<Object, Object>();
	static HashMap<Object, Object> two_Map= new HashMap<Object, Object>();
	static HashMap<Object, Object> three_Map= new HashMap<Object, Object>();

	static List<Object> UnsafeIterator_List = makeList();

	public static void final_printer()
	{
		System.out.println("Final event secquence : "+counter+" transitions : "+transition);	
		System.out.println("Creation counter : "+creation_counter);
		System.out.println("Update counter : "+update_counter);
		System.out.println("Next counter : "+next_counter);
		System.out.println("----------------------------------------------");
		System.out.println("                 All DFA                      ");
		System.out.println("----------------------------------------------");
		Iterator<Object> keys=monitor_map.keySet().iterator();
		
//		while(keys.hasNext())
//		{
//			Object curr_key=keys.next();
//			UnsafeIteratorDfa curr_monitor=monitor_map.get(curr_key);
//			System.out.println("Iterator : "+curr_key.toString()+" total events : "+curr_monitor.dfa_event_counter+" total transitions : "+monitor_map.get(curr_key).dfa_transition+" || dfa :"+monitor_map.get(curr_key).dfa_name);
//
//		}
		
		System.out.println("------------------------------------------------------------------");	
		System.out.println("Total dfa : "+monitor_map.keySet().size());
		System.out.println("------------------------------------------------------------------");	
	}

	@SuppressWarnings("rawtypes")
	pointcut UnsafeIterator_create1(Collection c) : (call(Iterator Collection+.iterator()) && target(c)) && !within(UnsafeIteratorDfa) && !within(UnsafeIterMonitorAspect) && !adviceexecution();
	@SuppressWarnings("rawtypes")
	after (Collection c) returning (Iterator i) : UnsafeIterator_create1(c) 
	{
		//System.out.println(c);
		if(TraceData.ca.toString().equals(trace) && monitorSet.contains(c))
			return;
		
		monitorSet.add(c);
		//System.out.println(TraceData.ca.toString());
		
		UnsafeIteratorDfa monitor_1=new UnsafeIteratorDfa();
		monitor_map.put(i, monitor_1);
		Universe.put(i, c);		

		counter++;
		creation_counter++;

		monitor=monitor_map.get(i);
		monitor.start=1;	
		monitor.dfa_name="dfa_".concat((++dfa_counter).toString());

		//see what is the current state
		int current_state=monitor.state;		
		//call the point cut
		monitor.create(c, i);
		//state after point cut call
		int called_state=monitor.state;	

		//incrase the event count in the particualr dfa
		monitor.dfa_event_counter++;
		if(current_state!=called_state)
			monitor.dfa_transition++;

		//System.out.println("Creation transition from "+current_state+" to "+called_state+" Event sequence : "+counter+" Collection : "+c.toString()+" Iterator : "+i.toString()+" dfa event counter :"+monitor.dfa_event_counter+" of :"+monitor.dfa_name);
		//add c,i to new state_map
		if(called_state==0)
			zero_Map.put(i, c);
		if(called_state==1)
			one_Map.put(i, c);
		if(called_state==2)
			two_Map.put(i, c);
		if(called_state==3)
			three_Map.put(i, c);

		//delete c-i from old state map

		if(current_state==0)
			zero_Map.remove(i);
		if(current_state==1)
			one_Map.remove(i);
		if(current_state==2)
			two_Map.remove(i);
		if(current_state==3)
			three_Map.remove(i);

		if(current_state!=called_state)
			transition++;

		if(called_state==3)
		{
			System.out.println("Unsafe Iterator usage for iterator "+i.toString());
			final_printer();
		}

		monitor_map.put(i, monitor);
		
		trace = TraceData.ca.toString();
	}


	@SuppressWarnings("rawtypes")
	pointcut UnsafeIterator_updatesource1(Collection c) : ((call(* Collection+.remove*(..)) || call(* Collection+.add*(..)) || call(* Collection+.put*(..))) && target(c)) && !within(UnsafeIteratorDfa) && !within(UnsafeIterMonitorAspect) && !adviceexecution();
	@SuppressWarnings("rawtypes")
	before (Collection c) : UnsafeIterator_updatesource1(c) 
	{
		//set of all monitors where c is accessed
		List<UnsafeIteratorDfa> monitor_set=new ArrayList<>();
		Iterator<Object> it_km=monitor_map.keySet().iterator();

		while(it_km.hasNext())
		{
			Object it_comp=it_km.next();
			if(Universe.get(it_comp)==c)
				monitor_set.add(monitor_map.get(it_comp));
		}


		Iterator<UnsafeIteratorDfa> it_m_ex=monitor_set.iterator();

		while(it_m_ex.hasNext())
		{
			monitor=null;
			monitor=it_m_ex.next();

			if(monitor.start==1)
			{
				//start of monitor modification
				counter++;
				update_counter++;

				monitor.dfa_event_counter++;

				//see what is the current state
				int current_state=monitor.state;

				HashSet<Object> key_ret=new HashSet<Object>();


				if(current_state==0)
				{
					Set<Object> keys=zero_Map.keySet();
					Iterator it=keys.iterator();
					while(it.hasNext())
					{
						Object key=it.next();
						if(zero_Map.get(key).equals(c))
						{
							key_ret.add(key);
						}
					}
				}

				if(current_state==1)
				{
					Set<Object> keys=one_Map.keySet();
					Iterator it=keys.iterator();
					while(it.hasNext())
					{
						Object key=it.next();
						if(one_Map.get(key).equals(c))
						{
							key_ret.add(key);
						}
					}
				}

				if(current_state==2)
				{
					Set<Object> keys=two_Map.keySet();
					Iterator it=keys.iterator();
					while(it.hasNext())
					{
						Object key=it.next();
						if(two_Map.get(key).equals(c))
						{
							key_ret.add(key);
						}
					}
				}

				//this is invalid case
				/*if(current_state==3)
				{
					Set<Object> keys=three_Map.keySet();
					Iterator it=keys.iterator();
					while(it.hasNext())
					{
						Object key=it.next();
						//System.out.println("####"+three_Map);
						if(three_Map.get(key).equals(c))
						{
							key_ret.add(key);
						}
					}
				}*/


				//call the point cut
				monitor.updatesource(c);
				///////////////////////

				Iterator<Object> it_key=key_ret.iterator();

				//state after point cut call
				int called_state=monitor.state;	

				if(current_state!=called_state)
					monitor.dfa_transition++;

				//System.out.println("Update transition from "+current_state+" to "+called_state+" Event sequence : "+counter+ " over Collection"+c.toString()+" dfa event counter :"+monitor.dfa_event_counter+" of :"+monitor.dfa_name);

				//add c,i to new state_map

				if(called_state==0)
				{
					while(it_key.hasNext())
						zero_Map.put(it_key.next(),c);
				}

				if(called_state==1)
				{
					while(it_key.hasNext())
						one_Map.put(it_key.next(),c);
				}
				if(called_state==2)
				{
					while(it_key.hasNext())
						two_Map.put(it_key.next(),c);
				}

				if(called_state==3)
				{
					while(it_key.hasNext())
						three_Map.put(it_key.next(),c);
				}

				//delete c-i from old state map

				//Iterator<Object> it_key1=key_ret.iterator();

				while(it_key.hasNext())
				{
					if(current_state==0)
					{
						while(it_key.hasNext())
							zero_Map.remove(it_key.next());
					}

					if(current_state==1)
					{
						while(it_key.hasNext())
							one_Map.remove(it_key.next());
					}

					if(current_state==2)
					{
						while(it_key.hasNext())
							two_Map.remove(it_key.next());
					}

					//this is invalid case
					/*
					if(current_state==3)
					{
						while(it_key.hasNext())
							three_Map.remove(it_key.next());
					}
					 */
				}
				if(current_state!=called_state)
					transition++;

				if(called_state==3)
				{
					System.out.println("Unsafe Iterator usage. Final event secquence : "+counter);
					final_printer();
				}
				//end of monitor modification		

			}	
		}




	}

	@SuppressWarnings("rawtypes")
	pointcut UnsafeIterator_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(UnsafeIteratorDfa) && !within(UnsafeIterMonitorAspect) && !adviceexecution();
	@SuppressWarnings("rawtypes")
	before (Iterator i) : UnsafeIterator_next1(i) 
	{

		monitor=monitor_map.get(i);

		//skip due to redundant monitor
		if(monitor == null)
			return;
		
		if(monitor.start==1)
		{
			counter++;
			next_counter++;
			monitor.dfa_event_counter++;

			//see what is the current state
			int current_state=monitor.state;		
			//call the point cut
			monitor.next(i);
			///////////////////

			//ArrayList<Object> key_list=new ArrayList<Object>();
			Object c=null;

			if(current_state==0)
				c=zero_Map.get(i);
			if(current_state==1)
				c=one_Map.get(i);			
			if(current_state==2)
				c=two_Map.get(i);
			if(current_state==3)
				c=three_Map.get(i);


			//state after point cut call
			int called_state=monitor.state;	
			if(current_state!=called_state)
				monitor.dfa_transition++;

			//System.out.println("Next transition from "+current_state+" to "+called_state+" Event sequence : "+counter+" over Iterator: "+i.toString()+" dfa event counter :"+monitor.dfa_event_counter+" of :"+monitor.dfa_name);


			//add c,i to new state_map
			if(called_state==0)
				zero_Map.put(i, c);
			if(called_state==1)
				one_Map.put(i, c);
			if(called_state==2)
				two_Map.put(i, c);
			if(called_state==3)
				three_Map.put(i, c);

			//delete c-i from old state map

			if(current_state==1)
				zero_Map.remove(i);
			if(current_state==1)
				one_Map.remove(i);
			if(current_state==2)
				two_Map.remove(i);
			//invalid case
			/*
				if(current_state==3)
					three_Map.remove(i);
			 */


			if(current_state!=called_state)
				transition++;

			monitor_map.put(i, monitor);

			if(called_state==3)
			{
				System.out.println("Unsafe Iterator usage. Final event secquence : "+counter);
				final_printer();
			}
		}
	}

	pointcut UnsafeIterator_exit1() : (call(* System.exit(..))) && !within(UnsafeIteratorDfa) && !within(UnsafeIterMonitorAspect) && !adviceexecution();
	before () : UnsafeIterator_exit1() 
	{
		System.out.println("Inside exit. Final event secquence : "+counter+" transitions : "+transition);	
		System.out.println("Creation counter : "+creation_counter);
		System.out.println("Update counter : "+update_counter);
		System.out.println("Next counter : "+next_counter);
		System.out.println("----------------------------------------------");
		System.out.println("                 All DFA                      ");
		System.out.println("----------------------------------------------");
		Iterator<Object> keys=monitor_map.keySet().iterator();
		while(keys.hasNext())
		{
			Object curr_key=keys.next();
			UnsafeIteratorDfa curr_monitor=monitor_map.get(curr_key);
			System.out.println("Iterator : "+curr_key.toString()+" total events : "+curr_monitor.dfa_event_counter+" total transitions : "+monitor_map.get(curr_key).dfa_transition+" || dfa :"+monitor_map.get(curr_key).dfa_name);

		}
		System.out.println("------------------------------------------------------------------");	
		System.out.println("Total dfa : "+monitor_map.size());
		System.out.println("------------------------------------------------------------------");	
		System.out.println("Universal map : " + Universe.size());
	}

}
