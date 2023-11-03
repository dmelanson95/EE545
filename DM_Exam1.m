clear all; clc; cla; clf;
pause_flag = 0;
max_epoch = 200;
P = [
    -3 -2 -3 -2 3 3 2 2 -3 -2 -3 -2 3 3 2 2 0 .5;
    4 4 2.1 2 4 3 4 3 1 1 0 0 2.2 1 2.2 1 4 .5;
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    ];

T = [
    1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 0;
    ];

%Input layer
[R, Q1] = size(P); [S, Q] = size(T);

%Initialize network parameters
figure(1);
plotpv(P(1:R-1,:), T);
Change_Marker
%Initialize weights randomly
W = rand(S,R);
Wp = W(:, 1:R-1);
Bp = W(:,R);

%display initial values
%The input vectors are replotted
plotpv(P(1:R-1,:), T);

plotpc(Wp, Bp);

watchon;
cla;
plotpv(P(1:R-1,:), T);

pause(3);
figure(1);
E=1;
linehandle = plotpc(Wp, Bp);

%sum squared error performance function
epoch = 1;
while (sse(E) && (epoch <= max_epoch))
    Ai = hardlim(W*P);
    Ei = T-Ai;
    dWq = learnp(W, P, [], [], [], [], Ei, [], [], [], [], []);
    W = W+dWq;
    Wp = W(:, R-1);
    Bp = W(:, R);
    linehandle = plotpc(Wp, Bp, linehandle);
    lines = findobj(gcf, 'Type', 'Line');
    Change_LineWidth
    Change_Marker
    drawnow;
    if(pause_flag == 1)
        pause(1);
    end
    A = hardlim(W*P);
    E = T-A;
    epoch = epoch +1;
end
watchoff;
fprintf('\nQuestion 2\n')
fprintf("\nTarget matrix is:\n"); 
fprintf("%2i %2i %2i %2i %2i %2i\n", T);
fprintf("\nOutput is:\n")
fprintf("%2i %2i %2i %2i %2i %2i\n", A);
fprintf('\nWith weights:\n %2f %2f %2f\n', W);

fprintf('\nQuestion 5\n')
fprintf('Values added are:\n')
fprintf('x1 = 0, x2 = 4, bias = 1, Target = 1\n')
fprintf('x1 = 0.5, x2 = 0.5, bias = 1, Target = 0\n')

fprintf('\nQuestion 7+8\n')
fprintf(['Training was successful and the data set is linearly separable because the network\n' ...
    'found the proper classification for the set of data. Further, it is also linearly\nseparable' ...
    ' because a line can be drawn between the points of data with a target of 0 and those\nwith' ...
    ' a target 1.\n'])

a = hardlim(W*P);
testPoint = findobj(gca, 'Type', 'Line');
set(testPoint, 'Color', 'red');
hold on;
plotpv(P(1:R-1, :), T)
Wp = W(:, 1:R-1);
Bp = W(:, R);
plotpc(Wp, Bp);
Change_LineWidth
Change_Marker
hold off;


%Additional points added to network - see last two data sets
%Values of 
%[ x1 = 0 x2 = 4 b = 1 T = 1 ]
%[x1 = 0.5 x2 = 0.5 b = 1 T = 0 ]
%Training was succesful because the network found weights to properly
%classify the problem.
%






