%% 2016-05-26, fiedsch@ja-eh.at
%% For more info on the subject see e.g. http://qrohlf.com/trianglify/

% important only if fonts are used
% prologues := 3;

% generate (E)PS
outputtemplate := "%j-%c.mps";

% generate SVG
% outputtemplate := "%j-%c.svg";
% outputformat := "svg";

% Setup rows and columns of the image's grid
rows= 30;
cols=50;

% unit (width and height)
u=1cm;

% randomize result (set to 0 while debugging)
distortion=.2u;
colordistortion=0.1;
% debug
% distortion:=colordistortion:=0;


% colors for the four corners of the image:
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
    ((cols-j)/cols)[nw,ne],
    ((cols-j)/cols)[sw,se]
  ]
enddef;

% lighten a color
def lighten(expr c) =
  0.85[white,c]
enddef;

% set up points
for i=0 upto rows:
  for j=0 upto cols:
    points[i][j] = (j*u,-i*u)
      shifted (normaldeviate*distortion,normaldeviate*distortion);
  endfor;
endfor;

% draw picture

beginfig(1);
  save p; path p;
  pickup pencircle scaled linewidth;
  for i=0 upto rows:
    for j=0 upto cols:
      if (j<cols) and (i<rows):
        p := points[i][j]--points[i][j+1]--points[i+1][j]--cycle;
        fill p withcolor fillcolor(i,j);
        draw p withcolor linecolor;
        p := points[i+1][j]--points[i+1][j+1]--points[i][j+1]--cycle;
        fill p withcolor lighten(fillcolor(i,j));
        draw p withcolor linecolor;
      fi;
    endfor;
  endfor;
endfig;

end
%% EOF %%
