import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

import com.edsoncesar.HelloWorld;

public class HelloWorldTest {

   private HelloWorld h;
	
   @Before
   public void setUp() throws Exception 
   {
      h = new HelloWorld();
   }

   @Test
   public void testHelloWorld() 
   {
      assertEquals(h.getHelloMessage(), "Hello, World!!!");
   }
}
