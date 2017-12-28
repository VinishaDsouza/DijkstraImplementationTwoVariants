 //<>//

BinaryMinHeap<Vertex> heap = new BinaryMinHeap<Vertex>();
Map<Vertex, Double> distance = new HashMap<Vertex, Double>(); 
Map<Vertex, Integer> nodePosition = new HashMap<Vertex, Integer>();
Map<Vertex, Integer> parent = new HashMap<Vertex, Integer>();
Map<Vertex, Vertex> parent2 = new HashMap<Vertex, Vertex>();
private Map<Integer, Vertex> position = new HashMap<Integer, Vertex>();
int count=0;
int count_stale=0;

void settings() {
  size(300, 300);
}

void setup() {
  
  long startTime = System.nanoTime();

  PImage myImage = loadImage("down.jpg");
  myImage.loadPixels();
  //Change the size
  myImage.resize(300,300);
  
  image(myImage, 0, 0);
  int max = 9999999;
  
  ////////////////////////////////first variant/////////////////
  //BinaryMinHeap<Vertex> heap = new BinaryMinHeap<Vertex>();
  //add pixels to priority queue
  for (int i = 0; i < (myImage.width*myImage.height); i++) {
    //println("Width : " + myImage.width);
    Vertex n = new Vertex(i, myImage.pixels[i]);
    position.put(i, n);
    //initialize all nodes to infinity
    heap.add(max, n);
    //count++;
    //println("heap size"+ count);
  }

  myImage.updatePixels();
  decrease_key();

  //**** Comment first variant and comment out this to see the second variant running*********
  ////////////////////////////second variant//////////////
  // for (int i = 0; i < (myImage.width*myImage.height); i++) {
  //  //println("Width : " + myImage.width);
  //  Vertex n = new Vertex(i, myImage.pixels[i]);
  //  position.put(i, n);
  //  //initialize all nodes to infinity
  //  heap.add(max,n);
  // 

 //}

  // myImage.updatePixels();
   //stale_node();

  long timeNeeded = System.nanoTime() - startTime;
  println("Needed "+ timeNeeded*0.000000001 + " seconds."); 
 
}




void decrease_key() {
  loadPixels();
  Vertex sourceVertex = heap.min();
 
  //println(sourceVertex.index);
  heap.decrease(sourceVertex, 0.0);
  distance.put(sourceVertex, (double)0);
  parent.put(sourceVertex, null);
  parent2.put(sourceVertex, null);


  while (!heap.empty()) {
    Node heapNode = heap.extractMinNode();
    //count--;
    
    Vertex current = heapNode.key;
        //println(current.index);

    //update shortest distance of current vertex from source vertex
    distance.put(current, heapNode.weight);
  //sample destination node
  if(current.index==79999)
     printPath(current,current.index);
    
    for (Vertex adjacent : getNeigbours(current)) {

      //when it goes through current vertex
      double newDistance = distance.get(current) + colorDistance(current.c, adjacent.c);

     
      //see if this above calculated distance is less than current distance stored for adjacent vertex from source vertex
      if (heap.getWeight(adjacent) > newDistance) {
        heap.decrease(adjacent, newDistance);
        parent.put(adjacent, current.index);
        parent2.put(adjacent, current);
      }
        
      
    
    }
 
    
    
  }


       
 updatePixels();
}

void printPath(Vertex m,Integer n)
{
//println(n);
   if(m.index==0||n==null)
   return;
   
     //println(parent.get(m));
     
  pixels[n]=color(255);
  printPath(parent2.get(m),parent.get(m));
  
  
}

void stale_node() {

  Vertex sourceVertex = heap.min();
  heap.decrease(sourceVertex, 0.0);
  distance.put(sourceVertex, (double)0);
  parent.put(sourceVertex, null);
  parent2.put(sourceVertex, null);
  
  while (!heap.empty()) {
    Node heapNode = heap.extractMinNode();
    //count_stale--;
    
    Vertex current = heapNode.key;
  
    if (distance.get(current)< heapNode.weight && distance.get(current)!=0)
      continue;         

    //update shortest distance of current vertex from source vertex
    distance.put(current, heapNode.weight);
    

     
    //iterate through all the verticies
    for (Vertex adjacent : getNeigbours(current)) { 
      //add distance of current vertex to edge weight to get distance of adjacent vertex from source vertex
      //when it goes through current vertex
      double newDistance = distance.get(current) + colorDistance(current.c, adjacent.c);
      
      //see if this above calculated distance is less than current distance stored for adjacent vertex from source vertex
      if (heap.getWeight(adjacent) > newDistance) {

        heap.add(newDistance, adjacent);
        //count_stale++;
        distance.put(adjacent, newDistance );
        //parent.put(adjacent, current.index);
        //parent2.put(adjacent, current);
      }
      
       
        
    }
  }

}

public List<Vertex> getNeigbours(Vertex current) {
  List<Vertex> neighbours = new ArrayList<Vertex>();

  //current index
  int i = current.index;
  
  Vertex right = position.get(i+1);
  if (heap.containsData(right)&&((i+1)%width!=0)) {
    neighbours.add(right);
  }

  

  Vertex left = position.get(i-1);
  if (heap.containsData(left)&&(i%width!=0)) {
    neighbours.add(left);
  }

  Vertex up = position.get(i-width);

  if (heap.containsData(up)) {
    neighbours.add(up);
  }

  Vertex down = position.get(i+width);

  if (heap.containsData(down)) {
    neighbours.add(down);
  }
  return neighbours;
}

public double colorDistance(color p, color n) {
  double colordist = (Math.pow(red(p)-red(n), 2)  + Math.pow(green(p)-green(n), 2) +  Math.pow(blue(p)-blue(n), 2));

  //constant is a random value, in this instance we put 1.2
  return Math.sqrt(1+1.2*colordist);
  
}