#include <conio.h>
#include <iostream.h>
#include <io.h>
#include <fcntl.h>
#include <sys\stat.h>
#include <string.h>
#include <process.h>

struct room_info_type
{
	unsigned left : 1;
	unsigned right : 1;
	unsigned up : 1;
	unsigned down : 1;
	unsigned Is : 4;
};

const int dir_x[4] = {-1,1,0,0};
const int dir_y[4] = {0,0,-1,1};
const char borders[4] = {'º','º','Í','Í'};
const char borders_c[4] = {'¶','Ç','Ï','Ñ'};
const char connectors[4] = {'Ä','Ä','³','³'};

const Nrooms = 20;

char rooms[Nrooms][Nrooms];
int cpx,cpy, x, y;

const char room_basic_image[3][4] = {"É »","   ","È ¼"};
const char room_clear_image[3][4] = {"   ","   ","   "};

void color_room()
{
	int a;
	char room_text[20];
	gettext(x*4+1,y*4+1,x*4+3,y*4+3,room_text);
	for(a=1;a<20;a+=2)
		room_text[a]=LIGHTGREEN;
	puttext(x*4+1,y*4+1,x*4+3,y*4+3,room_text);
}

void uncolor_room()
{
	int a;
	char room_text[20];
	gettext(x*4+1,y*4+1,x*4+3,y*4+3,room_text);
	for(a=1;a<20;a+=2)
		room_text[a]=LIGHTGRAY;
	puttext(x*4+1,y*4+1,x*4+3,y*4+3,room_text);
}


void draw_room(int a, int b)
{
	int c;
	for (c=0;c<3;c++)
	{
		gotoxy(a*4+1,b*4+1+c);
		cputs(room_basic_image[c]);
	}
	for(c=0;c<4;c++)
	{
		if ((!(((a+cpx==0)&&(c==0))||((a+cpx==Nrooms-1)&&(c==1))||((b+cpy==0)&&(c==2))||((b+cpy==Nrooms-1)&&(c==3))))&&(rooms[cpx+a][cpy+b]&(1<<c)))
		{
			if (!(((a==0)&&(c==0))||((b==0)&&(c==2))))
			{
				gotoxy(a*4+2+dir_x[c]*2,b*4+2+dir_y[c]*2);
				putch(connectors[c]);
			}
			gotoxy(a*4+2+dir_x[c],b*4+2+dir_y[c]);
			putch(borders_c[c]);
		}
		else
		{
			gotoxy(a*4+2+dir_x[c],b*4+2+dir_y[c]);
			putch(borders[c]);
		}
	}
}

void draw_diagram()
{
	clrscr();
	int a,b;
	for(a=0;a<20;a++)
		for(b=0;b<6;b++)
			if(rooms[cpx+a][cpy+b])
				draw_room(a,b);
	color_room();
}


void creat_room_link(int dir)
{
	int c;
	if (rooms[cpx+x+dir_x[dir]][cpy+y+dir_y[dir]]&0x0f)
	{
		// In case there is no link - create it.
		if ((rooms[cpx+x+dir_x[dir]][cpy+y+dir_y[dir]]&(1<<((dir/2)*2+1-(dir%2))))==0)
		{
			rooms[cpx+x][cpy+y] |= (1<<dir);
			rooms[cpx+x+dir_x[dir]][cpy+y+dir_y[dir]] |= (1<<((dir/2)*2+1-(dir%2)));
			draw_room(x,y);
			color_room();
			if ((x+dir_x[dir]!=20)&&(y+dir_y[dir]!=6)&&(x+dir_x[dir]!=-1)&&(y+dir_y[dir]!=-1))
				draw_room(x+dir_x[dir],y+dir_y[dir]);
		}
		// In case the other room is linked to another room except the (x,y) room, delete the link.
		else if (rooms[cpx+x+dir_x[dir]][cpy+y+dir_y[dir]]&(15-(1<<((dir/2)*2+1-(dir%2)))))
		{
			rooms[cpx+x][cpy+y] &= 255-(1<<dir);
			rooms[cpx+x+dir_x[dir]][cpy+y+dir_y[dir]] &= 255 - (1<<((dir/2)*2+1-(dir%2)));
			gotoxy(x*4+2+dir_x[dir]*2,y*4+2+dir_y[dir]*2);
			putch(' ');
			draw_room(x,y);
			color_room();
			if ((x+dir_x[dir]!=19)&&(y+dir_y[dir]!=5))
				draw_room(x+dir_x[dir],y+dir_y[dir]);
		}
		// If it is isn't - delete it.
		else
		{
			if ((x+dir_x[dir]!=20)&&(y+dir_y[dir]!=6)&&(x+dir_x[dir]!=-1)&&(y+dir_y[dir]!=-1))
				for (c=0;c<3;c++)
				{
					gotoxy((x+dir_x[dir])*4+1,(y+dir_y[dir])*4+1+c);
					cputs(room_clear_image[c]);
				}
			gotoxy(x*4+2+dir_x[dir]*2,y*4+2+dir_y[dir]*2);
			putch(' ');
			rooms[cpx+x+dir_x[dir]][cpy+y+dir_y[dir]] = 0;
			rooms[cpx+x][cpy+y] &= 255-(1<<dir);
			draw_room(x,y);
			color_room();
		}
	}
	else // The room doesn't exist - creat it.
	{
		rooms[cpx+x][cpy+y] |= (1<<dir);
		rooms[cpx+x+dir_x[dir]][cpy+y+dir_y[dir]] = 16|(1<<((dir/2)*2+1-(dir%2)));
		draw_room(x,y);
		color_room();
		if ((x+dir_x[dir]!=20)&&(y+dir_y[dir]!=6)&&(x+dir_x[dir]!=-1)&&(y+dir_y[dir]!=-1))
			draw_room(x+dir_x[dir],y+dir_y[dir]);
	}
}


int main()
{
	int handle,a,b,c,x1=Nrooms,x2=0,y1=Nrooms,y2=0;
	char filename_b[60], filename[60];
	cpx=cpy=x=0;
	// Start-Up
	cout << "Please enter the filename (without the extension): ";
	cin >> filename_b;
	strcpy(filename,filename_b);
	strcat(filename, ".MAP");
	if (!access(filename,0))
	{
		handle = open(filename, O_RDONLY|O_BINARY);
		if (handle == -1)
		{
			cerr << "\nFile access denied. Please try again!";
			close(handle);
			exit(-1);
		}
		if (filelength(handle)!= Nrooms*Nrooms)
		{
			cerr << "\nFile is too long or too short!";
			close(handle);
			exit(-1);
		}
		read(handle,&rooms[0][0],Nrooms*Nrooms);
		close(handle);
		y=0; while(rooms[0][y]==0) y++;
		cpy = (y/6)*6;
		y%= 6;
	}
	else
	{
		for(a=0;a<Nrooms;a++)
			for(b=0;b<Nrooms;b++)
				rooms[a][b] = 0;
		cout << "Please enter the y coordinate of the room you want to start from - \n";
		cin >> y; cpy = (y/6)*6; y %= 6;
		rooms[x][y]=16;
	}
	_setcursortype(_NOCURSOR);
	draw_diagram();
	while ((a=getch())!='q')
	{
		switch(a)
		{
			case 0:
			a=getch();
			switch(a)
			{
				case 75: //left
				if (rooms[cpx+x][cpy+y]&1)
					if(x==0)
						if(cpx!=0)
						{
							cpx-=20;
							x=19;
							draw_diagram();
						}
						else ;
					else
					{
						uncolor_room();
						x--;
						color_room();
					}
				break;
				case 77: //right
				if (rooms[cpx+x][cpy+y]&2)
					if(x==19)
					{
						cpx+=20;
						x=0;
						draw_diagram();
					}
					else
					{
						uncolor_room();
						x++;
						color_room();
					}
				break;
				case 72: //up
				if (rooms[cpx+x][cpy+y]&4)
					if(y==0)
						if(cpy!=0)
						{
							cpy-=6;
							y=5;
							draw_diagram();
						}
						else ;
					else
					{
						uncolor_room();
						y--;
						color_room();
					}
				break;
				case 80: //down
				if (rooms[cpx+x][cpy+y]&8)
					if(y==5)
					{
						cpy+=6;
						y=0;
						draw_diagram();
					}
					else
					{
						uncolor_room();
						y++;
						color_room();
					}
			}
			break;
			case '4': // = SHIFT+LEFT
			if (x+cpx)
				creat_room_link(0);
			break;
			case '6':
			if (x+cpx!=Nrooms)
				creat_room_link(1);
			break;
			case '8':
			if (y+cpy)
			creat_room_link(2);
			break;
			case '2':
			if (y+cpy!=Nrooms)
				creat_room_link(3);
			break;
		}
	}
	_fmode = O_BINARY;
	handle = creat(filename,S_IWRITE);
	write(handle,&rooms[0][0],Nrooms*Nrooms);
	close(handle);
	_fmode = O_TEXT;
	strcpy(filename,filename_b);
	strcat(filename,".TXT");
	handle = creat(filename,S_IWRITE);
	for(a=0;a<Nrooms;a++)
		for(b=0;b<Nrooms;b++)
		{
			if((a<x1)&&rooms[a][b])
				x1 = a;
			if((a>x2)&&rooms[a][b])
				x2 = a;
			if((b<y1)&&rooms[a][b])
				y1 = b;
			if((b>y2)&&rooms[a][b])
				y2 = b;
		}

	for(b=y1*4;b<y2*4+3;b++)
	{
		for(a=x1*4;a<x2*4+3;a++)
		{
			if (rooms[a>>2][b>>2])
			{
				if ((a%2==0)&&(b%2==0))
					write(handle,&room_basic_image[b%4][a%4],1);
				else
				{
					for(c=0;c<4;c++)
						if ((a%4==1+dir_x[c])&&(b%4==1+dir_y[c]))
						{
							if (rooms[a>>2][b>>2]&(1<<c))
								write(handle,&borders_c[c],1);
							else
								write(handle,&borders[c],1);
							break;
						}
						else if ((a%4==1+2*dir_x[c])&&(b%4==1+2*dir_y[c])&&(rooms[a>>2][b>>2]&(1<<c)))
						{
							write(handle,&connectors[c],1);
							break;
						}
					if (c==4)
						write(handle," ",1);
				}
			}
			else write(handle, " ", 1);
		}
		write(handle,"\n",1);
	}
	close(handle);
	return 0;
}