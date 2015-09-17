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

import java.util.Iterator;

public class HasNextMonitor implements Cloneable
{
	public Object clone() 
	{
		try 
		{
			HasNextMonitor ret = (HasNextMonitor) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) 
		{
			throw new InternalError(e.toString());
		}
	}
	int state;
	int event;

	boolean MOP_fail = false;

	public HasNextMonitor () 
	{
		state = 0;
		event = -1;

	}
	synchronized public final void hasnext(Iterator<?> i)
	{
		event = 1;

		switch(state) 
		{
		case 0:
			switch(event) 
			{
			case 1 : state = 1; break;
			default : state = -1; break;
			}
			break;

		case 1:
			switch(event) 
			{
			case 2 : state = 0; break;
			case 1 : state = 1; break;
			default : state = -1; break;
			}

			break;
		default : state = -1;
		}

		MOP_fail = state == -1;
	}
	synchronized public final void next(Iterator<?> i) {
		event = 2;

		switch(state) 
		{
		case 0:
			switch(event) 
			{
			case 1 : state = 1; break;
			default : state = -1; break;
			}
			
			break;
		
		case 1:
			switch(event) 
			{
			case 2 : state = 0; break;
			case 1 : state = 1; break;
			default : state = -1; break;
			}
			break;
			
		default : state = -1;
		}

		MOP_fail = state == -1;
	}
	
	synchronized public final boolean MOP_fail() 
	{
		return MOP_fail;
	}
	
	synchronized public final void reset()
	{
		state = 0;
		event = -1;

		MOP_fail = false;
	}
}
