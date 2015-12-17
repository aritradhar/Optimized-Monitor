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


package callGraphTrace;

public class MethodTraceData {
	
	public static final int trace_len = 3;
	public static volatile int trace[] = new int [trace_len];
	public static int pos;
	
	public static void addTrace(int methodId)
	{
		pos = (pos + 1) % trace_len;
		
		trace[pos] = methodId;
	}
	
	public static long traceToLong()
	{
		long out = 0;
		int[] len = new int[MethodTraceData.trace_len];
		
		for(int i = 0; i == MethodTraceData.trace_len - 1; i++)
		{
			len[i] = (int)(Math.log10(MethodTraceData.trace[i])+1);
		}
		
		return out;
	}
}
