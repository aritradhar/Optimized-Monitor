package callGraphTrace;

import java.util.HashMap;

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
public class TraceData 
{
	public static final int MONITOR_LIMIT = 3;
	
	public static HashMap<String, Integer> methodIdMap = new HashMap<>();
	public static int[] methodArray = new int[MONITOR_LIMIT];
	public static CircularArray<Integer> ca = new CircularArray<>(3);
	public static boolean message_flag = false;
	
	public static void insert(String methodName)
	{
//		if(!message_flag)
//		{
//			System.err.println("Instrumentation initialized");
//			message_flag = false;
//		}
		
		int id = methodIdMap.containsKey(methodName) ? methodIdMap.get(methodName) : methodIdMap.size() + 1;
		
		//System.out.println(methodName + " : " + id);
		
		if(!methodIdMap.containsKey(methodName))
			methodIdMap.put(methodName, id);
		
		ca.add(id);
		
		//System.out.println(ca);
	}
}
