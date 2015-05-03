package monitors;

import java.util.Collection;
import java.util.Iterator;

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

class UnsafeIteratorMonitor_1 implements Cloneable 
{
	public Object clone() 
	{
		try {
			UnsafeIteratorMonitor_1 ret = (UnsafeIteratorMonitor_1) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	int state;
	int event;
	int start;
	int dfa_event_counter;
	int dfa_transition;
	String dfa_name;

	boolean MOP_match = false;

	public UnsafeIteratorMonitor_1 () {
		state = 0;
		event = -1;
		//start will denote if this particular DFA is stared
		//or not. This will also enforce the DFA to start
		//from state 0.
		start=0;
		//this variable will count the events in each dfa
		dfa_event_counter=0;
		dfa_transition=0;
		dfa_name=new String("");

	}
	synchronized public final void create(Collection c,Iterator i) {
		event = 1;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 1:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 3; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 3;
	}
	synchronized public final void updatesource(Collection c) {
		event = 2;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 1:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 3; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 3;
	}
	synchronized public final void next(Iterator i) {
		event = 3;
		
		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 1:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 3; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 3;
	}
	synchronized public final void exit() {
		event = 4;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 1:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 3; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 3;
	}
	synchronized public final boolean MOP_match() {
		return MOP_match;
	}
	synchronized public final void reset() {
		state = 0;
		event = -1;
		MOP_match = false;
		start=0;
		dfa_event_counter=0;
		dfa_transition=0;
		dfa_name=new String("");
	}
}



public aspect UnsafeIterMonitorAspect {

}
