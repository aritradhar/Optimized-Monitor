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
package monitors.fileWrite;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.map.AbstractReferenceMap;
import org.apache.commons.collections.map.ReferenceIdentityMap;

class SafeFileMonitor_1 implements Cloneable {
	public Object clone() {
		try {
			SafeFileMonitor_1 ret = (SafeFileMonitor_1) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	static int counter = 0;
	int writes = 0;
	int state;
	int event;

	boolean MOP_start = false;

	public SafeFileMonitor_1 () {
		state = 0;
		event = -1;

	}
	synchronized public final void open(File f) {
		event = 1;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 1:
			switch(event) {
				case 3 : state = 0; break;
				case 2 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 1; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_start = state == 0;
		{
			this.writes = 0;
		}
	}
	synchronized public final void write(File f) {
		event = 2;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 1:
			switch(event) {
				case 3 : state = 0; break;
				case 2 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 1; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_start = state == 0;
		{
			this.writes++;
		}
	}
	synchronized public final void close(File f) {
		event = 3;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 1:
			switch(event) {
				case 3 : state = 0; break;
				case 2 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 1; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_start = state == 0;
	}
	synchronized public final boolean MOP_start() {
		return MOP_start;
	}
	synchronized public final void reset() {
		state = 0;
		event = -1;

		MOP_start = false;
	}
}

public aspect SafeFileMonitorAspect {
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

	static Map SafeFile_f_Map = null;

	pointcut SafeFile_open1(File f) : (call(* open(..)) && target(f)) && !within(SafeFileMonitor_1) && !within(SafeFileMonitorAspect) && !adviceexecution();
	after (File f) : SafeFile_open1(f) {
		boolean skipAroundAdvice = false;
		Object obj = null;

		SafeFileMonitor_1 monitor = null;
		boolean toCreate = false;

		Map m = SafeFile_f_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = SafeFile_f_Map;
				if(m == null) m = SafeFile_f_Map = makeMap(f);
			}
		}

		synchronized(SafeFile_f_Map) {
			obj = m.get(f);

			monitor = (SafeFileMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				monitor = new SafeFileMonitor_1();
				m.put(f, monitor);
			}

		}

		{
			monitor.open(f);
			if(monitor.MOP_start()) {
				System.out.println((++(monitor.counter)) + ":" + monitor.writes);
			}

		}
	}

	pointcut SafeFile_write1(File f) : (call(* write(..)) && target(f)) && !within(SafeFileMonitor_1) && !within(SafeFileMonitorAspect) && !adviceexecution();
	after (File f) : SafeFile_write1(f) {
		boolean skipAroundAdvice = false;
		Object obj = null;

		SafeFileMonitor_1 monitor = null;
		boolean toCreate = false;

		Map m = SafeFile_f_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = SafeFile_f_Map;
				if(m == null) m = SafeFile_f_Map = makeMap(f);
			}
		}

		synchronized(SafeFile_f_Map) {
			obj = m.get(f);

			monitor = (SafeFileMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				monitor = new SafeFileMonitor_1();
				m.put(f, monitor);
			}

		}

		{
			monitor.write(f);
			if(monitor.MOP_start()) {
				System.out.println((++(monitor.counter)) + ":" + monitor.writes);
			}

		}
	}

	pointcut SafeFile_close1(File f) : (call(* close(..)) && target(f)) && !within(SafeFileMonitor_1) && !within(SafeFileMonitorAspect) && !adviceexecution();
	after (File f) : SafeFile_close1(f) {
		boolean skipAroundAdvice = false;
		Object obj = null;

		SafeFileMonitor_1 monitor = null;
		boolean toCreate = false;

		Map m = SafeFile_f_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = SafeFile_f_Map;
				if(m == null) m = SafeFile_f_Map = makeMap(f);
			}
		}

		synchronized(SafeFile_f_Map) {
			obj = m.get(f);

			monitor = (SafeFileMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				monitor = new SafeFileMonitor_1();
				m.put(f, monitor);
			}

		}

		{
			monitor.close(f);
			if(monitor.MOP_start()) {
				System.out.println((++(monitor.counter)) + ":" + monitor.writes);
			}

		}
	}

}

