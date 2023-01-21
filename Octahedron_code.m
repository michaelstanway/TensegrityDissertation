clear;
close all;

n = 6; %number of nodes
d = 3; %number of dimensions    
c = 12; %number of connections
l = 0.02; %length of measurements


n1 = [1/2, 1/sqrt(2), 1/2];
n2 = [0 0 0];
n3 = [1 0 0];
n4 = [1 0 1];
n5 = [0 0 1];
n6= [1/2, -1/sqrt(2), 1/2];

x = [n1(1) n2(1) n3(1) n4(1) n5(1) n6(1)];
y = [n1(2) n2(2) n3(2) n4(2) n5(2) n6(2)];
z = [n1(3) n2(3) n3(3) n4(3) n5(3) n6(3)];

%Line I
xI = [n1(1) n2(1)];
yI = [n1(2) n2(2)];
zI = [n1(3) n2(3)];

%Line II
xII = [n1(1) n3(1)];
yII = [n1(2) n3(2)];
zII = [n1(3) n3(3)];

%Line III
xIII = [n1(1) n4(1)];
yIII = [n1(2) n4(2)];
zIII = [n1(3) n4(3)];

%Line IV
xIV = [n1(1) n5(1)];
yIV = [n1(2) n5(2)];
zIV = [n1(3) n5(3)];

%Line V
xV = [n2(1) n3(1)];
yV = [n2(2) n3(2)];
zV = [n2(3) n3(3)];

%Line VI
xVI = [n3(1) n4(1)];
yVI = [n3(2) n4(2)];
zVI = [n3(3) n4(3)];

%Line VII
xVII = [n4(1) n5(1)];
yVII = [n4(2) n5(2)];
zVII = [n4(3) n5(3)];

%Line VIII
xVIII = [n5(1) n2(1)];
yVIII = [n5(2) n2(2)];
zVIII = [n5(3) n2(3)];

%Line IX
xIX = [n2(1) n6(1)];
yIX = [n2(2) n6(2)];
zIX = [n2(3) n6(3)];

%Line X
xX = [n3(1) n6(1)];
yX = [n3(2) n6(2)];
zX = [n3(3) n6(3)];

%Line XI
xXI = [n4(1) n6(1)];
yXI = [n4(2) n6(2)];
zXI = [n4(3) n6(3)];

%Line XII
xXII = [n5(1) n6(1)];
yXII = [n5(2) n6(2)];
zXII = [n5(3) n6(3)];



figure
plot3(x(1), y(1), z(1), 'o');
hold on
for i = 2:n
    plot3(x(i), y(i), z(i), 'o');
end
plot3(xI, yI, zI)
plot3(xII, yII, zII)
plot3(xIII, yIII, zIII)
plot3(xIV, yIV, zIV)
plot3(xV, yV, zV)
plot3(xVI, yVI, zVI)
plot3(xVII, yVII, zVII)
plot3(xVIII, yVIII, zVIII)
plot3(xIX, yIX, zIX)
plot3(xX, yX, zX)
plot3(xXI, yXI, zXI)
plot3(xXII, yXII, zXII)
hold off

s = [1 1 1 1 2 3 4 5 2 3 4 5];
e = [2 3 4 5 3 4 5 2 6 6 6 6];


R = rigidity_matrix(c, n, x, y, z, s, e);%Find the rigidity matrix

R_T = R.';%Find the transpose
R_squared = R_T*R;%Multiply them
eigenvalues = eig(R_squared);%Find the eigenvalues
frequencies = freq(eigenvalues, l) %Find the frequencies

%Create a function to define the start and end points of a line
function A = line_def(x, y, z, s, e) %A function called line_def which takes a selection of nodes and two integers (s and e) and outputs A, a 2x3 matrix which defines the line segment
        A = zeros(3, 2);
        A(1, 1) = x(s);
        A(2, 1) = y(s);
        A(3, 1) = z(s);
        A(1, 2) = x(e);
        A(2, 2) = y(e);
        A(3, 2) = z(e);
end

function R = rigidity_matrix(c, n, x, y, z, s, e)%Function called regidity_matrix which takes the number of nodes, number of connections, coordinates of the nodes and list of node connections and generates the rigidity matrix from that
    %Create empty matrix to store rigidity matrix
    R = zeros(c, 3*n);
    for i = 1:c
        A = line_def(x, y, z, s(i), e(i));
        p = zeros(1, 3);
        for j = 1:3
            p(j) = A(j, 1)-A(j, 2);
        end
        column_group_s = 3*(s(i)-1)+1;
        column_group_e = 3*(e(i)-1)+1;
        R(i, column_group_s:column_group_s+2) = p;
        R(i, column_group_e:column_group_e+2) = -p;
    end
end

%A function to convert the eigenvalues into frequencies
function f = freq(eigenvalues, l) %A function called freq which returns a list of frequencies after being input with eigenvalues
        a = size(eigenvalues);
        f = zeros(a(1), 1);
        E = abs(eigenvalues);
        for i = 1:a(1)
            f(i) = sqrt(l*E(i));            
        end
end