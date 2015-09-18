
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

package monitors.fileWrite;

import java.io.*;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import monitors.hasNext.HasNextMonitor;

import org.apache.commons.collections.map.*;

import callGraphTrace.CircularArray;

import java.lang.ref.WeakReference;

class SafeFileWriterMonitor_optimized implements Cloneable {
	
	static volatile CircularArray<SafeFileWriterMonitor> globalList = new CircularArray<>(50);
	static volatile Map<Iterator<?>, SafeFileWriterMonitor> i_m_map = new ConcurrentHashMap<>();
	static volatile String trace = null;
	
	public Object clone() {
		try {
			SafeFileWriterMonitor_optimized ret = (SafeFileWriterMonitor_optimized) super.clone();
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

	boolean MOP_fail = false;
	boolean MOP_match = false;

	public SafeFileWriterMonitor_optimized () {
		state = 0;
		event = -1;

	}
	synchronized public final void open(FileWriter f) {
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
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 0; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_fail = state == -1
		;
		MOP_match = state == 0;
		{
			this.writes = 0;
		}
	}
	synchronized public final void write(FileWriter f) {
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
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 0; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_fail = state == -1
		;
		MOP_match = state == 0;
		{
			this.writes++;
		}
	}
	synchronized public final void close(FileWriter f) {
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
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 0; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_fail = state == -1
		;
		MOP_match = state == 0;
	}
	synchronized public final boolean MOP_fail() {
		return MOP_fail;
	}
	synchronized public final boolean MOP_match() {
		return MOP_match;
	}
	synchronized public final void reset() {
		state = 0;
		event = -1;

		MOP_fail = false;
		MOP_match = false;
	}
}

public aspect SafeFileWriterMonitor {


	pointcut SafeFileWriter_open1() : (call(FileWriter.new(..))) && !within(SafeFileWriterMonitor_optimized) && !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	after () returning (FileWriter f) : SafeFileWriter_open1() 
	{
		
	}

	pointcut SafeFileWriter_write1(FileWriter f) : (call(* write(..)) && target(f)) && !within(SafeFileWriterMonitor_optimized) && !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	before (FileWriter f) : SafeFileWriter_write1(f) 
	{
		
	}

	pointcut SafeFileWriter_close1(FileWriter f) : (call(* close(..)) && target(f)) && !within(SafeFileWriterMonitor_optimized) && !within(SafeFileWriterMonitorAspectOptimized) && !adviceexecution();
	after (FileWriter f) : SafeFileWriter_close1(f) 
	{
		
	}
	
	pointcut SafeFileWriterMonitor_optimized_exit() : (call(* System.nanoTime(..))) && !within(SafeFileWriterMonitor_optimized) && !within(SafeFileWriterMonitor_optimized) && !adviceexecution();
	before () : SafeFileWriterMonitor_optimized_exit() 
	{
		System.out.println("Exit");
	}

}