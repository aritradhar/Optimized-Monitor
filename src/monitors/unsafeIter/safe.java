package monitors.unsafeIter;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

public class safe 
{
	public static void main(String[] args)
	{
		Collection<String> c1=new ArrayList<>();
		c1.add("a");
		c1.add("b");
		c1.add("c");
		c1.add("x");
		Iterator<String> it1=c1.iterator();
		it1.next();
		it1.next();
		//c1.add("y");
		it1.next();
		
		
		Collection<String> c=new ArrayList<>();
		
		
		c.add("a");
		Iterator<String> it=c.iterator();
		//Iterator<String> it_c=c.iterator();
		//while(it.hasNext())
		it.next();
		c.add("d");
		c.add("a");
		c.add("b");
		c1.add("q");
		c1.add("q1");
		//it1.next();
		//it.next();
		c.add("d");
		System.exit(0);
	}

}
