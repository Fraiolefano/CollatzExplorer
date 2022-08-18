PVector startingPos;
PVector currentPos;
PVector originNumber;

int steps=0;
int cell=50;

int dataStart=0;
int dataEnd=1000;

ArrayList<ArrayList<Integer>>collatzData=new ArrayList<ArrayList<Integer>>();
color bgColor=color(0);
color lineC=color(0,255,127);
int programMode=4;  //0 istogramma, 1 albero numerico , 2 corallo 2D , 3 corallo 3D, 4 manuale
int preX=-1;
int maxStepRange=0;
boolean finished=false;

float angle=radians(5);
int lineLength=5;
int quantityToChange=1;

int algoritm=1;

String programName="CollatzExplorer";

String angleToPrint=nf(degrees(angle),0,0);

int colorationMode=0;

int r=0;
int g=0;
int b=0;

int rotationScene=0;

boolean toAnimate=false;

void setup()
{
  size(1244,700,P3D);
  surface.setTitle(programName);
  frameRate(24);
  
  originNumber=new PVector(40,height-30);
  startingPos=new PVector(width/2,height/2+300,0);
  background(bgColor);
 
  
  textSize(12);
  textAlign(CENTER);
  stroke(50);
  collatzData(algoritm);

  PFont font = createFont("./font/Roboto-Regular.ttf",24);
  textFont(font);
  delay(100);
}

void draw()
{
  display(programMode);
}


void display(int mode) //0 istogramma, 1 albero numerico , 2 corallo 2D , 3 corallo 3D, 4 manuale
{
  switch(mode)
  {
    case 0:  //istogramma
      if (preX!=mouseX)
      {
        background(bgColor);
        drawAxes();
        stroke(lineC);
        currentPos=originNumber.copy();
        for(int num=dataStart;num<collatzData.size();num++)
        {
          line(currentPos.x,originNumber.y,currentPos.x,(originNumber.y-((collatzData.get(num).size()-1)*3)));
          currentPos.x+=1;
        }
               
        highlight();
      }
      break;
      
    case 1:  // albero numerico
      if (!finished)
      {
        for(int num=0;num<collatzData.size();num++)
        {
          currentPos=startingPos.copy();
          int currentNum=num;//int(random(1000000,1000000000));
          steps=0;
          PVector currentDir=new PVector(0,-1);
          
          int currentMaxSteps=collatzData.get(num).size();
          for(int i=0;i<currentMaxSteps;i++)
          {
            currentNum=collatzData.get(num).get(i);
            steps++;
            strokeWeight(1);

            if (steps>currentMaxSteps-(currentMaxSteps/6.0) )//&& steps < currentMaxSteps-(currentMaxSteps/6.0))
            {
              b+=10;
              g+=30;
              r-=10;
            }

            stroke(255,255,255);
            fill(255);
            if (currentNum%2==0)
            {
              currentDir.rotate(angle);
            }
            else
            {
              currentDir.rotate(-angle);
            }
            
            strokeWeight(5);
            point(currentPos.x+(currentDir.x*lineLength),currentPos.y+(currentDir.y*lineLength));
            PVector nextPos=new PVector(currentPos.x+(currentDir.x*lineLength),currentPos.y+(currentDir.y*lineLength));
            PVector perpDir=nextPos.copy().sub(currentPos).rotate(90).normalize().mult(10);
            PVector semiPos=nextPos.copy().sub(currentPos).mult(-0.5f);
            strokeWeight(1);
            line(currentPos.x,currentPos.y,currentPos.x+(currentDir.x*lineLength),currentPos.y+(currentDir.y*lineLength));

            currentPos.x+=(currentDir.x*lineLength);
            currentPos.y+=(currentDir.y*lineLength);
            text(currentNum,currentPos.x+semiPos.x+perpDir.x,currentPos.y+semiPos.y+perpDir.y);
          }
        }
        finished=true;
      }
      break;
      
    case 2:  //corallo 2D
      if (!finished)
      {
        float alpha=255;

        r=0;
        g=0;
        b=0;
        for(int num=0;num<collatzData.size();num++) //1000
        {
          currentPos=startingPos.copy();
          int currentNum=num;//int(random(1000000,1000000000));
          steps=0;
          PVector currentDir=new PVector(0,-1);
          
          setColoration();
          int currentMaxSteps=collatzData.get(num).size();
          //currentMaxSteps=collatzData.get(randomNum).size();
          for(int i=0;i<currentMaxSteps;i++)
          {
            currentNum=collatzData.get(num).get(i);
            //currentNum=collatzData.get(randomNum).get(i);
            steps++;
            strokeWeight(1);
            int dif=currentMaxSteps-steps;
            
            alpha=255-(180*(steps/(float)currentMaxSteps));
            
            if (steps>currentMaxSteps-(currentMaxSteps/6.0) )//&& steps < currentMaxSteps-(currentMaxSteps/6.0))
            {
              b+=10;
              g+=30;
              r-=10;
            }

            stroke(r,g,b,alpha);
            
            if (currentNum%2==0)
            {
              currentDir.rotate(angle);
            }
            else
            {
              currentDir.rotate(-angle);
            }
            switch (colorationMode)
            {
              case 0:
                drawCircles(dif);
                break;
              case 2:
                drawCircles(dif);
                break;
              case 4:
                drawCircles(dif);
                break;
              case 6:
                drawCircles(dif);
                break;
              case 8:
                drawCircles(dif);
                break;
            }
            strokeWeight(3-(2*(steps/(float)currentMaxSteps)));
            line(currentPos.x,currentPos.y,currentPos.x+(currentDir.x*lineLength),currentPos.y+(currentDir.y*lineLength));
            alpha=0;
            currentPos.x+=(currentDir.x*lineLength);
            currentPos.y+=(currentDir.y*lineLength);
          }
        }
        finished=true;
      }
      break;
      
    case 3: //corallo 3D
      if (toAnimate)
      {
        background(bgColor);
        rotationScene+=1;
        finished=false;
      }
      translate(startingPos.x,startingPos.y,startingPos.z);
      rotateY(radians(rotationScene));
      translate(-startingPos.x,-startingPos.y,-startingPos.z);
      if (!finished)
      {
        float alpha=255;

        r=0;
        g=0;
        b=0;
        for(int num=0;num<collatzData.size();num++) //1000
        {
          currentPos=startingPos.copy();
          int currentNum=num;//int(random(1000000,1000000000));

          steps=0;
          PVector currentDir=new PVector(0,-1,0);
          
          setColoration();
          int currentMaxSteps=collatzData.get(num).size();

          for(int i=0;i<currentMaxSteps;i++)
          {
            currentNum=collatzData.get(num).get(i);
            steps++;
            strokeWeight(1);
            int dif=currentMaxSteps-steps;

            alpha=255-(180*(steps/(float)currentMaxSteps));
            
            if (steps>currentMaxSteps-(currentMaxSteps/6.0) )//&& steps < currentMaxSteps-(currentMaxSteps/6.0))
            {
              b+=10;
              g+=30;
              r-=10;
            }

            stroke(r,g,b,alpha);
            
            if (currentNum%2==0)
            {
              currentDir.rotate(angle);
            }
            else
            {
              currentDir.rotate(-angle);
            }
            
            if (currentNum%4==0)
            {
              currentDir.z=0.5;
            }
            else if(currentNum%2==0)
            {
              currentDir.z=-1;
            }  
            
            //if (currentNum%10==0)
            //{
            //  currentDir.z+=1;
            //}
            //else if(currentNum%5==0)
            //{
            //  currentDir.z+=-0.5;
            //}  
            
            switch (colorationMode)
            {
              case 0:
                drawCircles(dif);
                break;
              case 2:
                drawCircles(dif);
                break;
              case 4:
                drawCircles(dif);
                break;
              case 6:
                drawCircles(dif);
                break;
              case 8:
                drawCircles(dif);
                break;
            }
            strokeWeight(3-(2*(steps/(float)currentMaxSteps)));
            line(currentPos.x,currentPos.y,currentPos.z,currentPos.x+(currentDir.x*lineLength),currentPos.y+(currentDir.y*lineLength),currentPos.z+(currentDir.z*lineLength));
            alpha=0;
            currentPos.x+=(currentDir.x*lineLength);
            currentPos.y+=(currentDir.y*lineLength);
            currentPos.z+=(currentDir.z*lineLength);
          }
        }
        finished=true;
      }
      break;
      
    case 4:  //manuale //<>//
      if (!finished)
      {
        background(0);
        textAlign(CENTER);
        fill(255);
        textSize(24);
        text("Collatz explorer",width/2,50);
        textSize(13);
        text("by Fraiolefano",width/2,70);
        
        textSize(20);
        text("Manuale di utilizzo:",width/2,200);
        textAlign(LEFT);
        textSize(16);
        float currentH=300;
        float currentW=(width/2)-200;
        float increaseH=25;
        text("H : Visualizza questo manuale",currentW,currentH);currentH+=increaseH;
        text("1 : Modalità di visualizzazione ad istogramma",currentW,currentH);currentH+=increaseH;
        text("2 : Modalità di visualizzazione ad albero numerico",currentW,currentH);currentH+=increaseH;
        text("3 : Modalità di visualizzazione a corallo 2D",currentW,currentH);currentH+=increaseH;
        text("4 : Modalità di visualizzazione a corallo 3D",currentW,currentH);currentH+=increaseH;
        
        text("A : Cambia l'algoritmo di Collatz da semplificato a normale e viceversa",currentW,currentH);currentH+=increaseH;
        text("C : Cambia la modalità di colorazione",currentW,currentH);currentH+=increaseH;
        text("+ : Aumenta la quantità numerica",currentW,currentH);currentH+=increaseH;
        text("- : Diminuisce la quantità numerica",currentW,currentH);currentH+=increaseH;
        text("click : Assegna una nuova origine alla figura",currentW,currentH);currentH+=increaseH;
        text("mouse wheel : Varia l'angolo di divaricazione ",currentW,currentH);currentH+=increaseH;
        text("mouse wheel + shift : Varia la lunghezza delle ramificazioni ",currentW,currentH);currentH+=increaseH;
        text("spacebar : Avvia o interrompe l'animazione di rotazione nella modalità di visualizzazione 3D ",currentW,currentH);currentH+=increaseH;
        text("right : Ruota il corallo di un grado in senso orario nella modalità di visualizzazione 3D ",currentW,currentH);currentH+=increaseH;
        text("left : Ruota il corallo di un grado in senso antiorario nella modalità di visualizzazione 3D ",currentW,currentH);currentH+=increaseH;
        text("S : Salva la figura ",currentW,currentH);currentH+=increaseH;
        finished=true;
      }
      textAlign(CENTER);
      break; //<>//
  }
}
int collatz(int n)  //algoritmo di base  https://en.wikipedia.org/wiki/Collatz_conjecture
{
  if(n%2==0) //pari
  {
    return n/2;
  }
  else  //dispari
  {
    return (3*n)+1;
  }
}

int collatz2(int n) //algoritmo ridotto
{
  if(n%2==0) //pari
  {
    return n/2;
  }
  else  //dispari
  {
    return  ((3*n)+1)/2;
  }
}
void collatzData(int alg) // 0 , 1 basic algoritm or semplified
{
  int n=dataStart;
  for(int num=dataStart;num<dataEnd;num++)
  {
    n=num+1;
    ArrayList<Integer> currentData=new ArrayList<Integer>();
    ArrayList<Integer> reversedData=new ArrayList<Integer>();
    currentData.add(n);
    if (alg==0)
    {
      while(n!=1)
      {
        n=collatz(n);
        currentData.add(n);
      }    
      
    }
    
    else
    {
      while(n!=1)
      {
        n=collatz2(n);
        currentData.add(n);
      }    
      
    }

    if (maxStepRange<currentData.size())
    {
      maxStepRange=currentData.size()-1;
    }
    
   // println(currentData);
    
    for(int c=currentData.size()-1;c>=0;c--)
    {
      reversedData.add(currentData.get(c));
    }
    collatzData.add(reversedData);
  }
}

void drawAxes()
{
  textAlign(CENTER);
  stroke(255);
  fill(255);
  PVector origin=new PVector(30,height-30);
  
  int lastW=1100;
  line(origin.x,origin.y,origin.x+lastW,origin.y);
  line(origin.x+lastW-20,origin.y+20,origin.x+lastW,origin.y);
  
  line(origin.x,origin.y,origin.x,origin.y-650);
  line(origin.x-20,origin.y-630,origin.x,origin.y-650);
  point(origin.x,origin.y);
  
  line(originNumber.x,originNumber.y-5,originNumber.x,originNumber.y+5);

  for(int c=0;c<22;c++)
  {
    line(originNumber.x+cell*c,originNumber.y-5,originNumber.x+cell*c,originNumber.y+5);
    text(cell*c,originNumber.x+cell*c,origin.y+20);
  }
  
  for(int c=0;c<13;c++)
  {
    line(origin.x-5,originNumber.y-cell*c,origin.x+5,originNumber.y-cell*c);
    text(cell*c/3,originNumber.x-20,origin.y-cell*c);
  }
}

void highlight()
{
  if (mouseX>originNumber.x && mouseX<originNumber.x+collatzData.size())
  {
    stroke(255,0,0);
    int currentNum=int(mouseX-originNumber.x);
    line(mouseX,originNumber.y,mouseX,           originNumber.y-((collatzData.get(currentNum).size()-1)*3));
    
    fill(255,255,0);
    textAlign(LEFT);
    text(currentNum+1 + " : " +(collatzData.get(currentNum).size()-1) ,45,30);
    fill(255,0,0);
    int currentRow=0;
    int currentCol=0;
    for (int n=0;n<collatzData.get(currentNum).size()-1;n++)
    {
      if (n%20==0){currentRow++; currentCol=0;}
      text(collatzData.get(currentNum).get(n),65+(currentCol*50),30+(currentRow*30));
      currentCol++;
    }
    preX=mouseX;
  }
}


void resetFigure(int mode)  // 0 all, 1 partial
{
    if (mode==0)
    {
      collatzData=new ArrayList<ArrayList<Integer>>();
      collatzData(algoritm);
    }

    if ((colorationMode==8 || colorationMode==9) && (programMode!=2 && programMode!=3))
    {
      bgColor=0;
    }
    else if ((colorationMode==8 || colorationMode==9) && (programMode==2 || programMode==3))
    {
      bgColor=255;
    }
    background(bgColor);
    finished=false;
    strokeWeight(1);
    preX=-1;
}

void setColoration()
{
  switch (colorationMode)
    {
      case 0:  //red
        bgColor=0;
        r=(int)random(50,255);
        g=(int)random(0,50);
        b=(int)random(0,25);
        break;
      case 1:
        r=(int)random(50,255);
        g=(int)random(0,50);
        b=(int)random(0,25);
        break;
        
      case 2:  //blu
        b=(int)random(50,255);
        g=(int)random(0,50);
        r=(int)random(0,25);
        break;
      case 3:
        b=(int)random(50,255);
        g=(int)random(0,50);
        r=(int)random(0,25);
        break;

      case 4:  //verde
        
        g=(int)random(50,255);
        r=(int)random(0,0);
        b=(int)random(50,100);
        break;
      case 5:
        g=(int)random(50,255);
        r=(int)random(0,0);
        b=(int)random(50,100);
        break;
        
      case 6:  //bianco
        r=255;
        g=r;
        b=g;
        break;
      case 7:
        r=255;
        g=r;
        b=g;
        break;
        
      case 8:  //nero
        r=0;
        g=r;
        b=g;
        break;
      case 9:
        r=0;
        g=r;
        b=g;
        break;
    }
}
void drawCircles(int dif)
{
    if (dif==0)
    {
      if (steps>maxStepRange/8.0)
      {
        float distFromStartingPoint=PVector.dist(currentPos,startingPos);
        strokeWeight(8* (distFromStartingPoint/450)   );
        point(currentPos.x,currentPos.y,currentPos.z);
      }
    } 
}

void keyReleased()
{
  if (key=='1')
  {
    programMode=0;
    preX=-1;
    println("mode 0");
    resetFigure(1);
  }
  else if(key=='2')
  {
    programMode=1;
    finished=false;
    println("mode 1");
    textAlign(CENTER);
    resetFigure(1);
  }
  else if(key=='3')
  {
    programMode=2;
    resetFigure(1);
  }
  else if(key=='4')
  {
    programMode=3;
    resetFigure(1);
  }
  else if (key=='h')
  {
    if (programMode==4)return;
    programMode=4;
    resetFigure(1);
  }
  
  
  else if(key==CODED && keyCode==RIGHT)
  {
    if (programMode==3)
    {
      rotationScene+=1;
      println("Angolo attuale di rotazione : "+rotationScene);
      resetFigure(1);
    }
  }
  
  else if(key==CODED && keyCode==LEFT)
  {
    if (programMode==3)
    {
      rotationScene-=1;
      println("Angolo attuale di rotazione : "+rotationScene);
      resetFigure(1);
    }
  }  
  
  else if (key=='q')
  {
    if (programMode==4)return;
    quantityToChange*=10;
    if (quantityToChange>1000)quantityToChange=1;
    println("Quantità da variare settata a : "+quantityToChange);
  }
  
  else if (key=='+')
  {
    if (programMode==4)return;
    
    dataEnd+=quantityToChange;

    println("Quantità numerica : "+(dataEnd-dataStart));
    resetFigure(0);
  }
  else if (key=='-')
  {
    if (programMode==4)return;
    
    dataEnd-=quantityToChange;
    
    if (dataEnd<=dataStart)
    {
      dataEnd=dataStart+1;
    }
    println("Quantità numerica : "+(dataEnd-dataStart));
    resetFigure(0);
  }
  else if(key=='a')
  {
    String algType="semplificato";
    if (programMode==4)return;
    if (algoritm==0){ algoritm=1;algType="semplificato";}
    else {algoritm=0; algType="di base";}
    
    println("algoritmo corrente : "+algType);
    resetFigure(0);
  }
  
  
  
  else if (key=='s')
  {
    if (programMode==4)return;
    String timeTitle=year()+"_"+month()+"_"+day()+"-"+hour()+"-"+minute()+"-"+second();
    String figureId=collatzData.size()+"_"+lineLength+"_"+angleToPrint+"_"+algoritm;
    save(programName+"_"+figureId+"_"+timeTitle+".png");  // nomeProgramma_numeroElementi_lunghezzaSegmento_angolo_algoritmo_tempo
    println("Salvata figura corrente");
  }
  
  else if (key=='c')
  {
    if (programMode==4)return;
    if (programMode==2 || programMode==3)
    {
      colorationMode++;
      if (colorationMode>9)
      {
        colorationMode=0;
        bgColor=0;
      }
      else if(colorationMode==8 || colorationMode==9)
      {
        bgColor=255;
      }
      println("Colorazione attuale : "+colorationMode);
      resetFigure(1);
    }
  }
  
  else if ( keyCode==' ')
  {
    if (programMode==3)
    {
      toAnimate=!toAnimate;
      println("Modifica dello stato dell'animazione");
    }
    
  }

  
}

void mousePressed()
{
  if (programMode==4)return;
  startingPos.x=mouseX;
  startingPos.y=mouseY;
  resetFigure(1);
}


boolean isPrime(int nToCheck)
{
  for (int c=2;c<=sqrt(nToCheck);c++)  //another improvement
  {
     if (nToCheck%c==0) {return false;}
  }
  return true;
}

void mouseWheel(MouseEvent e)
{
  if (programMode==4)return;
  if (keyPressed && key==CODED && (keyCode==SHIFT))
  {
    lineLength+=e.getCount();
    println("Lunghezza attuale : "+lineLength);
  }
  else
  {
  angle+= radians(e.getCount());
  angleToPrint=nf(degrees(angle),0,0);
  println("Angolo attuale : "+angleToPrint);
  }
  resetFigure(1);
}
