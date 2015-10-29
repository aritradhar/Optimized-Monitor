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


package DS;

import java.util.HashMap;

public class MethodId {

	//method name -> unique id
	public static HashMap<String, Integer> method_id_map = new HashMap<>();
	
	public static void addNewMethod(String methodName)
	{
		if(!method_id_map.containsKey(methodName))
		{
			method_id_map.put(methodName, method_id_map.size() + 1);
		}
	}
	
	public static Integer getId(String methodName)
	{
		if(!method_id_map.containsKey(methodName))
			MethodId.addNewMethod(methodName);
		
		return method_id_map.get(methodName);
	}
}
