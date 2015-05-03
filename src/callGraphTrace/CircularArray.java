
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

public class  CircularArray<T>
{
	public int capacity;
	public int top;
	private Object[] array;
	
	public CircularArray(int capacity) 
	{
		this.capacity = capacity;
		top = 0;
		array = new Object[capacity];
	}
	
	public void add(T element)
	{
		if(this.top == this.capacity)
		{
			top = 0;
		}
		this.array[top++] = element;
	}
	
	public void addAll(T[] elements)
	{
		for(T element : elements)
		{
			this.add(element);
		}
	}
	
	private void shiftOneLeft(int pos)
	{
		for(int i = pos; i < capacity - 1; i++)
		{
			this.array[i] = this.array[i + 1];
		}
	}
	
	/**
	 * log n delete complexity
	 * @param pos
	 * @return deleted element
	 */
	@SuppressWarnings("unchecked")
	public T delete(int pos)
	{
		if(pos < 0 || pos > capacity)
			throw new IndexOutOfBoundsException("Capacity " + capacity );
		
		T element = (T) this.array[pos];
		this.shiftOneLeft(pos);
		top--;
		return element;
		
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() 
	{
		String out = new String(""); 
		for(Object ob : this.array)
		{
			if(ob == null)
				break;
			out = out + ob.toString() + ",";
		}
		
		return out;
	}
	
	public Object[] toArray()
	{
		return this.array;
	}
}
