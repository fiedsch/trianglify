% 2016-05-26, fiedsch@ja-eh.at
% License: MIT
% For more info on the subject see e.g. http://qrohlf.com/trianglify/

% important only if fonts are used
% prologues := 3;

% generate (E)PS

outputtemplate := "%j-%c.mps";

% generate SVG

% outputtemplate := "%j-%c.svg";
% outputformat := "svg";

% generate PNG

% outputtemplate := "%j-%c.png";
% outputformat := "png";

% Setup rows and columns of the image's grid

rows=30;
cols=50;

% unit (width and height)

u=1cm;

% randomize results (set to 0 while debugging)

poistiondistortion=.20u;
colordistortion=0.025;


% colors for the four corners of the image
% the parts in between will be interpolated
% nw ... north west
% ne ... north east
% sw .. south west
% se ... south east

color nw,ne,sw,se;
nw = 0.3[white,(20/255,245/255,255/255)];
ne = green;
sw = blue;
se = 0.3[white, black];

% line color and line width (set line width to 0 to disable drawing of lines)

color linecolor; linecolor=0.2[white,black];
linewidth:= .3pt;

% grid coordinates (see below for setup)

pair points[][];

% get fillcolor depending on position (optionally randomized)

def fillcolor(expr i,j) =
  (((rows-i)/rows)+colordistortion*normaldeviate)
  [
    (((cols-j)/cols)+colordistortion*normaldeviate)[nw,ne],
    (((cols-j)/cols)+colordistortion*normaldeviate)[sw,se]
  ]
enddef;

% lighten a color

def lighten(expr c) =
  0.05[c,white]
enddef;

% set up points (coordinates of the image parts)

def setpoints =
  for i=0 upto rows:
    for j=0 upto cols:
      points[i][j] := (j*u,-i*u)
        shifted (normaldeviate*poistiondistortion,normaldeviate*poistiondistortion);
    endfor;
  endfor;
enddef;

% draw one piece of the image

def drawpart(expr i,j) =
  save p; path p[];
  % base for the current part is a rectangular shape
  % x---x
  % |   |
  % x---x
  p[0]=points[i][j]--points[i][j+1]--points[i+1][j+1]--points[i+1][j]--cycle;
  % next, divide rectangular into two triangles sw to ne or nw to se
  % x---x      x---x
  % | / |  or  | \ |
  % x---x      x---x
  if normaldeviate < 0:
    p[1] := point 1 of p[0]--point 2 of p[0]--point 4 of p[0]--cycle;
    p[2] := point 2 of p[0]--point 3 of p[0]--point 4 of p[0]--cycle;
  else:
    p[1] := point 1 of p[0]--point 2 of p[0]--point 3 of p[0]--cycle;
    p[2] := point 3 of p[0]--point 4 of p[0]--point 1 of p[0]--cycle;
  fi
  fill p[1] withcolor fillcolor(i,j);
  fill p[2] withcolor fillcolor(i,j);
  draw p[1] withcolor linecolor;
  draw p[2] withcolor linecolor;
enddef;

% draw the full picture

def drawpicture =
  pickup pencircle scaled linewidth;
  for i=0 upto rows:
    for j=0 upto cols:
      if (j<cols) and (i<rows):
        drawpart(i,j);
      fi;
    endfor;
  endfor;
enddef;

beginfig(1);
  % debug: no distortion
  save poistiondistortion, colordistortion;
  poistiondistortion:=colordistortion:=0;
  setpoints;
  drawpicture;
endfig;

beginfig(2);
  setpoints;
  drawpicture;
endfig;

end
%% EOF %%
