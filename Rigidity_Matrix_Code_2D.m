clear;
close all;

%Define parameters
n = input('Number of nodes: '); %number of nodes
c = input('Number of connections: '); %number of connections
l = input('Unit of length: '); %length of measurements

%Define nodes
[x, y] = deal(zeros(n, 1)); %Create somewhere to store the node values

%Input the values for each node
for i = 1:n 
    disp("~~~~~~~");
    x(i) = input('Input x: ');
    y(i) = input('Input y: ');
end

%This code will display the node coordinates which have been put in
disp("~~~~~~~");
disp([x, y]);
disp("~~~~~~~");

%Input the connections between the nodes
[s, e] = deal(zeros(c, 1)); %Create somewhere to store the start and end nodes

a = 0; %This will allow the user to input the start and end nodes, and use these nodes to find the start and end coordinates of each line segment
for i = 1:c
    s(i) = input('Input start node: ');
    e(i) = input('Input end node: ');
    disp("~~~~~~~")
end

%Find the line boundaries
L = zeros(2*c, 2); %this creates a matrix of zeros to store the coordinate points (allocating this initially saves on processing time)
for i = 1:c
    j = 2*(i-1) + 1;
    L(j:j+1, :) = line_def(x, y, s(i), e(i));
end

%plot the shape
figure %creates a figure
plot(x(1), y(1), 'o'); %plot an initial point
hold on %this will ensure that all other lines and points are plotted to the same figure
for i = 2:n %plot all of the nodes
    plot(x(i), y(i), 'o');
end
for i = 1:c %plot all of the line segments
    j = 2*(i-1) + 1;
    plot(L(j,:), L(j+1,:));
end
hold off

rigidity_matrix(c, n, x, y, s, e)




%Create a function to define the start and end points of a line
function A = line_def(x, y, s, e) %A function called line_def which takes a selection of nodes and two integers (s and e) and outputs A, a 2x3 matrix which defines the line segment
        A = zeros(2, 2);
        A(1, 1) = x(s);
        A(2, 1) = y(s);
        A(1, 2) = x(e);
        A(2, 2) = y(e);
end

function R = rigidity_matrix(c, n, x, y, s, e) %Function called regidity_matrix which takes the number of nodes, number of connections, coordinates of the nodes and list of node connections and generates the rigidity matrix from that
    %Create empty matrix to store rigidity matrix
    R = zeros(c, 2*n);
    for i = 1:c
        A = line_def(x, y, s(i), e(i));
        p = zeros(1, 2);
        for j = 1:2
            p(j) = A(j, 1)-A(j, 2);
        end
        column_group_s = 2*(s(i)-1)+1;
        column_group_e = 2*(e(i)-1)+1;
        R(i, column_group_s:column_group_s+1) = p;
        R(i, column_group_e:column_group_e+1) = -p;
    end
end
