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

package callGraphTrace;

import soot.SootMethod;


public class ExcludeMethod 
{
	
	public static boolean excludeMethod(SootMethod methodName)
	{
		String pkg = methodName.getDeclaringClass().getPackageName();
		
		return (methodName.getName().startsWith("<") || pkg.contains("java.lang") 
				|| pkg.contains("java.util") || pkg.contains("sun.security")
				|| pkg.contains("java.security") || pkg.contains("sun.reflect")
				|| pkg.contains("sun.net") || pkg.contains("java.nio")
				|| pkg.contains("sun.misc") || pkg.contains("java.io")
				|| pkg.contains("sun.util") || pkg.contains("java.text")
				|| pkg.contains("sun.nio") || pkg.contains("java.net")
				|| pkg.contains("java.math"));
	}
}
