#include<reg51.h>
#define lcd P2
sbit rs=P3^0;
sbit rw=P3^1;
sbit en=P3^2;
sbit start= P1^0;
sbit stop= P1^5;
sbit finish = P1^6;
sbit party1=P1^1; //Candidate1
sbit party2=P1^2; //Candidate2
sbit party3=P1^3; //Candidate3
sbit party4=P1^4; //Candidate4
sbit led1 = P3^3; // Candidate1 led
sbit led2 = P3^4; // Candidate2 led
sbit led3 = P3^5; // Candidate3 led
sbit led4 = P3^6; // Candidate4 led
sbit buzz = P3^7; //Buzzer
void lcdcmd(char);
void lcdint();
void lcddata(char);
void lcdstring(char *);
void delay(unsigned int);
void longdelay(unsigned int);
void dispaly_vote(unsigned int) ;
void count();
void result();
void check();
unsigned int vote1,vote2,vote3,vote4, stp = 0;
char vote_no[4], cand = 0;
void main() // main program
{
P3 = 0x00;
lcd=0x00;
party1 =party2 = party3 = party4 = 0;
vote1 = vote2 = vote3 = vote4 =0;
start = stop = finish = 0;
lcdint();
top:
lcdcmd(0x81);
lcdstring("Press start to");
lcdcmd(0xc3);
lcdstring("initiate");
while(1)
{
if(start==1)
{
lcdcmd(0x01);
lcdcmd(0x84);
lcdstring("WELCOME!!");
longdelay(200);
lcdcmd(0x01);
lcdcmd(0x81);
lcdstring("CAST YOUR VOTE");
longdelay(100);
lcdcmd(0x01);
lcdstring("P1");
delay(500);
lcdcmd(0x84);
lcdstring("P2");
delay(500);
lcdcmd(0x88);
lcdstring("P3");
delay(500);
lcdcmd(0x8C);
lcdstring("P4");
count();
lcdcmd(0x01);
lcdcmd(0x80);
lcdstring("Voted candidate");
lcdcmd(0xc5);
if(cand == 1)
lcdstring("P1");
if(cand == 2)
lcdstring("P2");
if(cand == 3)
lcdstring("P3");
if(cand == 4)
lcdstring("P4");
longdelay(200);
lcdcmd(0x01);
lcdcmd(0x83);
lcdstring("Thank you!");
longdelay(300);
lcdcmd(0x01);
goto top;
}
if(stop == 1)
{
stp = 1;
}
if(stp == 1)
{
check();
stp = 0;
}
if(finish == 1)
{
while(1)
{
result();
}
}
}
}
void check() // check count
{
lcdcmd(0x01);
lcdstring("P1");
delay(500);
lcdcmd(0x84);
lcdstring("P2");
delay(500);
lcdcmd(0x88);
lcdstring("P3");
delay(500);
lcdcmd(0x8C);
lcdstring("P4");
lcdcmd(0xc0);
dispaly_vote(vote1);
lcdcmd(0xc4);
dispaly_vote(vote2);
lcdcmd(0xc8);
dispaly_vote(vote3);
lcdcmd(0xcc);
dispaly_vote(vote4);
longdelay(300);
}
void result() // Display result
{
int max=0,flag=0;
lcdcmd(0x01);
lcdstring("P1");
delay(500);
lcdcmd(0x84);
lcdstring("P2");
delay(500);
lcdcmd(0x88);
lcdstring("P3");
delay(500);
lcdcmd(0x8C);
lcdstring("P4");
lcdcmd(0xc0);
dispaly_vote(vote1);
lcdcmd(0xc4);
dispaly_vote(vote2);
lcdcmd(0xc8);
dispaly_vote(vote3);
lcdcmd(0xcc);
dispaly_vote(vote4);
if(vote1>max)
{
max=vote1;
}
if(vote2>max)
{
max=vote2;
}
if(vote3>max)
{
max=vote3;
}
if(vote4>max)
{
max=vote4;
}
longdelay(400);
if ( (vote1 == max) && ( vote2 != max) && (vote3 != max)&& (vote4 != max) )
{
flag = 1;
lcdcmd(0x01);
lcdcmd(0x80);
lcdstring("P1");
lcdcmd(0xc5);
lcdstring("WINS");
longdelay(400);
}
if ( (vote2 == max) && ( vote1 != max) && (vote3 != max)&& (vote4 != max) )
{
flag = 1;
lcdcmd(0x01);
lcdcmd(0x80);
lcdstring("P2");
lcdcmd(0xc5);
lcdstring("WINS");
longdelay(400);
}
if ( (vote3 == max) && ( vote2 != max) && (vote1 != max)&& (vote4 != max) )
{
flag = 1;
lcdcmd(0x01);
lcdcmd(0x80);
lcdstring("P3");
lcdcmd(0xc5);
lcdstring("WINS");
longdelay(400);
}
if ( (vote4 == max) && ( vote2 != max) && (vote1 != max)&& (vote3!= max) )
{
flag = 1;
lcdcmd(0x01);
lcdcmd(0x80);
lcdstring("P4");
lcdcmd(0xc5);
lcdstring("WINS");
longdelay(400);
}
if(flag==0)
{
lcdcmd(0x01);
lcdcmd(0x80);
lcdstring("clash between");
lcdcmd(0xc0);
if(vote1==max)
{
lcdstring("P1 ");
}
if(vote2==max)
{
lcdstring("P2 ");
}
if(vote3==max)
{
lcdstring("P3 ");
}
if(vote4==max)
{
lcdstring("P4 ");
}
longdelay(100);
}
}
void dispaly_vote(unsigned int vote) // send 0-9 character values (ASCII)
{
int k,p;
for (k=0; k<=2; k++)
{
vote_no[k]=vote%10;
vote=vote/10;
}
for (p=2; p>=0; p--)
{
lcddata(vote_no[p]+0x30);
}
}
void count() // count votes
{
while(party1==0&&party2==0&&party3==0&&party4==0);
if (party1==1)
{
vote1 = vote1 + 1;
cand = 1;
led1 = 1;
buzz = 1;
longdelay(100);
buzz = 0;
led1 = 0;
}
if (party2==1)
{
vote2 = vote2 + 1;
cand = 2;
led2 = 1;
buzz = 1;
longdelay(100);
buzz = 0;
led2 = 0;
}
if (party3==1)
{
vote3 = vote3 + 1;
cand = 3;
led3 = 1;
buzz = 1;
longdelay(100);
buzz = 0;
led3 = 0;
}
if (party4==1)
{
vote4 = vote4 + 1;
cand = 4;
led4 = 1;
buzz = 1;
longdelay(100);
buzz = 0;
led4 = 0;
}
}
// lcd programming
void delay(unsigned int x)
{
unsigned int i;
for(i=0; i<x; i++);
}
void longdelay(unsigned int u)
{
unsigned int i,j;
for(i=0; i<u; i++)
for(j=0; j<1275; j++);
}
void lcdint()
{
lcdcmd(0x38);
lcdcmd(0x01);
lcdcmd(0x0c);
lcdcmd(0x80);
}
void lcdcmd(char value)
{
lcd = value;
rw=0;
rs=0;
en=1;
delay(500);
en=0;
}
void lcdstring(char *p)
{
while(*p!='\0')
{
lcddata(*p);
delay(2000);
p++;
}
}
void lcddata(char value)
{
lcd = value;
rs=1;
rw=0;
en=1;
delay(500);
en=0;
}